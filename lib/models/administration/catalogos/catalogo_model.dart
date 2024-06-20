import 'package:cloud_firestore/cloud_firestore.dart';

class Catalogo {
  final int id; // id como atributo del documento
  final String nombre;      
  final String categoria;
  final String proveedor;
  final String tiporepuestos;
  final String vigente;
  final DateTime? fechacrea;
 

  Catalogo({required this.id, required this.nombre,  
  required this.categoria ,required this.proveedor, required this.tiporepuestos, 
  required this.vigente, required this.fechacrea});

  factory Catalogo.fromMap(Map<String, dynamic> data, String documentId) {
    return Catalogo(

      id: data['id'] ?? 0,
      nombre: data['nombreCatalogo'] ?? '',
      categoria: data['categoria'] ?? '',
      proveedor: data['proveedor'] ?? '',
      tiporepuestos: data['tipoRepuestos'] ?? '',
      vigente: data['vigente'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreCatalogo': nombre,
      'categoria': categoria,
      'proveedor': proveedor,
      'tipoRepuestos': tiporepuestos,
      'vigente': vigente,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}