import firebase from "firebase/app";
import "firebase/firestore";

// TODO: Replace the following with your app's Firebase project configuration
// See: https://support.google.com/firebase/answer/7015592
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
firebase.initializeApp(firebaseConfig);


// Initialize Cloud Firestore and get a reference to the service
const db = firebase.firestore();


// Registro de datos
document.addEventListener('DOMContentLoaded', function() {

    // Referencia al formulario de registro por su ID
    const registroForm = document.getElementById('registroForm');
  
    // Escucha el evento de envío del formulario
    registroForm.addEventListener('submit', function(e) {
      // Previene el envío del formulario de forma predeterminada
      e.preventDefault();
  
      // Recoge los valores de los campos del formulario
      const nombres = document.querySelector('input[name="Nombres"]').value;
      const apellidos = document.querySelector('input[name="Apellidos"]').value;
      const identificacion = document.querySelector('input[name="Identificacion"]').value;
      const telefono = document.querySelector('input[name="Telefono"]').value;
      const email = document.querySelector('input[name="Email"]').value;
      const password = document.querySelector('input[name="Password"]').value;
      const usuario = document.querySelector('input[name="Usuario"]').value;
      const cargo = document.querySelector('input[name="Cargo"]').value;
  
      // Referencia a la base de datos de Firestore
      const db = firebase.firestore();
  
      // Agrega un nuevo documento con un ID generado automáticamente
      db.collection("usuarios").add({
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
  



