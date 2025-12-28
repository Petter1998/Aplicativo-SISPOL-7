import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Footer extends StatelessWidget {
  final double screenWidth;

  const Footer({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double titleFontSize = getFontSize(screenWidth, screenHeight, 10, 15, 22);
    double heightall = getHeight(screenWidth, screenHeight, 70, 85, 100);

    return BottomAppBar(
      height: heightall, // altura de la pantalla a 480px
      color: const Color.fromRGBO(15, 57, 155, 1), // Color del fondo del BottomAppBar
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'Policía Nacional del Ecuador',
              style: GoogleFonts.inter(
                color: Colors.white, 
                fontSize: titleFontSize, 
                ), // Estilo del texto
          ),
          const SizedBox(
            height: 3,
          ),
          Text(
            '© 2025 www.policia.gob.ec | Design by: Arévalo Samaniego Pedro Andrés',
              style: GoogleFonts.inter(
                color: Colors.white, 
                fontSize: titleFontSize, 
                ), // Estilo del texto
              ),
          ],
      ),
  );
      
  }
  
  double getFontSize(double screenWidth, double screenHeight, double smallSize, double mediumSize, double largeSize) {
    if (screenWidth < 600 || screenHeight < 400) {
      return smallSize;
    } else if (screenWidth < 1200 || screenHeight < 800) {
      return mediumSize;
    } else {
      return largeSize;
    }
  }

  double getHeight(double screenWidth, double screenHeight, double smallSpacing, double mediumSpacing, double largeSpacing) {
    if (screenWidth < 600 || screenHeight < 400) {
      return smallSpacing;
    } else if (screenWidth < 1200 || screenHeight < 800) {
      return mediumSpacing;
    } else {
      return largeSpacing;
    }
  } 
}


