import 'package:cloud_firestore/cloud_firestore.dart';

class ModulesController {
  final CollectionReference moduleCollection = FirebaseFirestore.instance.collection('modulos');

  Future<List<String>> fetchModuleNames() async {
    QuerySnapshot snapshot = await moduleCollection.get();
    List<String> moduleNames = snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    return moduleNames;
  }
}

