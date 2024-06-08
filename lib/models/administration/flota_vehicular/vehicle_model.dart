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
  final DateTime? fechacrea;

  Vehicle({
    required this.id, required this.marca, required this.modelo,
    required this.motor, required this.placa, required this.chasis,
    required this.tipo, required this.cilindraje, required this.capacidadPas,
    required this.capacidadCar, required this.kilometraje, required this.fechacrea,
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
      'fechaCreacion': fechacrea != null ? Timestamp.fromDate(fechacrea!) : null,
    };
  }
}