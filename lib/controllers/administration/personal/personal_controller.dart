import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';

class PersonalModel {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextPersonId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('personalId');
    return _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterRef);
      if (!snapshot.exists) {
        transaction.set(counterRef, {'currentId': 1});
        return 1;
      }

      int newId = snapshot['currentId'] + 1;
      transaction.update(counterRef, {'currentId': newId});
      return newId;
    });
  }

  Future<void> registerPerson(Map<String, dynamic> persData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in persData.keys) {
      if (persData[key] == null || (persData[key] is String && persData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int persId = await _getNextPersonId();

    await _firestore.collection('personal').doc(persId.toString()).set({
      'id': persId,
      ...persData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class PersonalController {
  final PersonalModel personalModel = PersonalModel();
  final CollectionReference personalsCollection = FirebaseFirestore.instance.collection('personal');

  Future<void> registerPerson(BuildContext context, Map<String, dynamic> persData) async {
    try {
      await personalModel.registerPerson(persData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registpersonwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<void> registerrPerson(BuildContext context, Map<String, dynamic> persData) async {
    try {
      await personalModel.registerPerson(persData); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<List<Personal>> fetchPersonals() async {
    QuerySnapshot snapshot = await personalsCollection.get();
    List<Personal> personals = snapshot.docs.map((doc) => Personal.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    personals.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return personals;
  }

  Future<void> updatePersonal(Personal personal) async {
    try {
      await personalsCollection.doc(personal.id.toString()).update(personal.toMap());
    } catch (e) {
      // Mostrar un mensaje de error
     throw Exception('Error al actualizar el personal: $e');
    }
  }

  Future<void> deletePersonal(int persId) async {
    // Eliminar de Firestore
    await personalsCollection.doc(persId.toString()).delete();
  }

  Future<List<Personal>> searchPersonal(String query) async {
    QuerySnapshot snapshot = await personalsCollection.where('nombres', isEqualTo: query).get();
    List<Personal> personals = snapshot.docs.map((doc) => Personal.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return personals;
  }
}
