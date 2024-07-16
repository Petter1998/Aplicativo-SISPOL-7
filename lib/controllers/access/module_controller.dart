import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/access/module_model.dart';

class ModuleController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference moduleCollection = FirebaseFirestore.instance.collection('modulos');

  // Función privada para obtener el próximo ID de módulo utilizando una transacción
  Future<int> _getNextDocId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('moduleId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        // Si el documento no existe, inicializar el contador
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      int newId = snapshot['currentId'] + 1; // Incrementa el ID actual
      transaction.update(counterRef, {'currentId': newId});
      return newId;
    });
  }

  // Función para registrar un nuevo módulo en Firestore
  Future<void> registerModule(BuildContext context, Map<String, dynamic> modData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in modData.keys) {
      if (modData[key] == null || (modData[key] is String && modData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtiene el próximo ID de de módulo
    int modId = await _getNextDocId();

    // Guardar el nuevo módulo en Firestore con la fecha de creación
    await _firestore.collection('modulos').doc(modId.toString()).set({
      'id': modId,
      ...modData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });

    try {
      // Navega hacia atrás después de registrar el módulo
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // Mostrar un mensaje de error si hay un problema al registrar
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  // Función para obtener la lista de módulos desde Firestore
  Future<List<Modulos>> fetchModule() async {
    QuerySnapshot snapshot = await moduleCollection.get();
    List<Modulos> modulos = snapshot.docs.map((doc) => Modulos.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    modulos.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return modulos;
  }

  // Función para actualizar un módulo existente en Firestore
  Future<void> updateModule(Modulos modulos) async {
    try {
      await moduleCollection.doc(modulos.id.toString()).update(modulos.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el Módulo: $e');
    }
  }

  // Función para eliminar un módulo de Firestore
  Future<void> deleteModule(int modId) async {
    // Eliminar de Firestore
    await moduleCollection.doc(modId.toString()).delete();
  }
}
