import 'package:flutter/material.dart';
import 'package:sispol_7/models/user_model.dart';


class UserController {
  final UserModel userModel = UserModel();

  Future<void> registerUser(BuildContext context, Map<String, dynamic> userData) async {
    try {
      await userModel.registerUser(userData);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/registwin'); // Asegúrate de tener esta ruta definida para la pantalla de éxito.
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al registrar: $e')));
    }
  }
}

