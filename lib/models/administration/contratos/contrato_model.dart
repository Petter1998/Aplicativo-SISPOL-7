import 'package:cloud_firestore/cloud_firestore.dart';

class Contrato {
  final int id; // id como atributo del documento
  final String nombre;      
  final String fechainicio;
  final String fechafin;
  final String tipocontrato;
  final String proveedor;
  final String tiporepuestos;
  final String vehiculoscubiertos;
  final double monto;
  final DateTime? fechacrea;
 

  Contrato({required this.id, required this.nombre, required this.fechainicio, 
  required this.fechafin, 
  required this.tipocontrato ,required this.proveedor, required this.tiporepuestos, 
  required this.vehiculoscubiertos, required this.monto,
  required this.fechacrea});

  factory Contrato.fromMap(Map<String, dynamic> data, String documentId) {
    return Contrato(

      id: data['id'] ?? 0,
      nombre: data['nombreContrato'] ?? '',
      fechainicio: data['fechaInicio'] ?? '',
      fechafin: data['fechaFinal'] ?? '',
      tipocontrato: data['tipoContrato'] ?? '',
      proveedor: data['proveedor'] ?? '',
      tiporepuestos: data['tipoRepuestos'] ?? '',
      vehiculoscubiertos: data['vehiculosCubiertos'] ?? '',
      monto: data['monto'] ?? 0.0,
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombreContrato': nombre,
      'fechaInicio': fechainicio,
      'fechaFinal': fechafin,
      'tipoContrato': tipocontrato,
      'proveedor': proveedor,
      'tipoRepuestos': tiporepuestos,
      'vehiculosCubiertos': vehiculoscubiertos,
      'monto': monto,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}

