import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/access/roles_model.dart';

class RolesController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference rolesCollection = FirebaseFirestore.instance.collection('roles');

  Future<int> _getNextDocId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('roleId');
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

  Future<void> registerRole(BuildContext context, Map<String, dynamic> roleData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in roleData.keys) {
      if (roleData[key] == null || (roleData[key] is String && roleData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de rol
    int roleId = await _getNextDocId();

    await _firestore.collection('roles').doc(roleId.toString()).set({
      'id': roleId,
      ...roleData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });

    try {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  Future<List<Roles>> fetchRoles() async {
    QuerySnapshot snapshot = await rolesCollection.get();
    List<Roles> roles = snapshot.docs
    .map((doc) => Roles.fromMap(doc.data() as Map<String, dynamic>, doc.id))
    .where((role) => role.id != 0) // Filtrar roles con id diferente de 0
    .toList();
    roles.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return roles;
  }

  Future<void> updateRole(Roles roles) async {
    try {
      await rolesCollection.doc(roles.id.toString()).update(roles.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el rol: $e');
    }
  }

  Future<void> deleteRole(int roleId) async {
    // Eliminar de Firestore
    await rolesCollection.doc(roleId.toString()).delete();
  }

  Future<List<String>> fetchRol() async {
    QuerySnapshot snapshot = await rolesCollection.where('estado', isEqualTo: 'Activo').get();
    List<String> roles = snapshot.docs.map((doc) => doc['rol'] as String).toList();
    return roles;
  }

}
