import 'package:flutter/material.dart';
import 'package:sispol_7/controllers/start/splash_screen_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreenWidget extends StatefulWidget {
  final SplashScreenController controller;

  const SplashScreenWidget({super.key, required this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize(context, onComplete: () {
      // Navega a la siguiente pantalla
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    // Determine font size based on screen width and height
    double titleFontSize = getFontSize(screenWidth, screenHeight, 30, 45, 60);

    

    return Scaffold(
      body: Container(
        // Envuelve la imagen y el texto en un Container
        color: const Color.fromRGBO(15, 57, 155, 1), // Aplica el color azul a todo el fondo de la pantalla
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centra la imagen y el texto verticalmente
          children: [
            FractionallySizedBox(
              widthFactor: 0.5, // Ocupa el 50% de la pantalla
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/images/Escudo.jpg',
                  fit: BoxFit.cover, // Ajusta la imagen para cubrir el espacio disponible
                  semanticLabel: 'Escudo de la institución',
                ),
              ),
            ),
            const SizedBox(
              height: 15, // Espacio entre la imagen y el texto
            ),
            FittedBox(
              fit: BoxFit.scaleDown, // Ajusta el tamaño del texto para que quepa en el espacio disponible
              child: Text(
                'SISPOL - 7',
                style: GoogleFonts.inter(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
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
}