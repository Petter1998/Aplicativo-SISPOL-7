import 'package:flutter/material.dart';

class DrawerController {
  void onItemTapped(BuildContext context, String route) {
    // Lógica para manejar la navegación
    Navigator.of(context).pushNamed(route);
    Navigator.of(context).pop(); // Cierra el drawer
  }
}
