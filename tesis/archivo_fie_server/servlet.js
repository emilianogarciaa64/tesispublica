require('dotenv').config();
const express = require('express');
const multer = require('multer');
const fs = require('fs');
const fsp = require('fs/promises');
const axios = require('axios');
const FormData = require('form-data');
const path = require('path');
const crypto = require('crypto');
const jwt = require('jsonwebtoken');
const { Pool } = require('pg');


const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// === Paths base ===
const BASE_DIR = process.env.BASE_DIR;
const pdfFolderPath = BASE_DIR;
const OCR_SERVICE_URL = process.env.OCR_SERVICE_URL;
// === DB ===
const dbClient = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  max: 20,                    // conexiones máximas en el pool
  idleTimeoutMillis: 30000,   // cierra conexiones ociosas
  connectionTimeoutMillis: 50000, 
});
const PDFJS_DIR = path.join(__dirname, 'public', 'pdfjs');

app.use('/pdfjs', express.static(PDFJS_DIR, {
  setHeaders(res, filePath) {
    // ⭐ CRÍTICO: Agrega .js además de .mjs
    if (filePath.endsWith('.js') || filePath.endsWith('.mjs')) {
      res.setHeader('Content-Type', 'text/javascript; charset=UTF-8');
    }
    if (filePath.endsWith('.wasm')) {
      res.setHeader('Content-Type', 'application/wasm');
    }
    // Opcional: evita cache agresivo durante desarrollo
    res.setHeader('Cache-Control', 'no-store');
  }
}));
// === JWT helpers ===
function signToken(payload) {
  return jwt.sign(payload, process.env.JWT_SECRET, { expiresIn: '1h' });
}

const verifyToken = (req, res, next) => {
  let token = req.headers['authorization'] || '';
  if (!token) return res.status(403).json({ message: 'Token requerido.' });

  // Soporta "Bearer <jwt>" o token “pelón”
  if (token.startsWith('Bearer ')) token = token.slice(7);

  jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
    if (err) return res.status(403).json({ message: 'Token inválido.' });
    req.user = decoded; // { id, nombre_usuario, rol, iat, exp }
    next();
  });
};

// === Helpers varios ===
function getYearFromFecha(fechaStr) {
  if (!fechaStr) return null;
  const parts = String(fechaStr).split('-');
  const anio = parts[parts.length - 1];
  return /^\d{4}$/.test(anio) ? anio : null;
}
function uuidName() { return crypto.randomUUID(); }
async function getInstanciaRowById(id_instancia) {
  if (!id_instancia) return null;
  const { rows } = await dbClient.query(
    'SELECT instancia, periodo FROM documentos.instancias WHERE id_instancia = $1 LIMIT 1',
    [id_instancia]
  );
  return rows[0] || null;
}
// === Solr config ===
function resolveSolrBase(instanciaUrl) {
  if (!instanciaUrl) throw new Error('instancia no definida');
  let url;
  try {
    url = new URL(String(instanciaUrl));
  } catch {
    throw new Error(`instancia inválida: ${instanciaUrl}`);
  }

  // Validaciones mínimas para evitar SSRF / destinos raros
  const allowedHosts = new Set(['localhost', '127.0.0.1']);
  if (!allowedHosts.has(url.hostname)) {
    throw new Error(`Host no permitido en instancia: ${url.hostname}`);
  }
  // (Opcional) limita puertos aceptados
  if (url.port && !['8983', '8985'].includes(url.port)) {
    throw new Error(`Puerto no permitido en instancia: ${url.port}`);
  }
  // Debe apuntar a /solr/... o /solr2/...
  if (!/^\/solr2?\//.test(url.pathname)) {
    throw new Error(`Path inválido en instancia: ${url.pathname}`);
  }

  // Normaliza: sin trailing slash
  return url.toString().replace(/\/+$/, '');
}



function buildSolrExtractUrlWithBase(solrBase, paramsObj = {}) {
  const base = solrBase.replace(/\/+$/, '');
  const url = new URL(`${base}/update/extract`);
  const usp = new URLSearchParams(paramsObj);
  url.search = usp.toString();
  return url.toString();
}

