import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/catalogos/catalogo_model.dart';

class CatalogoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextDepId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('catalogoId');
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

  Future<void> registerCatalogo(Map<String, dynamic> catData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in catData.keys) {
      if (catData[key] == null || (catData[key] is String && catData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int catId = await _getNextDepId();

    await _firestore.collection('catalogos').doc(catId.toString()).set({
      'id': catId,
      ...catData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class CatalogosController {
  final CatalogoController catalogoController = CatalogoController();

  Future<void> registerCatalogo(BuildContext context, Map<String, dynamic> catData) async {
    try {
      await catalogoController.registerCatalogo(catData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registcatpwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference catCollection = FirebaseFirestore.instance.collection('catalogos');

  Future<List<Catalogo>> fetchCatalogo() async {
    QuerySnapshot snapshot = await catCollection.get();
    List<Catalogo> catalogos = snapshot.docs.map((doc) => Catalogo.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    catalogos.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return catalogos;
  }

  Future<void> updateCatalogo(Catalogo catalogo) async {
    try {
      await catCollection.doc(catalogo.id.toString()).update(catalogo.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el Catálogo: $e');
    }
  }

  Future<void> deleteCatalogo(int catId) async {
    // Eliminar de Firestore
    await catCollection.doc(catId.toString()).delete();
  }

  Future<List<Catalogo>> searchContrato(String query) async {
    QuerySnapshot snapshot = await catCollection.where('nombreCatalogo', isEqualTo: query).get();
    List<Catalogo> catalogos = snapshot.docs.map((doc) => Catalogo.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return catalogos;
  }
}