// Import the functions you need from the SDKs you need
import { initializeApp } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-app.js";
import { getFirestore, query, collection, where, getDocs } from "https://www.gstatic.com/firebasejs/10.10.0/firebase-firestore.js";

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


// Evento para manejar el envío del formulario
document.querySelector('form').addEventListener('submit', function(e) {
    e.preventDefault();
  
    const identification = document.querySelector('#identification').value;
  
    // Crea una consulta para buscar en la base de datos 'usuarios' donde la identificación coincida
    const q = query(collection(firestore, "usuarios"), where("cedula", "==", identification));
  
    getDocs(q).then((querySnapshot) => {
      if (querySnapshot.docs.length > 0) {
        // Usuario encontrado, redirigir y mostrar su información
        const user = querySnapshot.docs[0].data().usuario;
        sessionStorage.setItem('recoveredUser', user); // Guardar el usuario en sessionStorage
        window.location.href = '/Inicio_Sesion/Recuperacion/Recuperar Usuario/loginrecuperacionusuario.html';
      } else {
        // Usuario no encontrado, manejar el caso adecuadamente
        alert('Identificación no encontrada.');
      }
    }).catch((error) => {
      console.error("Error al buscar la identificación: ", error);
    });
  });