// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-app.js";
import { getAuth, updatePassword } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-auth.js";

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyBZe6edAdhwn05UaB0xP37WAtPxyiXpicw",
  authDomain: "sispol-7-913ef.firebaseapp.com",
  databaseURL: "https://sispol-7-913ef-default-rtdb.firebaseio.com",
  projectId: "sispol-7-913ef",
  storageBucket: "sispol-7-913ef.appspot.com",
  messagingSenderId: "588005836404",
  appId: "1:588005836404:web:c581cd61489d2ab7c4b321",
  measurementId: "G-80JG1B10Q4"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);

// Event listener para el formulario de cambio de contraseña
document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault();
  
    // Obtén los valores de los campos de contraseña del formulario
    const nuevaContraseña = document.querySelector('#password1').value;
    const confirmacionContraseña = document.querySelector('#password2').value;
  
    // Verifica que las contraseñas coincidan
    if (nuevaContraseña === confirmacionContraseña) {
      // Obtén la instancia actual de autenticación de Firebase
      const auth = getAuth();
  
      // Obtén el usuario actualmente autenticado
      const user = auth.currentUser;
  
      if (user) {
        // Actualiza la contraseña usando Firebase Authentication
        updatePassword(user, nuevaContraseña).then(() => {
          // Redirigir al usuario a la página de confirmación de cambio de contraseña exitoso
          window.location.href = "../Restablecer_Contraseña/mensajenovappasw.html";
        }).catch((error) => {
          // Manejo de errores, por ejemplo, si el usuario no ha iniciado sesión recientemente
          console.error("Error al actualizar la contraseña: ", error);
          alert("Error al actualizar la contraseña. Puede que necesites volver a iniciar sesión para realizar esta acción.");
        });
      } else {
        alert("No hay un usuario autenticado actualmente.");
      }
    } else {
      alert("Las contraseñas no coinciden. Por favor, inténtalo de nuevo.");
    }
  });