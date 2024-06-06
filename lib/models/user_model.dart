import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<int> _getNextUserId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('usuarioId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      int newId = snapshot['currentId'] + 1;
      transaction.update(counterRef, {'currentId': newId});
      return newId;
    });
  }

  Future<void> registerUser(Map<String, dynamic> userData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in userData.keys) {
      if (userData[key] == null || (userData[key] is String && userData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Elimina la contraseña del mapa antes de enviarlo a Firestore
    

    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: userData['email'],
      password: userData['password'],
    );

    // Elimina la contraseña del mapa antes de enviarlo a Firestore
    userData.remove('password');

    // Obtener el próximo ID de usuario
    int userId = await _getNextUserId();

    await _firestore.collection('usuarios').doc(userCredential.user!.uid).set({
      'id': userId,
      ...userData,
      'fechaCreacion': FieldValue.serverTimestamp(),
      'uid': userCredential.user!.uid,
    });
  }
}

class Usuario {
  final String uid;
  final int id;  
  final String nombre;
  final String apellido;
  final String rol;
  final DateTime? fechacrea;
  final String cedula;
  final String email;
  final String usuario;
  final String telefono;

  Usuario({
    required this.uid,
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.rol,
    required this.fechacrea, 
    required this.cedula,
    required this.email,
    required this.usuario,
    required this.telefono,
  });

  factory Usuario.fromFirestore(Map<String, dynamic> data) {
    return Usuario(
      uid: data['uid'],
      id: data['id'] ?? 0,
      nombre: data['nombres'] ?? '',
      apellido: data['apellidos'] ?? '',
      rol: data['cargo'] ?? '',
      fechacrea: (data['fechaCreacion'] as Timestamp).toDate(),
      cedula: data['cedula'] ?? '',
      email: data['email'] ?? '',
      usuario: data['usuario'] ?? '',
      telefono: data['telefono'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': nombre,
      'apellidos': apellido,
      'email': email,
      'cedula': cedula,
      'cargo': rol,
      'fechaCreacion': Timestamp.fromDate(fechacrea!),
      'telefono': telefono,
      'usuario': usuario,
    };
  }
}

