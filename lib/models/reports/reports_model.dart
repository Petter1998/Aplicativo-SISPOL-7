import 'package:cloud_firestore/cloud_firestore.dart';

class Reportes {
  final int id;
  final String fechasol;
  final String fechareg;
  final String fechaentreg;
  final String responsableentreg;
  final String responsablereti;
  final int kilometrajeActual;
  final int kilometrajeProx;
  final String tipoMant;
  final String mantComple;
  final String observaciones;
  final DateTime? fechacrea;

  Reportes({
    required this.id, required this.fechasol, required this.fechareg,
    required this.fechaentreg, required this.responsableentreg,
    required this.responsablereti, required this.kilometrajeActual, 
    required this.kilometrajeProx,required this.tipoMant,
    required this.mantComple, required this.observaciones, this.fechacrea,
  });

  factory Reportes.fromMap(Map<String, dynamic> data, String documentId) {
    return Reportes(
      id: data['id'] ?? 0,
      fechasol: data['fechaSolicitud'] ?? '',
      fechareg: data['fechaRegistro'] ?? '',
      fechaentreg: data['fechaEntrega'] ?? '',
      responsableentreg: data['responsableEntrega'] ?? '',
      responsablereti: data['responsableRetira'] ?? '',
      kilometrajeActual: data['kilometrajeActual'] ?? 0,
      kilometrajeProx: data['kilometrajeProximoMant'] ?? 0,
      tipoMant: data['tipoMantenimiento'] ?? '',
      mantComple: data['mantenimientoComplementario'] ?? '',
      observaciones: data['observaciones'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaSolicitud': fechasol,
      'fechaRegistro': fechareg,
      'fechaEntrega': fechaentreg,
      'responsableEntrega': responsableentreg,
      'responsableRetira': responsablereti,
      'kilometrajeActual': kilometrajeActual,
      'kilometrajeProximoMant': kilometrajeProx,
      'tipoMantenimiento': tipoMant,
      'mantenimientoComplementario': mantComple,
      'observaciones': observaciones,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}