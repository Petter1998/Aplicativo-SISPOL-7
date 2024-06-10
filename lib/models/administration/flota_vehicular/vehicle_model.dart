import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final int id;
  final String marca;
  final String modelo;
  final String motor;
  final String placa;
  final String chasis;
  final String tipo;
  final double cilindraje;
  final int capacidadPas;
  final int capacidadCar;
  final int kilometraje;
  final String dependencia;
  final String responsable1;
  final String responsable2;
  final String responsable3;
  final String responsable4;
  final DateTime? fechacrea;

  Vehicle({
    required this.id, required this.marca, required this.modelo,
    required this.motor, required this.placa, required this.chasis,
    required this.tipo, required this.cilindraje, required this.capacidadPas,
    required this.capacidadCar, required this.kilometraje, required this.dependencia, 
    this.responsable1='N/A', this.responsable2='N/A', this.responsable3='N/A',
    this.responsable4='N/A',required this.fechacrea,
  });

  factory Vehicle.fromMap(Map<String, dynamic> data, String documentId) {
    return Vehicle(
      id: data['id'] ?? 0,
      marca: data['marca'] ?? '',
      modelo: data['modelo'] ?? '',
      motor: data['motor'] ?? '',
      placa: data['placa'] ?? '',
      chasis: data['chasis'] ?? '',
      tipo: data['tipo'] ?? '',
      cilindraje: data['cilindraje'] ?? 0,
      capacidadPas: data['capacidadPasajeros'] ?? 0,
      capacidadCar: data['capacidadCarga'] ?? 0,
      kilometraje: data['kilometraje'] ?? 0,
      dependencia: data['dependencia'] ?? '',
      responsable1: data['responsable1'] ?? 'N/A',
      responsable2: data['responsable2'] ?? 'N/A',
      responsable3: data['responsable3'] ?? 'N/A',
      responsable4: data['responsable4'] ?? 'N/A',
      fechacrea: data['fechaCreacion'] != null 
        ? (data['fechaCreacion'] as Timestamp).toDate() 
        : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marca': marca,
      'modelo': modelo,
      'motor': motor,
      'placa': placa,
      'chasis': chasis,
      'tipo': tipo,
      'cilindraje': cilindraje,
      'capacidadPasajeros': capacidadPas,
      'capacidadCarga': capacidadCar,
      'kilometraje': kilometraje,
      'dependencia': dependencia,
      'responsable1': responsable1,
      'responsable2': responsable2,
      'responsable3': responsable3,
      'responsable4': responsable4,
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}