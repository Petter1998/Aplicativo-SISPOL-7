import 'package:cloud_firestore/cloud_firestore.dart';

class RoleUpdater {
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('usuarios');
  final CollectionReference rolesCollection = FirebaseFirestore.instance.collection('roles');

  RoleUpdater() {
    _updateRolesCount();
  }

  void _updateRolesCount() {
    usersCollection.snapshots().listen((snapshot) async {
      // Mapa para llevar el seguimiento de la cantidad de roles
      Map<String, int> roleCounts = {};

      // Contar el número de usuarios para cada rol
      for (var doc in snapshot.docs) {
        try {
          String role = doc['cargo'] ?? 'Desconocido'; // Verifica si el campo 'cargo' existe y no es nulo
          if (roleCounts.containsKey(role)) {
            roleCounts[role] = roleCounts[role]! + 1;
          } else {
            roleCounts[role] = 1;
          }
        } catch (e) {
          // ignore: avoid_print
          print('Error obteniendo el campo cargo: $e, Document: ${doc.id}');
        }
      }

      // Actualizar la colección de roles con los nuevos conteos
      for (var role in roleCounts.keys) {
        try {
          var roleDocs = await rolesCollection.where('rol', isEqualTo: role).get();
          if (roleDocs.docs.isNotEmpty) {
            var roleDocId = roleDocs.docs.first.id;
            await rolesCollection.doc(roleDocId).update({
              'usuariosAsignados': roleCounts[role],
            });
          }
        } catch (e) {
          // Log more information about the error
          // ignore: avoid_print
          print('Error actualizando el rol $role: $e');
        }
      }

      // Para los roles que no tienen usuarios, establecer usuariosAsignados en 0
      try {
        var allRoleDocs = await rolesCollection.get();
        for (var roleDoc in allRoleDocs.docs) {
          if (!roleCounts.containsKey(roleDoc['rol'])) {
            await rolesCollection.doc(roleDoc.id).update({
              'usuariosAsignados': 0,
            });
          }
        }
      } catch (e) {
        // Log más información sobre el error
        // ignore: avoid_print
        print('Error actualizando roles sin usuarios: $e');
      }
    });
  }
}
