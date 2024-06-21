import 'package:cloud_firestore/cloud_firestore.dart';

class Roles {
  final int id;
  final String rol;
  final String autor;
  final String descripcion;
  final String nivelacceso;
  final int? usuarioasigg;
  final String estado;
  final DateTime? fechacrea;

  Roles({
    required this.id, required this.rol, required this.autor,
    required this.descripcion, required this.nivelacceso,
    this.usuarioasigg, required this.estado,
    this.fechacrea,
  });

  factory Roles.fromMap(Map<String, dynamic> data, String documentId) {
    return Roles(
      id: data['id'] ?? 0,
      rol: data['rol'] ?? '',
      autor: data['autor'] ?? '',
      descripcion: data['descripcion'] ?? '',
      nivelacceso: data['nivelAcceso'] ?? '',
      usuarioasigg: data['usuariosAsignados'] ?? 0,
      estado: data['estado'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rol': rol,
      'autor': autor,
      'descripcion': descripcion,
      'nivelAcceso': nivelacceso,
      'usuariosAsignados': usuarioasigg,
      'estado': estado,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}