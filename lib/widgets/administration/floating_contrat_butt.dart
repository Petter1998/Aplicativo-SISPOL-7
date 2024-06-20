import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/views/administration/contratos/contratos_view.dart';

class MyUSER1 extends StatelessWidget {
  const MyUSER1({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    double iconSize = screenWidth > 480 ? 34.0 : 20.0;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 12 : (screenWidth < 1200 ? 24 : 28);

    return Container(
      margin: const EdgeInsets.all(10),  // Agrega margen alrededor del botón si es necesario
      child: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  const ContratosView()),
          );
        },
        icon: Icon(Icons.handshake_rounded, size: iconSize,color:  Colors.black),  // Aumenta el tamaño del icono
        label: Text('Ver Contratos', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black, fontSize: titleFontSize)),
        backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        // Personaliza el padding para aumentar el tamaño del botón
        extendedPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }
}