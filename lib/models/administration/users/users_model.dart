import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UsersModel {
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

  Future<void> registerUsers(Map<String, dynamic> userData) async {
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

class User {
  final String uid;  // uid como identificador del documento
  final int id;      // id como atributo del documento
  final String name;
  final String surname;
  final String email;
  final String cedula;
  final String cargo;
  final DateTime? fechacrea;
  final String telefono;
  final String user;

  User({required this.uid, required this.id, required this.name, required this.surname, 
  required this.email, required this.cedula, required this.cargo, required this.fechacrea, 
  required this.telefono, required this.user});

  factory User.fromMap(Map<String, dynamic> data, String documentId) {
    return User(
      uid: documentId,
      id: data['id'] ?? 0,
      name: data['nombres'] ?? '',
      surname: data['apellidos'] ?? '',
      email: data['email'] ?? '',
      cedula: data['cedula'] ?? '',
      cargo: data['cargo'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
      telefono: data['telefono'] ?? '',
      user: data['usuario'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombres': name,
      'apellidos': surname,
      'email': email,
      'cedula': cedula,
      'cargo': cargo,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
      'telefono': telefono,
      'usuario': user,
    };
  }
}