import 'package:cloud_firestore/cloud_firestore.dart';

class Documentos {
  final int id;
  final String fecha;
  final String hora;
  final int kilometrajeActual;
  final String estado;
  final String tipo;
  final String placa;
  final String marca;
  final String modelo;
  final String cedula;
  final String responsable;
  final String asunto;
  final String detalle;
  final String tipoMant;
  final String mantComple;
  final double total;
  final DateTime? fechacrea;

  Documentos({
    required this.id, required this.fecha, required this.hora,
    required this.kilometrajeActual, this.estado='N/A', required this.tipo, required this.placa,
    required this.marca, required this.modelo, required this.cedula,
    required this.responsable, required this.asunto,
    required this.detalle, required this.tipoMant,
    required this.mantComple, required this.total, this.fechacrea,
  });

  factory Documentos.fromMap(Map<String, dynamic> data, String documentId) {
    return Documentos(
      id: data['id'] ?? 0,
      fecha: data['fecha'] ?? '',
      hora: data['hora'] ?? '',
      kilometrajeActual: data['kilometrajeActual'] ?? 0,
      estado: data['estado'] ?? 'N/A',
      tipo: data['tipo'] ?? '',
      placa: data['placa'] ?? '',
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      cedula: data['cedula'] ?? '',
      responsable: data['responsable'] ?? '',
      asunto: data['asunto'] ?? '',
      detalle: data['detalle'] ?? '',
      tipoMant: data['tipoMantenimiento'] ?? '',
      mantComple: data['mantenimientoComplementario'] ?? '',
      total: data['total'] ?? 0.0,
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha': fecha,
      'hora': hora,
      'kilometrajeActual': kilometrajeActual,
      'estado': estado,
      'tipo': tipo,
      'placa': placa,
      'marca': marca,
      'modelo': modelo,
      'cedula': cedula,
      'responsable': responsable,
      'asunto': asunto,
      'detalle': detalle,
      'tipoMantenimiento': tipoMant,
      'mantenimientoComplementario': mantComple,
      'total': total,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}