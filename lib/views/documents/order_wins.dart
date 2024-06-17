import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:sispol_7/widgets/success_icon_animation.dart';
import '../../widgets/documents/floating_order_wins.dart';

// ignore: must_be_immutable
class OrderWins extends StatelessWidget {
  OrderWins({super.key});

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
      floatingActionButton: const MyUSER(),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SuccessIconAnimation(), // Aquí se muestra el ícono animado
            const SizedBox(height: 100),
            Padding (
              padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20), // Ajusta el padding para controlar el ancho
              child: Text(
                '¡Felicidades! Esta Orden de trabajo ha sido guardado en SISPOL-7. \n !GRACIAS¡',
                style: 
                GoogleFonts.inter(fontSize: titleFontSize),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
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
                  //_registerVehicle();
                },
                child: Text('Generar Orden de Trabajo', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
              ),
            ),
          ],
        ),   
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}