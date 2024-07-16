import 'package:cloud_firestore/cloud_firestore.dart';

class ModulesController {
  final CollectionReference moduleCollection = FirebaseFirestore.instance.collection('modulos');

  // Función para obtener la lista de nombres de módulos desde Firestore
  Future<List<String>> fetchModuleNames() async {
    QuerySnapshot snapshot = await moduleCollection.get();
    List<String> moduleNames = snapshot.docs.map((doc) => doc['nombre'] as String).toList();
    return moduleNames;
  }

 // Función para obtener la lista de submódulos de un módulo específico desde Firestore
 Future<List<String>> fetchSubModules(String moduleName) async {
  // Consulta Firestore para obtener el documento del módulo con el nombre especificado
    QuerySnapshot snapshot = await moduleCollection.where('nombre', isEqualTo: moduleName).limit(1).get();
    if (snapshot.docs.isNotEmpty) {
      // Si el documento existe, obtener la cadena de submódulos
      String subModulesStr = snapshot.docs.first['subModulos'] ?? '';
      // Divide la cadena de submódulos en una lista y elimina espacios en blanco
      List<String> subModules = subModulesStr.split(',').map((e) => e.trim()).toList();
      return subModules;
    } else {
      // Si el documento no existe, devolver una lista vacía
      return [];
    }
  }
}

