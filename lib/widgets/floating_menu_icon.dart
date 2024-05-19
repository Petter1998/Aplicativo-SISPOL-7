import 'package:flutter/material.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';


class FloatingMenuIcon extends StatefulWidget {
  const FloatingMenuIcon({super.key});

  @override
  
  // ignore: library_private_types_in_public_api
  _FloatingMenuIconState createState() => _FloatingMenuIconState();
}

class _FloatingMenuIconState extends State<FloatingMenuIcon> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    double iconSize = screenWidth > 480 ? 34.0 : 20.0;

    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();  // Abre el drawer
        },
        // ignore: sort_child_properties_last
        child: Icon(Icons.menu, size: iconSize,color:  Colors.black),  // Icono de menú en el botón flotante
        backgroundColor: const Color.fromARGB(255, 56, 171, 171),  // Color de fondo del botón
      ),
      drawer: const ComplexDrawer(),  // Drawer que quieres controlar
    );
  }
}
