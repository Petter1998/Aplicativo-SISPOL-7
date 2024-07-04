import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/administration/floating_person_button.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:sispol_7/widgets/global/success_icon_animation.dart';

// ignore: must_be_immutable
class RegistrationPersonWins extends StatelessWidget {
  RegistrationPersonWins({super.key});

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
                '¡Felicidades! Este registro ha sido guardado en SISPOL-7. \n !GRACIAS¡',
                style: 
                GoogleFonts.inter(fontSize: titleFontSize),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),   
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}