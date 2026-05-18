module.exports = {
  apps: [{
    name: "archivo_fie_server",
    script: "servlet.js",
    cwd: "/home/benja/prueba/archivo_fie_server",
    instances: 1,
    autorestart: true,
    watch: false,
    max_memory_restart: "1200M",
    env: {
      NODE_ENV: "production"
    }
  }]
}