async function postSolrExtractFromBufferToBase(solrBase, buffer, paramsObj) {
  if (!buffer || !Buffer.isBuffer(buffer)) throw new Error('Archivo no recibido en memoria');
  const url = buildSolrExtractUrlWithBase(solrBase, paramsObj);
  const resp = await fetch(url, {
    method: 'POST',
    headers: { 'Content-Type': 'application/octet-stream' },
    body: buffer,
  });
  if (!resp.ok) {
    const txt = await resp.text().catch(() => '');
    const err = new Error(`Solr extract failed: ${resp.status} ${resp.statusText} ${txt}`);
    err.status = resp.status;
    throw err;
  }
  return resp.text();
}
// Lista de instancias (para llenar el select con periodos)
app.get('/api/instancias', verifyToken, async (req, res) => {
  try {
    const { rows } = await dbClient.query(
      'SELECT id_instancia, periodo FROM documentos.instancias ORDER BY periodo DESC'
    );
    res.json(rows);
  } catch (e) {
    console.error('[GET /api/instancias] Error:', e);
    res.status(500).json({ message: 'Error listando instancias' });
  }
});
app.get('/api/secciones', verifyToken, async (req, res) => {
  try {
    const { rows } = await dbClient.query(
      'SELECT id, seccion FROM clasificacion.secciones'
    );
    res.json(rows);
  } catch (e) {
    console.error('[GET /api/secciones] Error:', e);
    res.status(500).json({ message: 'Error listando secciones' });
  }
});
app.get('/api/series', verifyToken, async (req, res) => {
  try {
    const seccionId = Number(req.query.seccionId);
    if (!seccionId) {
      return res.status(400).json({ message: 'Falta seccionId (query param)' });
    }

    const { rows } = await dbClient.query(
      `SELECT id, serie
       FROM clasificacion.series
       WHERE seccion_id = $1
       ORDER BY serie ASC`,
      [seccionId]
    );

    res.json(rows);
  } catch (e) {
    console.error('[GET /api/series] Error:', e);
    res.status(500).json({ message: 'Error listando series' });
  }
});
app.get('/api/subseries', verifyToken, async (req, res) => {
  try {
    const serieId = Number(req.query.serieId);
    if (!serieId) {
      return res.status(400).json({ message: 'Falta serieId (query param)' });
    }

    const { rows } = await dbClient.query(
      `SELECT id, subserie
       FROM clasificacion.subseries
       WHERE serie_id = $1
       ORDER BY subserie ASC`,
      [serieId]
    );

    res.json(rows);
  } catch (e) {
    console.error('[GET /api/subseries] Error:', e);
    res.status(500).json({ message: 'Error listando subseries' });
  }
});
app.get('/api/expedientes', verifyToken, async (req, res) => {
  try {
    const year = Number(req.query.year);
    if (!year) return res.status(400).json({ message: 'Falta year (query param)' });

    const { rows } = await dbClient.query(
      `SELECT e.id
       FROM expedientes.poranios e
       JOIN clasificacion.anios a       ON a.id = e.anio_id
       JOIN clasificacion.subseries s   ON s.id = e.subserie_id
       WHERE a.anio = $1
         AND s.subserie = 'Actas'
       LIMIT 1`,
      [year]
    );
    //console.log( 'el id',year);
    // Devuelve un solo id (o null)
    res.json({ id: rows[0]?.id ?? null });
    
  } catch (e) {
    console.error('[GET /api/expedientes] Error:', e);
    res.status(500).json({ message: 'Error expediente id' });
  }
});
app.get('/api/ciclos', verifyToken, async (req, res) => {
  try {
    const { rows } = await dbClient.query(
      `SELECT id, ciclo
       FROM clasificacion.ciclos
       ORDER BY ciclo DESC`
    );
    return res.json(rows);
  } catch (e) {
    console.error('[GET /api/ciclos] Error:', e);
    return res.status(500).json({ message: 'Error listando ciclos' });
  }
});
app.get('/api/expedientesporciclos', verifyToken, async (req, res) => {
  try {
    const cicloId = Number(req.query.cicloId);
    if (!cicloId) return res.status(400).json({ message: 'Falta cicloId (query param)' });

    const { rows } = await dbClient.query(
      `SELECT e.id
       FROM expedientes.porciclos e
       JOIN clasificacion.ciclos c      ON c.id = e.ciclo_id
       JOIN clasificacion.subseries s   ON s.id = e.subserie_id
       WHERE c.id = $1
         AND s.subserie = 'Actas'
       LIMIT 1`,
      [cicloId]
    );

    return res.json({ id: rows[0]?.id ?? null });
  } catch (e) {
    console.error('[GET /api/expedientesporciclos] Error:', e);
    return res.status(500).json({ message: 'Error expediente por ciclo' });
  }
});

app.get('/api/areasprod', verifyToken, async (req, res) => {
  try {
    const { rows } = await dbClient.query(
      'SELECT id, area FROM clasificacion.areas_productoras'
    );
    res.json(rows);
  } catch (e) {
    console.error('[GET /api/areasprod] Error:', e);
    res.status(500).json({ message: 'Error listando areas productoras' });
  }
});

app.get('/api/anios', verifyToken, async (req, res) => {
  try {
    const { rows } = await dbClient.query(
      'SELECT id, anio FROM clasificacion.anios'
    );
    res.json(rows);
  } catch (e) {
    console.error('[GET /api/areasprod] Error:', e);
    res.status(500).json({ message: 'Error listando areas productoras' });
  }
});
app.post('/api/crearexpedienteporanios', verifyToken, async (req, res) => {
  try {
    const {
      seccionId,
      serieId,
      subserieId,
      areaProdId,
      anioId,
      instanciaId
    } = req.body || {};

    // Validación mínima
    const faltan = [];
    if (!seccionId) faltan.push('seccionId');
    if (!serieId) faltan.push('serieId');
    if (!subserieId) faltan.push('subserieId');
    if (!areaProdId) faltan.push('areaProdId');
    if (!anioId) faltan.push('anioId');
    if (!instanciaId) faltan.push('instanciaId');

    if (faltan.length) {
      return res.status(400).json({ message: `Faltan campos: ${faltan.join(', ')}` });
    }

    
    const { rows } = await dbClient.query(
       `INSERT INTO expedientes.poranios (seccion_id, serie_id, subserie_id, arprod_id, anio_id, instancia_id)
        VALUES ($1,$2,$3,$4,$5,$6)
        RETURNING id`,
       [seccionId, serieId, subserieId, areaProdId, anioId, instanciaId]
    );
    
    return res.status(201).json({ message: 'Expediente creado', id: rows[0].id });


  } catch (e) {
    if (e && e.code === '23505') {
      return res.status(409).json({
        message: 'Ya existe un expediente con esas características para ese año.'
      });
    }
    console.error(e);
    res.status(500).json({ message: 'Error creando expediente' });
    console.error('[POST /api/crearexpediente] Error:', e);
    
  }
});

