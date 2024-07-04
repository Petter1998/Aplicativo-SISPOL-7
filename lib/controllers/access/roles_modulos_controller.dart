import 'package:cloud_firestore/cloud_firestore.dart';

class ModulesController {
  final CollectionReference moduleCollection = FirebaseFirestore.instance.collection('modulos');

  Future<List<String>> fetchModuleNames() async {
    QuerySnapshot snapshot = await moduleCollection.get();
    List<String> moduleNames = snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    return moduleNames;
  }

 Future<List<String>> fetchSubModules(String moduleName) async {
    QuerySnapshot snapshot = await moduleCollection.where('nombre', isEqualTo: moduleName).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      String subModulesStr = snapshot.docs.first['subModulos'] ?? '';
      List<String> subModules = subModulesStr.split(',').map((e) => e.trim()).toList();
      return subModules;
    } else {
      return [];
    }
  }
}

