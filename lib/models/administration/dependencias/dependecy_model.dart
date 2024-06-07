import 'package:cloud_firestore/cloud_firestore.dart';

class Dependecy {
  final int id;      // id como atributo del documento
  final String provincia;
  final int nDistr;
  final String parroquia;
  final String codDistr;
  final String nameDistr;
  final int nCircuit;
  final String codCircuit;
  final String nameCircuit;
  final int nsCircuit;
  final String codsCircuit;
  final String namesCircuit;
  final DateTime? fechacrea;
 

  Dependecy({required this.id, required this.provincia, required this.nDistr, required this.parroquia, 
  required this.codDistr, required this.nameDistr, required this.nCircuit, required this.codCircuit, 
  required this.nameCircuit,required this.nsCircuit,required this.codsCircuit, required this.namesCircuit,
  required this.fechacrea});

  factory Dependecy.fromMap(Map<String, dynamic> data, String documentId) {
    return Dependecy(

      id: data['id'] ?? 0,
      provincia: data['provincia'] ?? '',
      nDistr: data['numeroDistritos'] ?? 0,
      parroquia: data['parroquia'] ?? '',
      codDistr: data['codigoDistrito'] ?? '',
      nameDistr: data['nombreDistrito'] ?? '',
      nCircuit: data['numeroCircuitos'] ?? 0,
      codCircuit: data['codigoCircuito'] ?? '',
      nameCircuit: data['nombreCircuito'] ?? '',
      nsCircuit: data['numeroSubcircuitos'] ?? 0,
      codsCircuit: data['codigoSubcircuito'] ?? '',
      namesCircuit: data['nombreSubcircuito'] ?? '',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'provincia': provincia,
      'numeroDistritos': nDistr,
      'parroquia': parroquia,
      'codigoDistrito': codDistr,
      'nombreDistrito': nameDistr,
      'numeroCircuitos': nCircuit,
      'codigoCircuito': codCircuit,
      'nombreCircuito': nameCircuit,
      'numeroSubcircuitos': nsCircuit,
      'codigoSubcircuito': codsCircuit,
      'nombreSubcircuito': namesCircuit,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}