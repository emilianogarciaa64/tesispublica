<template>
  <div>
          <header class="py-2 mb-2 border-bottom">
            <div class="container2">
              <div class="flex-container2">
                  <a href="https://virtualbox" class="flex-container text-dark text-decoration-none item">
                      <img src="@/assets/img/escudo.png" class="img-fluid" width="72"/>
                      <span class="fs-5">
                      <h4>Facultad de Ingeniería Eléctrica</h4>
                      <!-- <h5 class="text-secondary">Dirección </h5> -->
                      <h6 class="text-secondary">Gestion Documental</h6>
                      </span>
                  </a>
              </div>
            </div>
          </header>    
  </div>
  </template>
  
  <script setup>
  
  </script>
  
  <style scoped>
      .text-secondary {
    color: #6c757d; /* Color secundario similar al de Bootstrap */
  }

  .fs-5 {
    font-size: 1.25rem; /* Tamaño de fuente equivalente a fs-5 */
    flex-direction: column;
  }

  .flex-container {
    display: flex; /* Equivalente a d-flex */
    align-items: center; /* Equivalente a align-items-center */
    margin-bottom: 1rem; /* Equivalente a mb-3 */
}

@media (min-width: 992px) { /* Equivalente a lg (992px) */
    .flex-container {
        margin-bottom: 0; /* Equivalente a mb-lg-0 */
        margin-right: auto; /* Equivalente a me-lg-auto */
    }
}

.text-dark {
    color: #212529; /* Color oscuro */
}

.text-decoration-none {
    
    text-decoration: none; /* Sin decoración de texto */
}
.img-fluid {
  max-width: 100%; /* La imagen no excederá el ancho de su contenedor */
  height: auto; /* Mantiene la proporción de la imagen */
}

.container {
max-width: 1200px; /* Ajusta este valor según tus necesidades */
margin-left: 10px;
margin-right: auto;
padding-left: 5px; /* Espaciado interno */
padding-right: 5px; /* Espaciado interno */
}

.flex-container2 {
display: flex; /* Equivalente a d-flex */
flex-wrap: wrap; /* Equivalente a flex-wrap */
justify-content: left; /* Equivalente a justify-content-center */
}
.item {
   /* background-color: #f8f9fa; /* Color de fondo */
    /* border: 1px solid #dee2e6; */ /* Borde */
    padding: 5px; /* Espaciado interno */
    margin: 10px; /* Espaciado entre elementos */
    flex: 1 1 200px; /* Permite que los elementos crezcan y se encojan */
}
.py-2 {
    padding-top: 1px; /* Relleno superior de 0.5rem (8px) */
    padding-bottom: 1px; /* Relleno inferior de 0.5rem (8px) */
}

.mb-2 {
    margin-bottom: 1px; /* Margen inferior de 0.5rem (8px) */
}

.border-bottom {
    border-bottom: 1px solid #dee2e6; /* Borde inferior */
}
/* Eliminar márgenes de los encabezados */

h4, h5, h6 {

margin: 10px !important; /* Elimina el margen predeterminado */

}
  
  </style>