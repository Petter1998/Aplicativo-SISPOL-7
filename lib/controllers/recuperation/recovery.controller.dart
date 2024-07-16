import 'package:flutter/material.dart';
import 'package:sispol_7/models/recuperation/auth.model.dart';
import 'package:sispol_7/views/recuperation/changue_password_screen.dart';

class RecoveryController {
  final AuthModel _authModel = AuthModel();

  // Función para verificar la cédula y navegar a la pantalla de cambio de contraseña
  void verifyCedulaAndNavigate(BuildContext context, String cedula) async {
    var result = await _authModel.verifyCedula(cedula);
    if (result['exists']) {
      // Pasa el nombre de usuario a la pantalla de cambio de contraseña
      // ignore: use_build_context_synchronously
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePasswordScreen(usuario: result['usuario'])));
    } else {
      // Mostrar un error si la cédula no se encuentra
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cédula no encontrada')));
    }
  }

  // Función para cambiar la contraseña y navegar a la página de éxito
  void changePasswordAndNavigate(BuildContext context, String newPassword) async {
    if (newPassword.isEmpty) {
      // Mostrar un mensaje de error si la nueva contraseña está vacía
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha ingresado ninguna contraseña'))
      );
      return;
    }
    bool result = await _authModel.changeUserPassword(newPassword);
    if (result) {
      // Navega a la página de éxito si el cambio de contraseña es exitoso
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/successPage');
    } else {
      // Muestra un mensaje de error si el cambio de contraseña falla
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al cambiar la contraseña')));
    }
  }
}
