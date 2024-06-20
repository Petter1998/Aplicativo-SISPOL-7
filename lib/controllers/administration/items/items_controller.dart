import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/items/items_model.dart';

class ItemController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> _getNextDepId() async {
    final DocumentReference counterRef = _firestore.collection('counters').doc('itemsId');
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

  Future<void> registerItems(Map<String, dynamic> itemData) async {
    // Verifica que todos los campos requeridos no estén vacíos
    for (String key in itemData.keys) {
      if (itemData[key] == null || (itemData[key] is String && itemData[key].isEmpty)) {
        throw Exception('El campo $key no puede estar vacío');
      }
    }

    // Obtener el próximo ID de usuario
    int itemId = await _getNextDepId();

    await _firestore.collection('items').doc(itemId.toString()).set({
      'id': itemId,
      ...itemData,
      'fechaCreacion': FieldValue.serverTimestamp(),
    });
  }
}

class ItemsController {
  final ItemController itemController = ItemController();

  Future<void> registerItems(BuildContext context, Map<String, dynamic> itemData) async {
    try {
      await itemController.registerItems(itemData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registitemwins'); 
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }

  final CollectionReference itemsCollection = FirebaseFirestore.instance.collection('items');

  Future<List<Item>> fetchItems() async {
    QuerySnapshot snapshot = await itemsCollection.get();
    List<Item> items = snapshot.docs.map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    items.sort((a, b) => b.id.compareTo(a.id)); // Ordenar en orden descendente por id
    return items;
  }

  Future<void> updateItem(Item item) async {
    try {
      await itemsCollection.doc(item.id.toString()).update(item.toMap());
    } catch (e) {
      throw Exception('Error al actualizar el item: $e');
    }
  }

  Future<void> deleteItem(int itemId) async {
    // Eliminar de Firestore
    await itemsCollection.doc(itemId.toString()).delete();
  }

  Future<List<Item>> searchItems(String query) async {
    QuerySnapshot snapshot = await itemsCollection.where('nombre', isEqualTo: query).get();
    List<Item> items = snapshot.docs.map((doc) => Item.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
    return items;
  }
}