import 'package:cloud_firestore/cloud_firestore.dart';

class Personal {
  final int id;      // id como atributo del documento
  final int cedula;
  final String name;
  final String surname;
  final DateTime? fechanaci;
  final String tipoSangre;
  final String ciudadNaci;
  final int telefono;
  final String rango;
  final String dependencia;
  final DateTime? fechacrea;
 

  Personal({
    required this.id, required this.cedula, required this.name, required this.surname,
    required this.fechanaci, required this.tipoSangre, required this.ciudadNaci, 
    required this.telefono, required this.rango, required this.dependencia,
    required this.fechacrea,
  });

  factory Personal.fromMap(Map<String, dynamic> data, String documentId) {
    return Personal(
      id: data['id'] ?? 0,
      cedula: data['cedula'] ?? 0,
      name: data['nombres'] ?? '',
      surname: data['apellidos'] ?? '',
      fechanaci: data['fechaNacimiento'] != null 
        ? (data['fechaNacimiento'] as Timestamp).toDate() 
        : null,
      tipoSangre: data['tipoSangre'] ?? '',
      ciudadNaci: data['ciudadNacimiento'] ?? '',
      telefono: data['telefono'] ?? 0,
      rango: data['rangoGrado'] ?? '',
      dependencia: data['dependencia'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cedula': cedula,
      'nombres': name,
      'apellidos': surname,
      'fechaNacimiento': fechanaci != null ? Timestamp.fromDate(fechanaci!) : null,
      'tipoSangre': tipoSangre,
      'ciudadNacimiento': ciudadNaci,
      'telefono': telefono,
      'rangoGrado': rango,
      'dependencia': dependencia,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}