app.post('/api/crearexpedienteporciclos', verifyToken, async (req, res) => {
  try {
    const {
      seccionId,
      serieId,
      subserieId,
      areaProdId,
      cicloId,
      instanciaId
    } = req.body || {};

    const faltan = [];
    if (!seccionId) faltan.push('seccionId');
    if (!serieId) faltan.push('serieId');
    if (!subserieId) faltan.push('subserieId');
    if (!areaProdId) faltan.push('areaProdId');
    if (!cicloId) faltan.push('cicloId');
    if (!instanciaId) faltan.push('instanciaId');

    if (faltan.length) {
      return res.status(400).json({ message: `Faltan campos: ${faltan.join(', ')}` });
    }

    const { rows } = await dbClient.query(
      `INSERT INTO expedientes.porciclos (seccion_id, serie_id, subserie_id, arprod_id, ciclo_id, instancia_id)
       VALUES ($1,$2,$3,$4,$5,$6)
       RETURNING id`,
      [seccionId, serieId, subserieId, areaProdId, cicloId, instanciaId]
    );

    return res.status(201).json({ message: 'Expediente creado', id: rows[0].id });

  } catch (e) {
    if (e && e.code === '23505') {
      return res.status(409).json({
        message: 'Ya existe un expediente con esas características para ese ciclo.'
      });
    }
    console.error('[POST /api/crearexpedienteporciclos] Error:', e);
    res.status(500).json({ message: 'Error creando expediente por ciclos' });
  }
});

const ALLOWED_FIELDS = new Set(['contenido', 'acta', 'fecha', 'tipo', 'permanente', 'id']);
function parseQueryInput(raw = '') {
  const str = String(raw || '').trim();
  if (!str) return { field: 'contenido', term: '*' };
  const idx = str.indexOf(':');
  if (idx > 0) {
    const f = str.slice(0, idx).trim();
    const t = str.slice(idx + 1).trim();
    if (ALLOWED_FIELDS.has(f) && t.length > 0) {
      return { field: f, term: t };
    }
  }
  return { field: 'contenido', term: str };
}
function tokensForHighlight(term = '') {
  const parts = String(term)
    .split(/[^0-9A-Za-zÁÉÍÓÚáéíóúÑñ]+/u)
    .map(s => s.trim())
    .filter(Boolean);
  return [...new Set(parts)];
}
async function callSolrSearch({ field, term, start = 0, rows = 10 }) {
  const qStr = `${field}:${term}`;
  const tokens = tokensForHighlight(term);
  const hlq = tokens.length ? `contenido:(${tokens.map(t => `"${t.replace(/"/g, '\\"')}"`).join(' ')})` : undefined;

  const params = new URLSearchParams({
    q: qStr,
    wt: 'json',
    indent: 'true',
    hl: 'true',
    'hl.fl': 'contenido',
    'hl.fragsize': '50',
    'hl.snippets': '3',
    'hl.simple.pre': '<span class="highlight">',
    'hl.simple.post': '</span>',
    'hl.requireFieldMatch': 'false',
    start: String(start),
    rows: String(rows),
  });
  if (hlq) params.set('hl.q', hlq);

  const solrUrl = `${SOLR_CORE_URL}?${params.toString()}`;
  const resp = await fetch(solrUrl, {
    headers: { 'Accept': 'application/json', 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
  });
  if (!resp.ok) {
    const txt = await resp.text().catch(() => '');
    const err = new Error(`Solr error: ${resp.status} ${resp.statusText} ${txt}`);
    err.status = resp.status;
    throw err;
  }
  return resp.json();
}
const uploadOCR = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 50 * 1024 * 1024 }
});

