// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-app.js";
import { getFirestore, collection, addDoc } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-firestore.js";
import { getAuth, signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-auth.js";

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
const firestore = getFirestore(app);
const auth = getAuth(app);

// Registro de datos
document.addEventListener('DOMContentLoaded', function() {

    // Referencia al formulario de registro por su ID
    const registroForm = document.getElementById('registroForm');
  
    // Escucha el evento de envío del formulario
    registroForm.addEventListener('submit', function(e) {
      // Previene el envío del formulario de forma predeterminada
      e.preventDefault();
  
      // Recoge los valores de los campos del formulario
      const nombres = document.querySelector('input[id="Nombres"]').value;
      const apellidos = document.querySelector('input[id="Apellidos"]').value;
      const identificacion = document.querySelector('input[id="Identificacion"]').value;
      const telefono = document.querySelector('input[id="Telefono"]').value;
      const email = document.querySelector('input[id="Email"]').value;
      const password = document.querySelector('input[id="Password"]').value;
      const usuario = document.querySelector('input[id="Usuario"]').value;
      const cargo = document.querySelector('input[id="Cargo"]').value;
  
      // Agrega un nuevo documento con un ID generado automáticamente
      addDoc(collection(firestore, "usuarios"), {
        nombres: nombres,
        apellidos: apellidos,
        cedula: identificacion,
        telefono: telefono,
        email: email,
        password: password,
        usuario: usuario,
        cargo: cargo
      })
      .then((docRef) => {
        console.log("Documento escrito con ID: ", docRef.id);
        // Redirigir a otra página
        window.location.href = "../Inicio_Sesion/logginmensaje.html";
      })
      .catch((error) => {
        console.error("Error al añadir el documento: ", error);
      });
    });
});


// Función para manejar el inicio de sesión
function handleLogin(event) {
  event.preventDefault(); // Prevenir el envío predeterminado del formulario

  // Obtener el correo electrónico y la contraseña del formulario
  const email = document.getElementById('email').value;
  const password = document.getElementById('pass').value;

  // Iniciar sesión utilizando Firebase Authentication
  signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
      // Inicio de sesión exitoso
      console.log('¡Inicio de sesión exitoso!');
      // Aquí puedes redirigir al usuario a otra página o realizar acciones adicionales
      window.location.href = 'ruta_a_tu_aplicativo.html'; // Cambia esto por la ruta correspondiente
    })
    .catch((error) => {
      // Manejo de errores
      console.error('Error al iniciar sesión: ', error);
      // Puedes mostrar un mensaje de error al usuario aquí
    });
}

// Adjuntar el evento de envío al formulario
document.addEventListener('DOMContentLoaded', () => {
  document.getElementById('login').addEventListener('submit', handleLogin);
});
  


