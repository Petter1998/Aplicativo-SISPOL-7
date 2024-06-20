import 'package:cloud_firestore/cloud_firestore.dart';

class Repuesto {
  final int id;      // id como atributo del documento
  final String nombre;
  final String fechaadqui;
  final String contrato;
  final String modelo;
  final String marca;
  final String ubicacion;
  final double precio;
  final int cantidad;
  final DateTime? fechacrea;
 

  Repuesto({required this.id, required this.nombre, required this.fechaadqui, 
  required this.contrato ,required this.modelo, required this.marca, 
  required this.ubicacion, required this.precio, required this.cantidad,
  required this.fechacrea});

  factory Repuesto.fromMap(Map<String, dynamic> data, String documentId) {
    return Repuesto(

      id: data['id'] ?? 0,
      nombre: data['nombre'] ?? '',
      fechaadqui: data['fechaAdquisicion'] ?? '',
      contrato: data['contrato'] ?? '',
      modelo: data['modelo'] ?? '',
      marca: data['marca'] ?? '',
      ubicacion: data['ubicacion'] ?? '',
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
      'contrato': contrato,
      'modelo': modelo,
      'marca': marca,
      'ubicacion': ubicacion,
      'precio': precio,
      'cantidad': cantidad,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}