app.post('/api/ocrDocumento', verifyToken, uploadOCR.single('file'), async (req, res) => {
  try {
    if (!req.file) {
      throw new Error('Archivo no recibido');
    }

    const originalName = req.file.originalname || 'documento.pdf';
    const ext = (path.extname(originalName) || '').toLowerCase();

    if (ext !== '.pdf') {
      return res.status(400).json({ message: 'El archivo debe ser PDF' });
    }

    const form = new FormData();
    form.append('file', req.file.buffer, {
      filename: originalName,
      contentType: req.file.mimetype || 'application/pdf'
    });

    const response = await axios.post(OCR_SERVICE_URL, form, {
      headers: {
        ...form.getHeaders(),
        Authorization: req.headers.authorization || ''
      },
      responseType: 'stream',
      maxBodyLength: Infinity,
      maxContentLength: Infinity,
      validateStatus: () => true
    });

    if (response.status !== 200) {
      let errorText = '';
      try {
        for await (const chunk of response.data) {
          errorText += chunk.toString('utf8');
        }
      } catch (_) {}

      console.error('[OCR DOCUMENTO] Error servicio OCR:', errorText);
      return res.status(500).json({
        message: 'Error al procesar OCR',
        error: errorText || 'Servicio OCR devolvió un error'
      });
    }

    const ocrStatus = response.headers['x-ocr-status'] || 'unknown';

    let outputName = originalName;
    if (ocrStatus === 'ocr_generated') {
      outputName = `${path.parse(originalName).name}_ocr.pdf`;
    }

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `inline; filename="${outputName}"`);
    res.setHeader('X-OCR-Status', ocrStatus);

    response.data.pipe(res);

  } catch (e) {
    console.error('[OCR DOCUMENTO] Error:', e);
    res.status(500).json({
      message: 'Error al procesar documento OCR',
      error: String(e?.message || e)
    });
  }
});
// === Multer storages ===
// Principal: BASE_DIR/<año>/<uuid_carpeta>/<uuid_archivo>.<ext>
const storagePrincipal = multer.diskStorage({
  destination: (req, file, cb) => {
    try {
      const { fecha } = req.body;
      const año = getYearFromFecha(fecha);
      if (!año) return cb(new Error('Fecha inválida (no se pudo extraer el año)'));
      const yearDir = path.join(BASE_DIR, año);
      if (!fs.existsSync(yearDir)) fs.mkdirSync(yearDir, { recursive: true });

      const folderUuid = uuidName();
      const targetDir = path.join(yearDir, folderUuid);
      if (!fs.existsSync(targetDir)) fs.mkdirSync(targetDir, { recursive: true });
      cb(null, targetDir);
    } catch (e) { cb(e); }
  },
  filename: (req, file, cb) => {
    const ext = (path.extname(file.originalname) || '').toLowerCase();
    const generated = uuidName() + ext;
    cb(null, generated);
  },
});
const uploadPrincipal = multer({ storage: storagePrincipal });

// Anexo: <dir_principal>/anexos/<uuid_archivo>.<ext>
const storageAnexo = multer.diskStorage({
  destination: async (req, file, cb) => {
    try {
      const { ui_principal } = req.body;
      if (!ui_principal) return cb(new Error('ui_principal es requerido'));
      const q = 'SELECT ruta_documento FROM documentos.actas WHERE ui = $1';
      const { rows } = await dbClient.query(q, [ui_principal]);
      if (!rows.length) return cb(new Error('Documento principal no encontrado'));
      const principalDir = rows[0].ruta_documento;
      const anexosDir = path.join(principalDir, 'anexos');
      if (!fs.existsSync(anexosDir)) fs.mkdirSync(anexosDir, { recursive: true });
      cb(null, anexosDir);
    } catch (e) { cb(e); }
  },
  filename: (req, file, cb) => {
    const ext = (path.extname(file.originalname) || '').toLowerCase();
    const generated = uuidName() + ext;
    cb(null, generated);
  }
});
const uploadAnexo = multer({ storage: storageAnexo, limits: { fileSize: 50 * 1024 * 1024 } });

const uploadInMemory = multer({ storage: multer.memoryStorage() });

// === Endpoints ===

// Registro usuario (hash + activo=1)
app.post('/api/register', async (req, res) => {
  try {
    const { nombre, nombre_usuario, password, rol } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const dbQuery = `
      INSERT INTO auth.usuarios (nombre, nombre_usuario, password, rol, activo)
      VALUES ($1, $2, $3, $4, 1) RETURNING id
    `;
    const values = [nombre, nombre_usuario, hashedPassword, rol];
    const result = await dbClient.query(dbQuery, values);
    res.status(201).json({ message: 'Usuario registrado.', userId: result.rows[0].id });
  } catch (error) {
    console.error('Error al registrar usuario:', error);
    res.status(500).json({ message: 'Error al registrar usuario.', error: String(error?.message || error) });
  }
});

// Logout (si no usas sesiones, responde OK)
app.post('/api/logout', (req, res) => {
  req.session?.destroy?.(err => {
    if (err) return res.status(500).json({ message: 'Error al cerrar sesión' });
    return res.status(200).json({ message: 'Sesión cerrada exitosamente' });
  }) || res.status(200).json({ message: 'Sesión cerrada exitosamente' });
});

// Login (bcrypt + activo + JWT Bearer)
app.post('/api/login', async (req, res) => {
  try {
    const { nombre_usuario, password } = req.body || {};

    if (!nombre_usuario || !password) {
      return res.status(400).json({ message: 'Faltan nombre_usuario o password.' });
    }

    const dbQuery = `
      SELECT
        id,
        nombre_usuario,
        rol,
        activo,
        (password = crypt($2, password)) AS password_ok
      FROM auth.usuarios
      WHERE nombre_usuario = $1
      LIMIT 1
    `;

    const result = await dbClient.query(dbQuery, [nombre_usuario, password]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Usuario no encontrado.' });
    }

    const user = result.rows[0];

    if (!user.password_ok) {
      return res.status(403).json({ message: 'Contraseña incorrecta.' });
    }

    if (Number(user.activo) !== 1) {
      return res.status(403).json({ message: 'Usuario inactivo. Contacte al administrador.' });
    }

    const token = signToken({
      id: user.id,
      nombre_usuario: user.nombre_usuario,
      rol: user.rol
    });

    return res.status(200).json({ message: 'Login exitoso.', token });
  } catch (error) {
    console.error('Error en login:', error);
    return res.status(500).json({ message: 'Error en login.', error: String(error?.message || error) });
  }
});


