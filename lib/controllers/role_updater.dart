import 'package:cloud_firestore/cloud_firestore.dart';

class RoleUpdater {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference rolesCollection = FirebaseFirestore.instance.collection('roles');

  RoleUpdater() {
    _updateRolesCount();
  }

  void _updateRolesCount() {
    usersCollection.snapshots().listen((snapshot) async {
      // Map to keep track of role counts
      Map<String, int> roleCounts = {};

      // Count the number of users for each role
      for (var doc in snapshot.docs) {
        String role = doc['cargo'];
        if (roleCounts.containsKey(role)) {
          roleCounts[role] = roleCounts[role]! + 1;
        } else {
          roleCounts[role] = 1;
        }
      }

      // Update the roles collection with the new counts
      for (var role in roleCounts.keys) {
        var roleDocs = await rolesCollection.where('rol', isEqualTo: role).get();
        if (roleDocs.docs.isNotEmpty) {
          var roleDocId = roleDocs.docs.first.id;
          await rolesCollection.doc(roleDocId).update({
            'usuariosAsignados': roleCounts[role],
          });
        }
      }

      // For roles that have no users, set usuariosAsignados to 0
      var allRoleDocs = await rolesCollection.get();
      for (var roleDoc in allRoleDocs.docs) {
        if (!roleCounts.containsKey(roleDoc['rol'])) {
          await rolesCollection.doc(roleDoc.id).update({
            'usuariosAsignados': 0,
          });
        }
      }
    });
  }
}
