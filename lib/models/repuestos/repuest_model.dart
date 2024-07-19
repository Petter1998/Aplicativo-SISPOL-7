
import 'package:cloud_firestore/cloud_firestore.dart';

class Repuest {
  final int id; // id como atributo del documento
  final String nombre;
  final DateTime fechaIngreso;
  final int idUser;
  final String categoria;
  final String marca;
  final String modelo;
  final String proveedor;
  final double precio;
  final int stock;

  Repuest({
    required this.id,
    required this.nombre,
    required this.fechaIngreso,
    required this.idUser,
    required this.categoria,
    required this.marca,
    required this.modelo,
    required this.proveedor,
    required this.precio,
    required this.stock,
  });

  factory Repuest.fromMap(Map<String, dynamic> data, String documentId) {
    return Repuest(
      id: data['id'] ?? 0,
      nombre: data['nombre'] ?? '',
      fechaIngreso: data['fechaIngreso'] != null
          ? (data['fechaIngreso'] as Timestamp).toDate()
          : DateTime.now(),
      idUser: data['idUser'] ?? 0,
      categoria: data['categoria'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      proveedor: data['proveedor'] ?? '',
      precio: data['precio'] ?? 0.0,
      stock: data['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaIngreso': Timestamp.fromDate(fechaIngreso),
      'idUser': idUser,
      'categoria': categoria,
      'marca': marca,
      'modelo': modelo,
      'proveedor': proveedor,
      'precio': precio,
      'stock': stock,
    };
  }
}