app.post('/api/indexarActa', verifyToken, uploadPrincipal.single('file'), async (req, res) => {
  const client = await dbClient.connect();
  let filePath = null;

  try {
    const {
      acta,
      fecha,
      tipo,
      permanente,
      instancia_id,
      idexpediente,
      origen_expediente, // <- NUEVO (ANIO | CICLO) (tu front manda origenExpediente)
    } = req.body;

    const id_usuario = req.user.id;

    // ===== Validaciones =====
    if (!req.file) throw new Error('Archivo no recibido');

    const faltan = [];
    if (!acta) faltan.push('acta');
    if (!fecha) faltan.push('fecha');
    if (!tipo) faltan.push('tipo');
    if (permanente == null) faltan.push('permanente');
    if (!instancia_id) faltan.push('instancia_id');
    if (!idexpediente) faltan.push('idexpediente');
    if (!origen_expediente) faltan.push('origen_expediente');

    if (faltan.length) {
      return res.status(400).json({ message: `Faltan campos requeridos: ${faltan.join(', ')}` });
    }

    const origen = String(origen_expediente).toUpperCase();
    if (origen !== 'ANIO' && origen !== 'CICLO') {
      return res.status(400).json({ message: `origen_expediente inválido. Usa ANIO o CICLO.` });
    }

    // ===== multer ya guardó archivo =====
    const storedName = req.file.filename;
    const dirPath = req.file.destination;
    filePath = req.file.path;

    if (!storedName || !dirPath || !filePath) {
      return res.status(400).json({ message: 'Ruta de archivo inválida' });
    }

    // ===== Resolver Solr =====
    const row = await getInstanciaRowById(Number(instancia_id));
    if (!row) return res.status(400).json({ message: 'instancia_id inválida' });
    const solrBase = resolveSolrBase(row.instancia);

    const ui = crypto.randomUUID();

    await client.query('BEGIN');

    // ===== INSERT BD (dinámico según origen) =====
    const expedienteCol = (origen === 'ANIO') ? 'expediente_anios_id' : 'expediente_ciclos_id';

    await client.query(
      `INSERT INTO documentos.actas (ui, nombre_documento, ruta_documento, id_usuario, ${expedienteCol})
       VALUES ($1, $2, $3, $4, $5)`,
      [ui, storedName, dirPath, id_usuario, idexpediente]
    );

    await client.query(
      `INSERT INTO documentos.descripcion_actas (acta, fecha, tipo, permanente, ui_documento)
       VALUES ($1, $2, $3, $4, $5)`,
      [acta, fecha, tipo, permanente, ui]
    );

    // ===== Solr =====
    const buffer = await fsp.readFile(filePath);

    const solrParams = {
      'literal.id': ui,
      'literal.acta': acta,
      'literal.fecha': fecha,
      'literal.tipo': tipo,
      'literal.permanente': permanente,
      'commit': 'true',
    };

    await postSolrExtractFromBufferToBase(solrBase, buffer, solrParams);

    await client.query('COMMIT');

    return res.status(200).json({
      message: 'BD + Disco + Solr OK',
      ui,
      origen_expediente: origen,
      expediente_col: expedienteCol,
      idexpediente
    });

  } catch (err) {
    try { await client.query('ROLLBACK'); } catch {}

    // BORRAR archivo si algo falló
    if (filePath) {
      try { await fsp.unlink(filePath); } catch {}
    }

    console.error('[indexarActa] Error:', err);
    return res.status(500).json({
      message: 'Error indexando acta. Todo revertido.',
      error: String(err?.message || err)
    });

  } finally {
    client.release();
  }
});


app.post('/api/usuario_name', verifyToken, async (req,res) => {

  try{
     const id_usuario = req.user.nombre_usuario;
     if (!id_usuario) throw new Error('error username no encontrado');
     return res.status(200).json({ message: 'username', id_usuario });
  }catch(err){
    return res.status(500).json({ message: 'Error no encontro username', error: String(err?.message || err) });
  }

});
app.post('/api/usuario_rol', verifyToken, async (req, res) => {
  try {
    const  rol  = req.user.rol; // ya viene en el token
    if (!rol) throw new Error('Rol no encontrado');
    return res.status(200).json({ rol });
  } catch (err) {
    return res.status(500).json({ message: 'Error al obtener el rol', error: String(err?.message || err) });
  }
});

// Listado documentos — protegido
app.get('/api/documentosListado', verifyToken, async (req, res) => {
  try {
    const { tipo, permanente, mes, anio } = req.query;

    
    const faltan = [];
    if (!mes) faltan.push('mes');
    if (!anio) faltan.push('anio');
    if (faltan.length) {
      return res.status(400).json({ message: `Faltan filtros obligatorios: ${faltan.join(', ')}` });
    }

    // Base SQL
    let sql = `
      SELECT a.ui, a.nombre_documento, a.ruta_documento,
             da.acta, da.fecha, da.tipo, da.permanente
      FROM documentos.actas a
      LEFT JOIN documentos.descripcion_actas da ON da.ui_documento = a.ui
    `;

    const conditions = [];
    const values = [];

    //Mes y Año (fecha varchar "12-Febrero-2014")
    values.push(String(mes).trim());
    conditions.push(`trim(split_part(da.fecha, '-', 2)) = $${values.length}`);

    values.push(String(anio).trim());
    conditions.push(`trim(split_part(da.fecha, '-', 3)) = $${values.length}`);

    // Opcionales
    if (tipo) {
      values.push(tipo);
      conditions.push(`da.tipo = $${values.length}`);
    }

    if (permanente) {
      values.push(permanente); // 'Si' o 'No'
      conditions.push(`da.permanente = $${values.length}`);
    }

    sql += ` WHERE da.fecha IS NOT NULL AND ${conditions.join(' AND ')}`;
    sql += ` ORDER BY da.fecha DESC NULLS LAST`;

    const result = await dbClient.query(sql, values);
    return res.json(result.rows);

  } catch (e) {
    console.error('[LISTADO] Error:', e);
    return res.status(500).json({ message: 'Error listando documentos' });
  }
});



