import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/ordenes/ordenes_model.dart';
import 'package:sispol_7/views/ordenes/ordenes_view.dart';

class OrdenController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Función privada para obtener el próximo ID de orden utilizando una transacción
  Future<int> _getNextOrdenId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('ordenId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        // Si el documento no existe, inicializar el contador
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      int newId = snapshot['currentId'] + 1; // Incrementar el ID actual
      transaction.update(counterRef, {'currentId': newId}); // Actualizar el contador en la base de datos
      return newId;
    });
  }

  // Función para registrar una nueva orden y navegar a otra pantalla en caso de éxito
  Future<void> registerOrden(BuildContext context, Map<String, dynamic> ordenData) async {
    try {
      // Verifica que todos los campos requeridos no estén vacíos
      for (String key in ordenData.keys) {
        if (ordenData[key] == null || (ordenData[key] is String && ordenData[key].isEmpty)) {
          throw Exception('El campo $key no puede estar vacío');
        }
      }

      // Obtener el próximo ID de orden de mantenimiento
      int ordenId = await _getNextOrdenId();

      // Guardar la nueva orden en Firestore con la fecha de creación
      await _firestore.collection('ordenes').doc(ordenId.toString()).set({
        'id': ordenId,
        ...ordenData,
        'fechaEmision': FieldValue.serverTimestamp(),
      });

      // Navegar a otra pantalla en caso de éxito
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(
        context, 
        MaterialPageRoute(builder: (context) => const OrdenesView()) as String,// Pasando los datos a través de las rutas
      );
    } catch (e) {
      // Mostrar un mensaje de error si hay un problema al registrar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final OrdenController ordenController = OrdenController();
  final CollectionReference ordenCollection = FirebaseFirestore.instance.collection('ordenes');

  // Función para obtener la lista de ordenes desde Firestore
  Future<List<Orden>> fetchOrdenes() async {
    QuerySnapshot snapshot = await ordenCollection.get();
    List<Orden> ordenes = snapshot.docs.map((doc) => Orden.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    // Ordenar por el campo "estado" en orden ascendente
    ordenes.sort((a, b) => a.estado.compareTo(b.estado));

    return ordenes;
  }

  // Función para eliminar una orden de Firestore
  Future<void> deleteOrden(int ordenId) async {
    // Eliminar de Firestore
    await ordenCollection.doc(ordenId.toString()).delete();
  }

  // Función para buscar ordenes por el campo "placa"
  Future<List<Orden>> searchOrden(String query) async {
    QuerySnapshot snapshot = await ordenCollection.where('placa', isEqualTo: query).get();
    List<Orden> ordenes = snapshot.docs.map((doc) => Orden.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return ordenes;
  }
}
