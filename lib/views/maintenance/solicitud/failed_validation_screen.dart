import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class FailedValidationScreen extends StatelessWidget {
  FailedValidationScreen({super.key, required this.nombreCompleto});
  final String nombreCompleto;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
   

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
     // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 34 : 28);

     // Establecer el padding basado en el ancho de la pantalla
    double customPadding = screenWidth > 1000 ? 250 : 20;

    double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding (
              padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20), // Ajusta el padding para controlar el ancho
              child: RichText( // Usa RichText para combinar estilos
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: titleFontSize),
                  children: <TextSpan>[
                    const TextSpan(text: 'Estimado '),
                    TextSpan(
                      text: nombreCompleto,
                      style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ', dado a que no existen datos asociados, deberá solicitar el registro \n al responsable de logística para que se ingrese la dependencia a la que pertenece \n y el vehículo del cual es responsable. \n Si no está seguro puede repetir ingresando nuevamente sus dos nombres o su identificación. \n !GRACIAS¡'),
                  ],
                ),
              ),
            ),
          ],
        ),   
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
        child: Icon(Icons.arrow_back, size: iconSize, color:  Colors.black),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}