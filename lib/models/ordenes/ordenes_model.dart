class Orden {
  final int id;
  final String fechaEmision;
  final String personalEmite;
  final String personalVehiculo;
  final String estado;
  final String vehiculo;
  final String? lubricantes;
  final String? repuestos;

 Orden({
    required this.id,
    required this.fechaEmision,
    required this.personalEmite,
    required this.personalVehiculo,
    required this.estado,
    required this.vehiculo,
    this.lubricantes,
    this.repuestos,
  });

  factory Orden.fromMap(Map<String, dynamic> data, String documentId) {
    return Orden(
      id: data['id'] ?? 0,
      fechaEmision: data['fechaEmision'] ?? '',
      personalEmite: data['personalEmite'] ?? '',
      personalVehiculo: data['personalVehiculo'] ?? '',
      estado: data['estado'] ?? '',
      vehiculo: data['vehiculo'] ?? '',
      lubricantes: data['lubricantes'],
      repuestos: data['repuestos'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fechaEmision': fechaEmision,
      'personalEmite': personalEmite,
      'personalVehiculo': personalVehiculo,
      'estado': estado,
      'vehiculo': vehiculo,
      'lubricantes': lubricantes,
      'repuestos': repuestos,
    };
  }
}
