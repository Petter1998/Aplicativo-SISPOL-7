
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> assignToSubcircuito(List<Personal> personals, String subcircuitoName) async {
    final subcircuitoDoc = FirebaseFirestore.instance.collection('personal_subcircuito').doc(subcircuitoName);

    for (var personal in personals) {
      await subcircuitoDoc.collection(subcircuitoName).add(personal.toMap());
    }
  }

  Future<List<Personal>> getAssignedPersonal(String subcircuitoName) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('personal_subcircuito')
      .doc(subcircuitoName)
      .collection(subcircuitoName)
      .get();
  return snapshot.docs.map((doc) => Personal.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
}

}
