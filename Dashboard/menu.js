function initializeMenu() {
    const cloud = document.getElementById("cloud");
    const barraLateral = document.querySelector(".barra-lateral");

    const spans = document.querySelectorAll("span");
    const menu = document.querySelector(".menu");
    const main = document.querySelector("main");

    menu.addEventListener("click",()=>{
        barraLateral.classList.toggle("max-barra-lateral");
        if(barraLateral.classList.contains("max-barra-lateral")){
            menu.children[0].style.display = "none";
            menu.children[1].style.display = "block";
        }
        else{
            menu.children[0].style.display = "block";
            menu.children[1].style.display = "none";
        }
        if(window.innerWidth<=320){
            barraLateral.classList.add("mini-barra-lateral");
            main.classList.add("min-main");
            spans.forEach((span)=>{
                span.classList.add("oculto");
            })
        }
    });

    cloud.addEventListener("click",()=>{
        barraLateral.classList.toggle("mini-barra-lateral");
        main.classList.toggle("min-main");
        spans.forEach((span)=>{
            span.classList.toggle("oculto");
        });
    });


    // Selecciona la nueva barra lateral de administración y el botón de regresar
    const barraLateralAdministracion = document.querySelector(".barra-lateral-administracion");
    const botonRegresar = document.querySelector(".boton-regresar");
    const admin = document.getElementById("admin");

    // Evento para mostrar la barra lateral de administración
    admin.addEventListener("click", () => {
        barraLateralAdministracion.style.left = "0"; // Muestra la barra lateral
    });

    // Evento para ocultar la barra lateral de administración y mostrar la principal
    botonRegresar.addEventListener("click", () => {
        barraLateralAdministracion.style.left = "-250px"; // Oculta la barra lateral
    });

    
    // Selecciona la nueva barra lateral de control de acceso y el botón de regresar
    const barraLateralControl = document.querySelector(".barra-lateral-control");
    const botonRegresar1 = document.querySelector(".boton-regresar1");
    const control = document.getElementById("control");

    // Evento para mostrar la barra lateral de control
    control.addEventListener("click", () => {
        barraLateralControl.style.left = "0"; // Muestra la barra lateral
    });

    // Evento para ocultar la barra lateral de control y mostrar la principal
    botonRegresar1.addEventListener("click", () => {
        barraLateralControl.style.left = "-250px"; // Oculta la barra lateral
    });


    // Selecciona la nueva barra lateral de documentos y el botón de regresar
    const barraLateralDocumento = document.querySelector(".barra-lateral-documento");
    const botonRegresar2 = document.querySelector(".boton-regresar2");
    const doc = document.getElementById("doc");

    // Evento para mostrar la barra lateral de documentos
    doc.addEventListener("click", () => {
        barraLateralDocumento.style.left = "0"; // Muestra la barra lateral
    });

    // Evento para ocultar la barra lateral de docuemntos y mostrar la principal
    botonRegresar2.addEventListener("click", () => {
        barraLateralDocumento.style.left = "-250px"; // Oculta la barra lateral
    });


    // Selecciona la nueva barra lateral de mantenimiento y el botón de regresar
    const barraLateralMantenimiento = document.querySelector(".barra-lateral-mantenimiento");
    const botonRegresar3 = document.querySelector(".boton-regresar3");
    const mant = document.getElementById("mant");

    // Evento para mostrar la barra lateral de mantenimiento
    mant.addEventListener("click", () => {
        barraLateralMantenimiento.style.left = "0"; // Muestra la barra lateral
    });

    // Evento para ocultar la barra lateral de mantenimiento y mostrar la principal
    botonRegresar3.addEventListener("click", () => {
        barraLateralMantenimiento.style.left = "-250px"; // Oculta la barra lateral
    });


    // Selecciona la nueva barra lateral de reporte y el botón de regresar
    const barraLateralReporte = document.querySelector(".barra-lateral-reporte");
    const botonRegresar4 = document.querySelector(".boton-regresar4");
    const report = document.getElementById("report");

    // Evento para mostrar la barra lateral de reporte
    report.addEventListener("click", () => {
        barraLateralReporte.style.left = "0"; // Muestra la barra lateral
    });

    // Evento para ocultar la barra lateral de reporte y mostrar la principal
    botonRegresar4.addEventListener("click", () => {
        barraLateralReporte.style.left = "-250px"; // Oculta la barra lateral
    });

}

window.initializeMenu = initializeMenu;