// Registrar anexo — protegido
app.post('/api/registerAnexo', verifyToken, uploadAnexo.single('file'), async (req, res) => {
  const client = await dbClient.connect();
  try {
    await client.query('BEGIN');

    const { ui_principal, fecha, descripcion} = req.body;
    const id_usuario = req.user.id;
    const storedName = req.file?.filename;
    const dirPath    = req.file?.destination || (req.file?.path ? path.dirname(req.file.path) : null);

    if (!ui_principal) throw new Error('ui_principal es requerido');
    if (!storedName || !dirPath) throw new Error('Archivo no recibido');

    const uiAnexo = crypto.randomUUID();

    const q1 = `
      INSERT INTO documentos.documentos_anexos
             (ui, nombre_documento, ruta_documento, id_usuario, ui_principal, descripcion, fecha_del_documento)
      VALUES ($1, $2, $3, $4, $5, $6, $7)
    `;
    await client.query(q1, [uiAnexo, storedName, dirPath, id_usuario, ui_principal, descripcion, fecha]);

    await client.query('COMMIT');
    res.status(200).json({ message: 'Anexo registrado exitosamente.', ui_anexo: uiAnexo });
  } catch (e) {
    await client.query('ROLLBACK');
    console.error('[REGISTER ANEXO] Error:', e);
    res.status(500).json({ message: 'Error al registrar anexo', error: String(e?.message || e) });
  } finally {
    client.release();
  }
});
/*app.post('/api/rendimiento', verifyToken, async (req, res) => {
  const client = await dbClient.connect();

  try {
    await client.query('BEGIN');

    const id_usuario = req.user?.id || null;

    const {
      accion,
      endpoint,
      duracion_ms,
      exito,
      status_http,
      instante_cliente_iso,
      timestamp_cliente_ms,
      instancia_id,
      ui_principal,
      query_texto,
      total_resultados,
      total_anexos,
      detalle_error,
      ui_anexo,
      tamanio_archivo_bytes,
      doc_id
    } = req.body;

    if (!accion) {
      throw new Error('accion es requerida');
    }

    if (!endpoint) {
      throw new Error('endpoint es requerido');
    }

    const accionesBusqueda = new Set([
      'BUSCAR',
      'CARGAR_ANEXOS',
      'LISTAR_DOCUMENTOS_PARA_ANEXO'
    ]);

    const accionesIndexacion = new Set([
      'INDEXAR',
      'INDEXAR_ANEXO',
      'REGISTRAR_ANEXO_POST_INDEXACION'
    ]);

    const accionesVisualizacion = new Set([
      'MOSTRAR_PDF_PRINCIPAL',
      'MOSTRAR_PDF_ANEXO'
    ]);

    if (accionesBusqueda.has(accion)) {
      const q = `
        INSERT INTO estadisticas.rendimiento_busqueda
        (
          accion,
          endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          instancia_id,
          ui_principal,
          query_texto,
          total_resultados,
          total_anexos,
          detalle_error
        )
        VALUES
        (
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14
        )
      `;

      await client.query(q, [
        accion,
        endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        instancia_id ?? null,
        ui_principal ?? null,
        query_texto ?? null,
        total_resultados ?? null,
        total_anexos ?? null,
        detalle_error ?? null
      ]);
    } else if (accionesIndexacion.has(accion)) {
      const q = `
        INSERT INTO estadisticas.rendimiento_indexacion_y_registro
        (
          accion,
          endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          instancia_id,
          ui_principal,
          ui_anexo,
          tamanio_archivo_bytes,
          detalle_error
        )
        VALUES
        (
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13
        )
      `;

      await client.query(q, [
        accion,
        endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        instancia_id ?? null,
        ui_principal ?? null,
        ui_anexo ?? null,
        tamanio_archivo_bytes ?? null,
        detalle_error ?? null
      ]);
    } else if (accionesVisualizacion.has(accion)) {
      const q = `
        INSERT INTO estadisticas.rendimiento_visualizacion_pdf
        (
          accion,
          endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          doc_id,
          ui_anexo,
          detalle_error
        )
        VALUES
        (
          $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11
        )
      `;

      await client.query(q, [
        accion,
        endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        doc_id ?? null,
        ui_anexo ?? null,
        detalle_error ?? null
      ]);
    } else {
      throw new Error(`Acción no reconocida: ${accion}`);
    }

    await client.query('COMMIT');
    res.status(200).json({ message: 'Rendimiento registrado correctamente.' });
  } catch (e) {
    await client.query('ROLLBACK');
    console.error('[RENDIMIENTO] Error:', e);
    res.status(500).json({
      message: 'Error al registrar rendimiento',
      error: String(e?.message || e)
    });
  } finally {
    client.release();
  }
});*/
app.post('/api/rendimiento', verifyToken, async (req, res) => {
  const client = await dbClient.connect();

  try {
    await client.query('BEGIN');

    const id_usuario = req.user?.id || null;
    const body = req.body || {};

    const {
      accion,
      endpoint,
      duracion_ms,
      exito,
      status_http,
      instante_cliente_iso,
      timestamp_cliente_ms,
      instancia_id,
      ui_principal,
      query_texto,
      total_resultados,
      total_anexos,
      detalle_error,
      ui_anexo,
      tamanio_archivo_bytes,
      tamanio_salida_bytes,
      doc_id
    } = body;

    if (!accion) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: 'accion es requerida' });
    }

    if (!endpoint) {
      await client.query('ROLLBACK');
      return res.status(400).json({ message: 'endpoint es requerido' });
    }

    const accionResult = await client.query(
      `
        SELECT id_accion, tabla_destino
        FROM estadisticas.catalogo_acciones
        WHERE accion = $1
        LIMIT 1
      `,
      [accion]
    );

    if (accionResult.rowCount === 0) {
      await client.query('ROLLBACK');
      return res.status(400).json({
        message: `Acción no registrada en catálogo: ${accion}`
      });
    }

    const endpointResult = await client.query(
      `
        SELECT id_endpoint
        FROM estadisticas.catalogo_endpoints
        WHERE endpoint = $1
        LIMIT 1
      `,
      [endpoint]
    );

    if (endpointResult.rowCount === 0) {
      await client.query('ROLLBACK');
      return res.status(400).json({
        message: `Endpoint no registrado en catálogo: ${endpoint}`
      });
    }

    const { id_accion, tabla_destino } = accionResult.rows[0];
    const { id_endpoint } = endpointResult.rows[0];

    if (tabla_destino === 'BUSQUEDA') {
      const q = `
        INSERT INTO estadisticas.rendimiento_busqueda
        (
          id_accion,
          id_endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          instancia_id,
          ui_principal,
          query_texto,
          total_resultados,
          total_anexos,
          detalle_error
        )
        VALUES
        ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
      `;

      await client.query(q, [
        id_accion,
        id_endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        instancia_id ?? null,
        ui_principal ?? null,
        query_texto ?? null,
        total_resultados ?? null,
        total_anexos ?? null,
        detalle_error ?? null
      ]);
    } else if (tabla_destino === 'INDEXACION_Y_REGISTRO') {
      const q = `
        INSERT INTO estadisticas.rendimiento_indexacion_y_registro
        (
          id_accion,
          id_endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          instancia_id,
          ui_principal,
          ui_anexo,
          tamanio_archivo_bytes,
          detalle_error
        )
        VALUES
        ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)
      `;

      await client.query(q, [
        id_accion,
        id_endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        instancia_id ?? null,
        ui_principal ?? null,
        ui_anexo ?? null,
        tamanio_archivo_bytes ?? null,
        detalle_error ?? null
      ]);
    } else if (tabla_destino === 'INDEXACION_Y_REGISTRO_OCR') {
      const q = `
        INSERT INTO estadisticas.rendimiento_indexacion_y_registro
        (
          id_accion,
          id_endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          instancia_id,
          ui_principal,
          ui_anexo,
          tamanio_archivo_bytes,
          tamanio_salida_bytes,
          detalle_error
        )
        VALUES
        ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13,$14)
      `;

      await client.query(q, [
        id_accion,
        id_endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        instancia_id ?? null,
        ui_principal ?? null,
        ui_anexo ?? null,
        tamanio_archivo_bytes ?? null,
        tamanio_salida_bytes ?? null,
        detalle_error ?? null
      ]);
    } else if (tabla_destino === 'VISUALIZACION_PDF') {
      const q = `
        INSERT INTO estadisticas.rendimiento_visualizacion_pdf
        (
          id_accion,
          id_endpoint,
          duracion_ms,
          exito,
          status_http,
          instante_cliente_iso,
          timestamp_cliente_ms,
          usuario_id,
          doc_id,
          ui_anexo,
          detalle_error
        )
        VALUES
        ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
      `;

      await client.query(q, [
        id_accion,
        id_endpoint,
        duracion_ms ?? null,
        exito ?? null,
        status_http ?? null,
        instante_cliente_iso ?? null,
        timestamp_cliente_ms ?? null,
        id_usuario,
        doc_id ?? null,
        ui_anexo ?? null,
        detalle_error ?? null
      ]);
    } else {
      await client.query('ROLLBACK');
      return res.status(400).json({
        message: `tabla_destino no válida para la acción ${accion}: ${tabla_destino}`
      });
    }

    await client.query('COMMIT');
    res.status(200).json({ message: 'Rendimiento registrado correctamente.' });
  } catch (e) {
    await client.query('ROLLBACK');
    console.error('[RENDIMIENTO] req.body:', req.body);
    console.error('[RENDIMIENTO] Error:', e);

    res.status(500).json({
      message: 'Error al registrar rendimiento',
      error: e?.message || String(e),
      detail: e?.detail || null,
      code: e?.code || null
    });
  } finally {
    client.release();
  }
});
// Lista anexos — protegido
app.get('/api/anexosByPrincipal', verifyToken, async (req, res) => {
  try {
    const ui_principal = req.query.ui_principal;
    if (!ui_principal) {
      return res.status(400).json({ message: 'ui_principal es requerido' });
    }
    const q = `
      SELECT ui, ui_principal, nombre_documento, descripcion, fecha_del_documento
      FROM documentos.documentos_anexos
      WHERE ui_principal = $1
      ORDER BY fecha_del_documento DESC NULLS LAST, ui ASC
    `;
    const { rows } = await dbClient.query(q, [ui_principal]);
    return res.json({ anexos: rows });
  } catch (e) {
    console.error('[anexosByPrincipal] Error:', e);
    return res.status(500).json({ message: 'Error listando anexos' });
  }
});

