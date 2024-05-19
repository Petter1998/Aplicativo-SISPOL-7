import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/custom_appbar.dart';
import 'package:sispol_7/widgets/floating_action_button.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:sispol_7/widgets/success_icon_animation.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
     // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 34 : 28);

     // Establecer el padding basado en el ancho de la pantalla
    double customPadding = screenWidth > 1000 ? 250 : 20;

    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: const MyFAB(),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SuccessIconAnimation(), // Aquí se muestra el ícono animado
            const SizedBox(height: 100),
            Padding (
              padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20), // Ajusta el padding para controlar el ancho
              child: Text(
                'Tu contraseña ha sido cambiada. Puedes usar la nueva contraseña para iniciar sesión desde ahora. \n ¡GRACIAS!',
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
