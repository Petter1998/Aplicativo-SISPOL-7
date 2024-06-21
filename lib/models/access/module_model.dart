import 'package:cloud_firestore/cloud_firestore.dart';

class Modulos {
  final int id;
  final String nombre;
  final String autor;
  final String subModulos;
  final String observaciones;
  final DateTime? fechacrea;

  Modulos({
    required this.id, required this.nombre, required this.autor,
    required this.subModulos, required this.observaciones,
    this.fechacrea,
  });

  factory Modulos.fromMap(Map<String, dynamic> data, String documentId) {
    return Modulos(
      id: data['id'] ?? 0,
      nombre: data['nombre'] ?? '',
      autor: data['autor'] ?? '',
      subModulos: data['subModulos'] ?? '',
      observaciones: data['observaciones'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'autor': autor,
      'subModulos': subModulos,
      'observaciones': observaciones,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}