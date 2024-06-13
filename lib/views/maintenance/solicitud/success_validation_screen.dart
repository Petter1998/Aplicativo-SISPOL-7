import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleInfoScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> vehicleDoc;

  VehicleInfoScreen({required this.vehicleDoc});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = vehicleDoc.data()!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Vehículo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Table(
          border: TableBorder.all(),
          children: [
            TableRow(children: [
              Text('Campo', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Valor', style: TextStyle(fontWeight: FontWeight.bold)),
            ]),
            ...data.entries.map((entry) {
              return TableRow(children: [
                Text(entry.key),
                Text(entry.value.toString()),
              ]);
            }).toList(),
          ],
        ),
      ),
    );
  }
}
