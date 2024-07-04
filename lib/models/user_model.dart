import 'package:cloud_firestore/cloud_firestore.dart';

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

