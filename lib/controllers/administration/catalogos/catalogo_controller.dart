import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/catalogos/catalogo_model.dart';

class CatalogoController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene el siguiente ID de catálogo.
  /// Si el documento de contador no existe, lo crea e inicia el contador en 1.
  /// De lo contrario, incrementa el contador y devuelve el nuevo valor.
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

  /// Registra un nuevo catálogo en la colección de Firestore.
  /// Verifica que todos los campos requeridos no estén vacíos antes de registrarlos.
  Future<void> registerCatalogo(Map<String, dynamic> catData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in catData.keys) {
      if (catData[key] == null || (catData[key] is String && catData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int catId = await _getNextDepId();

    // Guarda el catálogo en Firestore.
    await _firestore.collection('catalogos').doc(catId.toString()).set({
      'id': catId,
      ...catData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class CatalogosController {
  final CatalogoController catalogoController = CatalogoController();

   /// Registra un nuevo catálogo y navega a la pantalla de éxito.
  /// Muestra un mensaje de error en caso de fallo.
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

  /// Obtiene una lista de todos los catálogos de Firestore.
  /// Ordena los catálogos en orden descendente por ID antes de devolverlos.
  Future<List<Catalogo>> fetchCatalogo() async {
    QuerySnapshot snapshot = await catCollection.get();
    List<Catalogo> catalogos = snapshot.docs.map((doc) => Catalogo.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    catalogos.sort((a, b) => b.id.compareTo(a.id)); // Ordena en orden descendente por id
    return catalogos;
  }

  /// Actualiza un catálogo existente en Firestore.
  /// Lanza una excepción en caso de fallo.
  Future<void> updateCatalogo(Catalogo catalogo) async {
    try {
      await catCollection.doc(catalogo.id.toString()).update(catalogo.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el Catálogo: $e');
    }
  }

  /// Elimina un catálogo de Firestore por ID.
  Future<void> deleteCatalogo(int catId) async {
    // Elimina de Firestore
    await catCollection.doc(catId.toString()).delete();
  }

  /// Busca catálogos en Firestore por nombre.
  /// Devuelve una lista de catálogos que coinciden con la consulta.
  Future<List<Catalogo>> searchContrato(String query) async {
    QuerySnapshot snapshot = await catCollection.where('nombreCatalogo', isEqualTo: query).get();
    List<Catalogo> catalogos = snapshot.docs.map((doc) => Catalogo.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return catalogos;
  }
}