import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/maintenance/validation_controller.dart';
import 'package:sispol_7/views/maintenance/solicitud/failed_validation_screen.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class ValidationScreen extends StatelessWidget {
  final ValidationController controller = ValidationController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ValidationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);

    double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    double customPadding = screenWidth > 1000 ? 300 : 20;

    return Scaffold(
    key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ingrese su cédula de identidad o sus dos nombres:',
              style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.identiController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Identificación o Nombres',
                border: const OutlineInputBorder(),
                icon: Icon(FontAwesomeIcons.addressCard, size: iconSize, color: Colors.black),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
              ),
              child:Text('Validar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)), 
              onPressed: () async {
                String? nombreCompleto = await controller.validatePerson(context);
                if (nombreCompleto != null) {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => FailedValidationScreen(nombreCompleto: nombreCompleto),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }

}
