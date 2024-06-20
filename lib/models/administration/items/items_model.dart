import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final int id;      // id como atributo del documento
  final String nombre;
  final String fechaadqui;
  final String modelo;
  final String marca;
  final String estado;
  final double precio;
  final int cantidad;
  final DateTime? fechacrea;
 

  Item({required this.id, required this.nombre, required this.fechaadqui, required this.modelo, 
  required this.marca, required this.estado, required this.precio, required this.cantidad,
  required this.fechacrea});

  factory Item.fromMap(Map<String, dynamic> data, String documentId) {
    return Item(

      id: data['id'] ?? 0,
      nombre: data['nombre'] ?? '',
      fechaadqui: data['fechaAdquisicion'] ?? '',
      modelo: data['modelo'] ?? '',
      marca: data['marca'] ?? '',
      estado: data['estado'] ?? '',
      precio: data['precio'] ?? 0.0,
      cantidad: data['cantidad'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'fechaAdquisicion': fechaadqui,
      'modelo': modelo,
      'marca': marca,
      'estado': estado,
      'precio': precio,
      'cantidad': cantidad,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}