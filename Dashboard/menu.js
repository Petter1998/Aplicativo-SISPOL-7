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

// Añade este evento de clic para el botón de Mantenimiento
document.getElementById('menu-mantenimiento').addEventListener('click', function(event) {
    event.stopPropagation(); // Previene que el clic se propague
    var submenu = document.getElementById('submenu-mantenimiento');
    submenu.classList.toggle('active'); // Muestra u oculta el submenú
  });
  
  // Añade un evento para cerrar el submenú si se hace clic fuera de él
  document.addEventListener('click', function(event) {
    var submenu = document.getElementById('submenu-mantenimiento');
    if (submenu.classList.contains('active')) {
      submenu.classList.remove('active');
    }
  });
  

