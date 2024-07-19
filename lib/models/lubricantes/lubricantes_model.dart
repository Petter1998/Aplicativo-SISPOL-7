import 'package:cloud_firestore/cloud_firestore.dart';

class Lubricante {
  final double capacidad;
  final DateTime fechaIngreso;
  final DateTime fechaVence;
  final int id;
  final int idUser;
  final String marca;
  final String nombre;
  final double precio;
  final String proveedor;
  final int stock;
  final String tipo;
  final int viscosidad;

  Lubricante({
    required this.capacidad,
    required this.fechaIngreso,
    required this.fechaVence,
    required this.id,
    required this.idUser,
    required this.marca,
    required this.nombre,
    required this.precio,
    required this.proveedor,
    required this.stock,
    required this.tipo,
    required this.viscosidad,
  });

  factory Lubricante.fromMap(Map<String, dynamic> data, String documentId) {
    return Lubricante(
      capacidad: data['capacidad'] ?? 0.0,
      fechaIngreso: data['fechaIngreso'] != null
          ? (data['fechaIngreso'] as Timestamp).toDate()
          : DateTime.now(),
      fechaVence: data['fechaVence'] != null
          ? (data['fechaVence'] as Timestamp).toDate()
          : DateTime.now(),
      id: data['id'] ?? 0,
      idUser: data['idUser'] ?? 0,
      marca: data['marca'] ?? '',
      nombre: data['nombre'] ?? '',
      precio: data['precio'] ?? 0.0,
      proveedor: data['proveedor'] ?? '',
      stock: data['stock'] ?? 0,
      tipo: data['tipo'] ?? '',
      viscosidad: data['viscosidad'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'capacidad': capacidad,
      'fechaIngreso': Timestamp.fromDate(fechaIngreso),
      'fechaVence': Timestamp.fromDate(fechaVence),
      'id': id,
      'idUser': idUser,
      'marca': marca,
      'nombre': nombre,
      'precio': precio,
      'proveedor': proveedor,
      'stock': stock,
      'tipo': tipo,
      'viscosidad': viscosidad,
    };
  }
}
