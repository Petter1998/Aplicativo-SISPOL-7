//Escucha eventos de teclado (keyup y change), enfocar (focus) y desenfocar (blur) en los campos de entrada 
//de un formulario.
$('.form').find('input').on('keyup blur focus', function (e) {
  
  var $this = $(this),
      label = $this.prev('label');

	  if (e.type === 'keyup'|| e.type === 'change') { // Añadir chequeo para 'change'
			if ($this.val() === '') {
          label.removeClass('active highlight');
        } else {
          label.addClass('active highlight');
        }
    } else if (e.type === 'blur') {
    	if( $this.val() === '' ) {
    		label.removeClass('active highlight'); 
			} else {
		    label.removeClass('highlight');   
			}   
    } else if (e.type === 'focus') {
      
      if( $this.val() === '' ) {
    		label.removeClass('highlight'); 
			} 
      else if( $this.val() !== '' ) {
		    label.addClass('highlight');
			}
    }

});



//Al cargar la página, añade la clase active a la etiqueta que precede inmediatamente a cualquier 
//campo de entrada de tipo fecha, y asegura que esta etiqueta permanezca activa independientemente 
//de si el campo de fecha está enfocado o desenfocado.
$(document).ready(function() {
  // Selecciona el label que precede inmediatamente a mi input de tipo 'date'
  var dateLabel = $('input[type="date"]').prev('label');

  // Añade  la clase 'active' al cargar la página
  dateLabel.addClass('active');

  // Manejar eventos de focus y blur
  $('input[type="date"]').on('focus blur', function(e) {
    // Mantener la etiqueta siempre activa
    dateLabel.addClass('active');
  });
});



//Maneja los clics en las pestañas dentro de una interfaz de usuario de pestañas.
$('.tab a').on('click', function (e) {
  
  e.preventDefault();
  
  $(this).parent().addClass('active');
  $(this).parent().siblings().removeClass('active');
  
  target = $(this).attr('href');

  $('.tab-content > div').not(target).hide();
  
  $(target).fadeIn(600);
  
});


//Checkbox de Mostrar contraseña en Registrar
document.addEventListener('DOMContentLoaded', (e) => {
  const togglePassword = document.getElementById('togglePassword');
  const password = document.getElementById('Password');

  togglePassword.addEventListener('change', (e) => {
    const type = togglePassword.checked ? 'text' : 'password';
    password.setAttribute('type', type);
    // Esto cambia el tipo de input y muestra/oculta la contraseña
  });
});
