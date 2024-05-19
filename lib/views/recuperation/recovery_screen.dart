import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/recuperation/recovery.controller.dart';
import 'package:sispol_7/widgets/custom_appbar.dart';
import 'package:sispol_7/widgets/footer.dart';

class RecoveryScreen extends StatelessWidget {
  final TextEditingController cedulaController = TextEditingController();

  RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);

    double iconSize = screenWidth > 480 ? 34.0 : 24.0;

    double customPadding = screenWidth > 1000 ? 300 : 20;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ingrese su cédula de identidad, sin espacios ni caracteres:',
              style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: cedulaController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Identificación',
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
              child:Text('Siguiente', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)), 
              onPressed: () {
                RecoveryController controller = RecoveryController();
                controller.verifyCedulaAndNavigate(context, cedulaController.text);
              },
        
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
