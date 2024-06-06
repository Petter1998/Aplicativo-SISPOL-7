import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';

class DependecysController {
  final DependecysModel dependecysModel = DependecysModel();

  Future<void> registerDependecys(BuildContext context, Map<String, dynamic> depData) async {
    try {
      await dependecysModel.registerDependecys(depData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registdepwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }
}

class DependecyController {
  final CollectionReference dependecysCollection = FirebaseFirestore.instance.collection('dependencias');

  Future<List<Dependecy>> fetchDependecys() async {
    QuerySnapshot snapshot = await dependecysCollection.get();
    List<Dependecy> dependecys = snapshot.docs.map((doc) => Dependecy.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    dependecys.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return dependecys;
  }

 // Future<void> addDependecy(Dependecy dependecy) async {
   // await dependecysCollection.doc(dependecy.id.toString()).set(dependecy.toMap());
  //}

  Future<void> updateDependecy(Dependecy dependecy) async {
    try {
      await dependecysCollection.doc(dependecy.id.toString()).update(dependecy.toMap());
    } catch (e) {
      throw Exception('Error al actualizar la dependencia: $e');
    }
  }

  Future<void> deleteDependecy(int depId) async {
    // Eliminar de Firestore
    await dependecysCollection.doc(depId.toString()).delete();
  }

  Future<List<Dependecy>> searchDependencies(String query) async {
    QuerySnapshot snapshot = await dependecysCollection.where('nombreSubcircuito', isEqualTo: query).get();
    List<Dependecy> dependecys = snapshot.docs.map((doc) => Dependecy.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return dependecys;
  }
}