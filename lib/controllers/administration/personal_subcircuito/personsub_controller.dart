import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';

class PersonSubController {
  final List<int> _selectedIds = [];

  void toggleSelection(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  List<int> get selectedIds => _selectedIds;

  Future<List<Dependecy>> fetchDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dependencias').get();
    return snapshot.docs.map((doc) => Dependecy.fromMap(doc.data() as Map<String, dynamic>,doc.id)).toList();
  }

  Future<void> assignToSubcircuito(BuildContext context, List<Personal> personals, String subcircuitoName) async {
    // Obteniendo los datos del subcircuito seleccionado
    DocumentSnapshot subcircuitoDoc = await FirebaseFirestore.instance
        .collection('dependencias')
        .where('nombreSubcircuito', isEqualTo: subcircuitoName)
        .get()
        .then((snapshot) => snapshot.docs.first);

    String subcircuitoDistrito = subcircuitoDoc['nombreDistrito']; // Distrito del subcircuito

    // Verificar si todos los seleccionados pertenecen al mismo distrito
    for (var personal in personals) {
      if (personal.dependencia != subcircuitoDistrito) { // Verificar coincidencia de distrito
        // Lanzar una excepción si no coinciden
        throw Exception('Uno o más registros no pueden ser asignados porque pertenecen a un distrito diferente.');
      }
    }

    Map<String, dynamic> subcircuitoData = {
      'nombreCircuito': subcircuitoDoc['nombreCircuito'],
      'distrito': subcircuitoDoc['nombreDistrito'],
      'parroquia': subcircuitoDoc['parroquia'],
      'provincia': subcircuitoDoc['provincia'],
    };

    // Guardando el personal con los datos del subcircuito en la colección 'personal_subcircuito'
    final subcircuitoCollection = FirebaseFirestore.instance.collection('personal_subcircuito');
    for (var personal in personals) {
      await subcircuitoCollection.doc(subcircuitoName).collection(subcircuitoName).add({
        ...personal.toMap(),
        'subcircuito': subcircuitoData,
      });
    }
  }

  Future<List<Map<String, dynamic>>> getAssignedPersonalWithDependency(String subcircuitoName) async {
    QuerySnapshot personalSnapshot = await FirebaseFirestore.instance
        .collection('personal_subcircuito')
        .doc(subcircuitoName)
        .collection(subcircuitoName)
        .get();

    List<Map<String, dynamic>> combinedList = [];

    for (var doc in personalSnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      Personal personal = Personal.fromMap(data, doc.id);

      // Obtener los datos del subcircuito directamente del documento del personal
      Map<String, dynamic> subcircuitoData = data['subcircuito'] ?? {}; // Si no existe 'subcircuito', usar un mapa vacío

      // Buscar la dependencia correspondiente al personal (como antes)
      var dependecy = (await fetchDependencias()).firstWhere(
            // ignore: unrelated_type_equality_checks
            (dep) => dep.id == personal.dependencia,
            orElse: () => Dependecy(
              id: 0,
              provincia: '',
              nDistr: 0,
              parroquia: '',
              codDistr: '',
              nameDistr: '',
              nCircuit: 0,
              codCircuit: '',
              nameCircuit: '',
              nsCircuit: 0,
              codsCircuit: '',
              namesCircuit: '',
              fechacrea: null,
            ),
          );

      combinedList.add({
        'personal': personal,
        'dependencias': dependecy,
        'subcircuito': subcircuitoData,
      });
    }

    return combinedList;
  }

  Future<List<String>> getUniqueDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('personal').get();

    Set<String> uniqueDependencias = {};
    for (var doc in snapshot.docs) {
      String dependencia = doc['dependencia'];
      // ignore: unnecessary_null_comparison
      if (dependencia != null && dependencia.isNotEmpty) {
        uniqueDependencias.add(dependencia);
      }
    }
    return uniqueDependencias.toList();
  }

  Future<List<Personal>> searchPersonal(String dependencia) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('personal')
        .where('dependencia', isEqualTo: dependencia)
        .get();

    return snapshot.docs.map((doc) => Personal.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  
}