app.get('/api/anexoPdf', verifyToken, async (req, res) => {
  try {
    const ui = String(req.query.ui || '');
    if (!ui) return res.status(400).json({ message: 'ui es requerido' });

    const q = `
      SELECT ruta_documento, nombre_documento
      FROM documentos.documentos_anexos
      WHERE ui = $1
      LIMIT 1
    `;
    const r = await dbClient.query(q, [ui]);
    if (!r.rows.length) return res.status(404).json({ message: 'Anexo no encontrado' });

    const dirPath = r.rows[0].ruta_documento;
    const fileName = r.rows[0].nombre_documento;

    const absPath = path.resolve(path.join(dirPath, fileName));
    const base = path.resolve(BASE_DIR);

    // Seguridad: el archivo debe estar dentro de BASE_DIR
    if (!absPath.startsWith(base + path.sep)) {
      return res.status(403).json({ message: 'Ruta no permitida' });
    }

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'inline');
    res.setHeader('Cache-Control', 'no-store');

    return fs.createReadStream(absPath).pipe(res);
  } catch (e) {
    console.error('[GET /api/anexoPdf] Error:', e);
    return res.status(500).json({ message: 'Error interno' });
  }
});


app.get('/api/solrSearch', verifyToken, async (req, res) => {
  try {
    res.setHeader('Cache-Control', 'no-store');

    const { query = '', start = '0', rows = '10', instanciaId } = req.query;
    if (!instanciaId) {
      return res.status(400).json({ message: 'instanciaId es requerido' });
    }

    // 1) Buscar la URL base de esa instancia
    const q = 'SELECT instancia FROM documentos.instancias WHERE id_instancia = $1 LIMIT 1';
    const r = await dbClient.query(q, [Number(instanciaId)]);
    const base = r.rows?.[0]?.instancia; // p.ej. "http://localhost:8985/solr/cuarta_decada"
    if (!base) {
      return res.status(400).json({ message: 'Instancia no encontrada o sin URL' });
    }

    // 2) Parsear la consulta como ya lo hacías
    const { field, term } = parseQueryInput(query);
    const startNum = Math.max(0, parseInt(start, 10) || 0);
    const rowsNum  = Math.min(100, Math.max(1, parseInt(rows, 10) || 10));

    // 3) Construir la URL de select para esa instancia
    const tokens = tokensForHighlight(term);
    const hlq = tokens.length
      ? `contenido:(${tokens.map(t => `"${t.replace(/"/g, '\\"')}"`).join(' ')})`
      : undefined;

    const params = new URLSearchParams({
      q: `${field}:${term}`,
      wt: 'json',
      indent: 'true',
      hl: 'true',
      'hl.fl': 'contenido',
      'hl.fragsize': '50',
      'hl.snippets': '3',
      'hl.simple.pre': '<span class="highlight">',
      'hl.simple.post': '</span>',
      'hl.requireFieldMatch': 'false',
      start: String(startNum),
      rows: String(rowsNum),
    });
    if (hlq) params.set('hl.q', hlq);

    const solrUrl = `${base}/select?${params.toString()}`;

    // 4) Llamar a Solr
    const resp = await fetch(solrUrl, {
      headers: { 'Accept': 'application/json', 'Cache-Control': 'no-cache', 'Pragma': 'no-cache' }
    });
    if (!resp.ok) {
      const txt = await resp.text().catch(() => '');
      const status = resp.status || 500;
      return res.status(status).json({ message: `Solr error ${status}`, detail: txt });
    }
    const data = await resp.json();
    return res.json({ ...data, echo: { field, term, instanciaId } });
  } catch (e) {
    console.error('[api/solrSearch] Error:', e);
    const status = e.status && Number.isInteger(e.status) ? e.status : 500;
    return res.status(status).json({ message: 'Error consultando Solr', error: String(e?.message || e) });
  }
});



