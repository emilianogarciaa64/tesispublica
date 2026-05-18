export const ayudas = {
  busquedaActas: {
    titulo: 'Ayuda para la búsqueda',
    tooltip: 'Cómo buscar',
    texto: 'Selecciona primero un periodo. Puedes buscar por texto libre, por campo o usando operadores lógicos.',
    items: [
      'Texto libre: reforma educativa',
      'Búsqueda por campo: campo:valor',
      'Campos permitidos en minúsculas: contenido, fecha, tipo, permanente, id',
      'Ejemplos: fecha:27-Mayo-2014, tipo:ordinaria, permanente:si, id:123',
      'Operadores recomendados en mayúsculas: AND, OR, NOT',
      'Ejemplos: presupuesto AND egresos, consejo OR comité, acta NOT extraordinaria',
      'Para exclusiones, suele funcionar mejor escribir primero un término positivo: palabra1 NOT palabra2',
      'También puedes usar + y - , por ejemplo: +presupuesto -anexo',
      'Si dejas la búsqueda vacía, se mostrarán todos los documentos del periodo seleccionado.'
    ],
    linkUrl: 'https://solr.apache.org/guide/solr/latest/query-guide/edismax-query-parser.html',
    linkLabel: 'Ver documentación de eDisMax en Solr'
  },
   registrarActa: {
    titulo: 'Ayuda para registrar acta',
    tooltip: 'Cómo registrar un acta',
    texto: 'Completa los campos del formulario y carga el archivo PDF principal del acta.',
    items: [
      'Captura el identificador del acta. Ejemplo: 20/2014-2014.',
      'Selecciona la fecha del acta.',
      'En “¿Acta por…?” elige Año o Ciclo.',
      'Si eliges Año, el sistema tomará el año de la fecha para buscar expediente e instancia.',
      'Si eliges Ciclo, debes seleccionar un ciclo para que el sistema determine expediente e instancia.',
      'Selecciona el tipo de acta: Ordinaria o Extraordinaria.',
      'Indica si el acta es permanente.',
      'Carga el archivo principal en formato PDF.',
      'El período o instancia se selecciona automáticamente.',
      'Si marcas “Agregar anexos después de registrar acta”, al finalizar se abrirá la ventana para registrar anexos.',
      'Haz clic en Registrar para guardar el acta.'
    ],
    linkUrl: '',
    linkLabel: ''
  },

  registrarAnexo: {
    titulo: 'Ayuda para registrar anexos',
    tooltip: 'Cómo registrar anexos',
    texto: 'Después de registrar un acta, puedes asociarle uno o más anexos en formato PDF.',
    items: [
      'Selecciona la fecha del anexo.',
      'Escribe una descripción breve del anexo.',
      'Carga el archivo anexo en formato PDF.',
      'Haz clic en “Registrar Anexo”.',
      'Puedes repetir el proceso para asociar varios anexos a la misma acta.',
      'Cuando termines, haz clic en “✔ Terminar”.'
    ],
    linkUrl: '',
    linkLabel: ''
  },
  listadoActasParaAnexo: {
    titulo: 'Ayuda para seleccionar acta',
    tooltip: 'Cómo usar este listado',
    texto: 'Esta pantalla sirve para localizar un acta registrada y continuar con el registro de sus anexos.',
    items: [
      'Primero selecciona un Mes y un Año. Ambos campos son obligatorios para mostrar resultados.',
      'Mientras no selecciones Mes y Año, la tabla no mostrará actas.',
      'Puedes usar también los filtros opcionales de Tipo y Permanente para reducir los resultados.',
      'En Tipo puedes elegir Ordinaria o Extraordinaria.',
      'En Permanente puedes filtrar entre Permanente y No Permanente.',
      'Si cambias el Mes, deberás volver a seleccionar el Año.',
      'El botón Limpiar borra todos los filtros y vacía la tabla.',
      'Cuando aparezca la lista, revisa la fila del acta que te interesa.',
      'Haz clic en “Registrar anexo” para ir a la pantalla donde registrarás el anexo de esa acta.',
      'Esta pantalla no registra anexos directamente; solo te ayuda a encontrar el acta correcta.'
    ],
    linkUrl: '',
    linkLabel: ''
  },
  registrarAnexoDesdeListado: {
    titulo: 'Ayuda para registrar anexo',
    tooltip: 'Cómo registrar este anexo',
    texto: 'Esta pantalla permite registrar un anexo para el acta que seleccionaste previamente en el listado.',
    items: [
      'La acta principal ya fue seleccionada antes de entrar a esta pantalla.',
      'Selecciona la fecha del anexo en el calendario.',
      'Escribe una descripción breve para identificar el contenido del anexo.',
      'Carga el archivo del anexo en formato PDF.',
      'Haz clic en “Registrar” para guardar el anexo.',
      'Si el registro es exitoso, aparecerá un mensaje de confirmación y podrás cargar otro anexo para la misma acta.',
      'La fecha, la descripción y el archivo PDF son obligatorios para registrar el anexo.',
      'Si deseas volver a la lista de actas, usa el botón “Regresar al listado”.',
      'Esta pantalla registra anexos de una acta ya localizada; no sirve para buscar actas nuevas.'
    ],
    linkUrl: '',
    linkLabel: ''
  }, 
  crearExpediente: {
    titulo: 'Ayuda para crear expediente',
    tooltip: 'Cómo crear un expediente',
    texto: 'Esta pantalla permite crear un expediente por Año o por Ciclo, seleccionando la estructura archivística',
    items: [
      'Primero elige el modo de captura: “Por Años” o “Por Ciclos”.',
      'Selecciona la Sección. Después de elegirla, se cargarán las Series disponibles.',
      'Selecciona la Serie. Después de elegirla, se cargarán las Subseries disponibles.',
      'Selecciona la Subserie correspondiente.',
      'Selecciona el Área productora.',
      'Si estás en modo “Por Años”, elige un Año.',
      'Si estás en modo “Por Ciclos”, elige un Ciclo.',
      'La Instancia se selecciona automáticamente a partir del año elegido o del primer año del ciclo.',
      'El botón “Crear” solo se habilita cuando todos los campos obligatorios estén completos.',
      'Si no sabes qué Sección, Serie o Subserie corresponde, consulta el Catálogo de Disposición Documental de la UNIVERSIDAD MICHOACANA DE SAN NICOLÁS DE HIDALGO.'
    ],
    linkUrl: 'https://drive.google.com/file/d/1Y5O8vHHu_4S0p4IAwuRh5-tFpRiT_3A8/view',
    linkLabel: 'Ver Catálogo de Disposición Documental'
  }
}