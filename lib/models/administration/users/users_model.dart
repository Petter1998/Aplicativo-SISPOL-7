import 'package:cloud_firestore/cloud_firestore.dart';

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