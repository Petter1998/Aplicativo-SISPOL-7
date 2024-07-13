import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';

class PersonSubController {
  final List<int> _selectedIds = [];

  // Alterna la selección de un ID
  void toggleSelection(int id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
  }

  // Limpia todas las selecciones
  void clearSelection() {
    _selectedIds.clear();
  }

  // Obtiene los IDs seleccionados
  List<int> get selectedIds => _selectedIds;

  // Obtiene una lista de dependencias desde Firestore
  Future<List<Dependecy>> fetchDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dependencias').get();
    return snapshot.docs.map((doc) => Dependecy.fromMap(doc.data() as Map<String, dynamic>,doc.id)).toList();
  }

  // Asigna personal a un subcircuito especificado
  Future<void> assignToSubcircuito(BuildContext context, List<Personal> personals, String subcircuitoName) async {
    // Obteniendo los datos del subcircuito seleccionado
    DocumentSnapshot subcircuitoDoc = await FirebaseFirestore.instance
        .collection('dependencias')
        .where('nombreSubcircuito', isEqualTo: subcircuitoName)
        .get()
        .then((snapshot) => snapshot.docs.first);

    String subcircuitoDistrito = subcircuitoDoc['nombreDistrito']; // Distrito del subcircuito

    // Verifica si todos los seleccionados pertenecen al mismo distrito
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
      'nombreSubcircuito': subcircuitoDoc['nombreSubcircuito'],
    };

    // Obtiene la fecha y hora actual
    DateTime now = DateTime.now();
    Timestamp fechaAsignacion = Timestamp.fromDate(now); 

    // Guardando el personal con los datos del subcircuito en la colección 'personal_subcircuito'
    final subcircuitoCollection = FirebaseFirestore.instance.collection('personal_subcircuito');
    for (var personal in personals) {
      await subcircuitoCollection.doc(subcircuitoName).collection(subcircuitoName).add({
        ...personal.toMap(),
        'subcircuito': subcircuitoData,
        'fechaAsignacion': fechaAsignacion, // Agrega el campo fechaAsignacion
      });
    }
  }

  // Verifica si algún personal ya está asignado a un subcircuito diferente al seleccionado
  Future<bool> isAnyPersonalAlreadyAssigned(List<Personal> personals, String selectedSubcircuito) async {
    final subcircuitoCollection = FirebaseFirestore.instance.collection('personal_subcircuito');

    for (var personal in personals) {
      QuerySnapshot snapshot = await subcircuitoCollection
          .where('id', isEqualTo: personal.id)
          .limit(personals.length) 
          .get();

      for (var doc in snapshot.docs) {
        // Verifica si el personal está asignado a un subcircuito diferente al actual
        if (doc.reference.parent.parent!.id != selectedSubcircuito) {
          return true; // El personal ya está asignado a otro subcircuito
        }
      }
    }

    return false; // Ninguno de los personales está asignado
  }

  // Obtiene el personal asignado a un subcircuito específico junto con su dependencia
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

      // Obtiene los datos del subcircuito directamente del documento del personal
      Map<String, dynamic> subcircuitoData = data['subcircuito'] ?? {}; // Si no existe 'subcircuito', usa un mapa vacío

      // Asegura de incluir 'fechaAsignacion' si existe en data
      if (data.containsKey('fechaAsignacion')) {
        subcircuitoData['fechaAsignacion'] = data['fechaAsignacion'];
      }

      // Busca la dependencia correspondiente al personal 
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

  // Obtiene una lista de dependencias únicas del personal
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

  // Busca personal en Firestore según la dependencia
  Future<List<Personal>> searchPersonal(String dependencia) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('personal')
        .where('dependencia', isEqualTo: dependencia)
        .get();

    return snapshot.docs.map((doc) => Personal.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  // Reasigna el personal seleccionado a un nuevo subcircuito
  Future<void> reassignSelected(
    BuildContext context,
    List<Map<String, dynamic>> personalData,
    String newSubcircuitoName,
    String currentSubcircuitoName
  ) async {
    // Obteniendo los datos del nuevo subcircuito seleccionado
    DocumentSnapshot newSubcircuitoDoc = await FirebaseFirestore.instance
        .collection('dependencias')
        .where('nombreSubcircuito', isEqualTo: newSubcircuitoName)
        .get()
        .then((snapshot) => snapshot.docs.first);

    String newSubcircuitoDistrito = newSubcircuitoDoc['nombreDistrito'];

    // Filtra el personalData para obtener solo los seleccionados
    List<Map<String, dynamic>> selectedPersonalData = personalData.where((item) => _selectedIds.contains(item['personal'].id)).toList();

    if (selectedPersonalData.isEmpty) {
      throw Exception('No se ha seleccionado ningún personal para reasignar.');
    }

    // Verifica si todos los seleccionados pertenecen al mismo distrito
    for (var item in selectedPersonalData) {
      final personal = item['personal'] as Personal;
      if (personal.dependencia != newSubcircuitoDistrito) {
        throw Exception('Uno o más registros no pueden ser reasignados porque pertenecen a un distrito diferente.');
      }
    }

    // Actualiza los datos en Firestore dentro de una transacción
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      for (var item in selectedPersonalData) {
        final personal = item['personal'] as Personal;

        // Busca el documento del personal en la colección del subcircuito actual
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('personal_subcircuito')
            .doc(currentSubcircuitoName)
            .collection(currentSubcircuitoName)
            .where('id', isEqualTo: personal.id) // Filtra por el ID del personal
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Elimina el documento del subcircuito actual
          transaction.delete(querySnapshot.docs.first.reference);

          // Crea los datos del nuevo subcircuito
          Map<String, dynamic> newSubcircuitoData = {
            'nombreCircuito': newSubcircuitoDoc['nombreCircuito'],
            'distrito': newSubcircuitoDoc['nombreDistrito'],
            'parroquia': newSubcircuitoDoc['parroquia'],
            'provincia': newSubcircuitoDoc['provincia'],
            'nombreSubcircuito': newSubcircuitoDoc['nombreSubcircuito'],
          };

          // Agrega el registro al nuevo subcircuito
          transaction.set(FirebaseFirestore.instance
              .collection('personal_subcircuito')
              .doc(newSubcircuitoName)
              .collection(newSubcircuitoName)
              .doc(),
            {
              ...personal.toMap(),
              'subcircuito': newSubcircuitoData,
            });
        } else {
          throw Exception('No se encontró el registro del personal con ID ${personal.id}');
        }
      }
    });
  }

  // Elimina el personal seleccionado del subcircuito actual
  Future<void> deleteSelected(String currentSubcircuitoName) async {
    if (_selectedIds.isEmpty) {
      throw Exception('No se ha seleccionado ningún personal para eliminar.');
    }

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        for (int id in _selectedIds) {
          // ignore: avoid_print
          print('Intentando eliminar ID: $id'); 

          // Busca el documento del personal en la subcolección
          QuerySnapshot querySnapshot = await FirebaseFirestore.instance
              .collection('personal_subcircuito')
              .doc(currentSubcircuitoName)
              .collection(currentSubcircuitoName)
              .where('id', isEqualTo: id)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            DocumentSnapshot personalDoc = querySnapshot.docs.first;
            // ignore: avoid_print
            print('Eliminando documento con ID: ${personalDoc.id}'); // Imprime el ID del documento a eliminar
            transaction.delete(personalDoc.reference);
          } else {
            // ignore: avoid_print
            print('No se encontró el documento con ID: $id'); // Imprime un mensaje si no se encuentra el documento
          }
        }
      }).then((_) {
        // ignore: avoid_print
        print('Transacción completada con éxito');
      }).catchError((error) {
        // ignore: avoid_print
        print('Error en la transacción: $error');
      });

      _selectedIds.clear();
    } catch (e) {
      // ignore: avoid_print
      print('Error general al eliminar: $e'); // Captura cualquier otro error
      throw Exception('Error al eliminar registros.'); 
    }
  }
}