app.get('/api/pdf', verifyToken, async (req, res) => {
  try {
    const docId = String(req.query.docId || '');
    if (!docId) return res.status(400).json({ message: 'docId es obligatorio' });

    const q = 'SELECT ruta_documento, nombre_documento FROM documentos.actas WHERE ui = $1';
    const r = await dbClient.query(q, [docId]);
    if (!r.rows.length) return res.status(404).json({ message: 'Documento no encontrado' });

    const absPath = path.resolve(path.join(r.rows[0].ruta_documento, r.rows[0].nombre_documento));
    const base = path.resolve(BASE_DIR);

    // Anti path traversal: debe vivir dentro de BASE_DIR
    if (!absPath.startsWith(base + path.sep)) {
      return res.status(403).json({ message: 'Ruta no permitida' });
    }

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'inline');
    res.setHeader('Cache-Control', 'no-store');

    return fs.createReadStream(absPath).pipe(res);
  } catch (e) {
    console.error('[GET /api/pdf] Error:', e);
    return res.status(500).json({ message: 'Error interno' });
  }
});


// Start
const PORT = Number(process.env.PORT || 3000);
app.listen(PORT, '127.0.0.1', () => {
  console.log(`Servidor escuchando2 en http://127.0.0.1:${PORT}`);
});

