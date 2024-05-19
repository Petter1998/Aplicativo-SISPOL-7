import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/recuperation/recovery.controller.dart';
import 'package:sispol_7/widgets/custom_appbar.dart';
import 'package:sispol_7/widgets/footer.dart';

class ChangePasswordScreen extends StatefulWidget {
  final String usuario;
  const ChangePasswordScreen({super.key, required this.usuario});

  @override
  // ignore: library_private_types_in_public_api
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);

    double iconSize = screenWidth > 480 ? 34.0 : 24.0;

    double customPadding = screenWidth > 1000 ? 300 : 20;

    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 35 : 30);

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black), // Estilo predeterminado
                children: <TextSpan>[
                  const TextSpan(text: 'Estimado '),
                  TextSpan(text: widget.usuario, style: GoogleFonts.inter(fontWeight: FontWeight.bold)), // Nombre de usuario en negrita
                  const TextSpan(text: ', ingrese su nueva contraseña:'),
                ],
              ),
            ),

            SizedBox(height: verticalSpacing),

            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: 'Nueva contraseña',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Cambia el ícono basado en si el texto está oculto o no
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    // Actualiza el estado para mostrar u ocultar la contraseña
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: verticalSpacing),

            Text(
              'Confirme su nueva contraseña:',
              style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black),
            ),
            SizedBox(height:verticalSpacing),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: InputDecoration(
                labelText: 'Confirmar contraseña',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Cambia el ícono basado en si el texto está oculto o no
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    // Actualiza el estado para mostrar u ocultar la contraseña
                    setState(() {
                      _obscureConfirmPassword = !_obscureConfirmPassword;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: verticalSpacing),

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
                  if (_passwordController.text == _confirmPasswordController.text) {
                    // Llama al método del controlador para cambiar la contraseña
                    RecoveryController().changePasswordAndNavigate(context, _passwordController.text);
                    // Lógica para cambiar la contraseña
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Las contraseñas no coinciden')));
                    // Mostrar error
                  }
                },
                child: Row (
                  mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min for a compact button
                  children: <Widget>[
                    Icon(FontAwesomeIcons.check, size: iconSize, color: Colors.black), // Ajusta según el ícono que desees
                    const SizedBox(width: 8), // Espacio entre el texto y el ícono
                    Text('VALIDAR', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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
