// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-app.js";
import { getFirestore } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-firestore.js";
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

// Escuchar el evento de envío del formulario y autenticar al usuario
const loginForm = document.querySelector('form');
loginForm.addEventListener('submit', function(e) {
    e.preventDefault();

    const email = document.querySelector('#email').value;
    const password = document.querySelector('#pass').value;

    signInWithEmailAndPassword(auth, email, password)
    .then((userCredential) => {
        // Usuario autenticado, redirigir a la página de inicio
        window.location.href = '../dashboard/inicio.html';
    })
    .catch((error) => {
        // Manejar errores aquí, como mostrar un mensaje al usuario
        console.error("Error en la autenticación: ", error.message);
        // Usuario no encontrado, manejar el caso adecuadamente
        alert('Error en la autenticación');
    });
});
