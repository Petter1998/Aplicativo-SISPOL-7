import 'package:flutter/material.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:sispol_7/widgets/global/custom_appbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/global/floating_action_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = getFontSize(screenWidth, screenHeight, 16, 24, 34);
    double bodyFontSize = getFontSize(screenWidth, screenHeight, 12, 16, 22);
    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = getSpacing(screenWidth, screenHeight, 8, 25, 30);

    return Scaffold(
      //title: 'SISPOL - 7',
      appBar: const CustomAppBar(),
      floatingActionButton: const MyFAB(),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
             Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView( // Envuelve el Column en un SingleChildScrollView
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Misión',
                        style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                      Text(
                        'Atender la seguridad ciudadana y el orden público, y proteger el libre ejercicio de los derechos y la seguridad de las personas dentro del territorio nacional.',
                        style: GoogleFonts.inter(fontSize: bodyFontSize), textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                      Text(
                        'Visión',
                        style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                      Text(
                        'Al 2025 seremos la institución más confiable y tecnificada de la región; efectiva, íntegra y transparente del sector público, comprometidos al servicio de la sociedad, garantizando la seguridad ciudadana y orden público.',
                        style: GoogleFonts.inter(fontSize: bodyFontSize), textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                      Text(
                        'Objetivos Estratégicos',
                        style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                      Text(
                        '•Incrementar la eficiencia institucional. \n•Fortalecer la gestión por procesos en la institución.\n•Generar planes, programas y proyectos según la planificación institucional.\n•Desarrollar instrumentos de gestión para los procesos sustantivos institucionales.\n•Implantar las mejores prácticas de estandarización para la gestión institucional.\n•Mejorar la gestión de control, seguimiento y evaluación en la institución.',
                        style: GoogleFonts.inter(fontSize: bodyFontSize), textAlign: TextAlign.justify,
                      ),
                      SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0), // Ajusta el espacio a la derecha 
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0), // Radio del borde redondo
                  child: Image.asset(
                    'assets/images/policias.jpg',
                    fit: BoxFit.cover, // Ajuste de la imagen
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
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

  double getSpacing(double screenWidth, double screenHeight, double smallSpacing, double mediumSpacing, double largeSpacing) {
    if (screenWidth < 600 || screenHeight < 400) {
      return smallSpacing;
    } else if (screenWidth < 1200 || screenHeight < 800) {
      return mediumSpacing;
    } else {
      return largeSpacing;
    }
  }
}
