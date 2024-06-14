import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:sispol_7/widgets/success_icon_animation.dart';

// ignore: must_be_immutable
class RegistrationWinsScreen extends StatelessWidget {
  RegistrationWinsScreen({super.key, required this.nombreCompleto});
  final String nombreCompleto;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
   

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
     // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 34 : 28);
     // Establecer el padding basado en el ancho de la pantalla
    double customPadding = screenWidth > 1000 ? 250 : 20;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SuccessIconAnimation(), // Aquí se muestra el ícono animado
            const SizedBox(height: 100),
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
                    const TextSpan(text: ' su solicitud de Mantenimiento para su vehículo ha sido registrada con éxito. \n \n \n Genere su solicitud de forma obligatoria e imprímalo, para la posterior orden de trabajo. \n !GRACIAS¡'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                    ),
                    onPressed: () {
                      
                    },
                    child: Text('Generar PDF', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
                  ),
                ),
          ],
        ),   
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}