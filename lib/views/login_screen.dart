import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/login_controller.dart';
import 'package:sispol_7/views/recuperation/recovery_screen.dart';
import 'package:sispol_7/views/registration_screen.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:sispol_7/widgets/custom_appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
    @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  
  
  // ignore: unused_element
  void _handleLogin() {
    _controller.login(_emailController.text, _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double screenHeight = MediaQuery.of(context).size.height;

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = getFontSize(screenWidth, screenHeight, 16, 24, 34);
    double bodyFontSize = getFontSize(screenWidth, screenHeight, 12, 16, 22);
    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = getSpacing(screenWidth, screenHeight, 8, 25, 30);

    // Establecemos el padding basado en el ancho de la pantalla
    double horizontalPadding;
    if (screenWidth < 800) {
      horizontalPadding = screenWidth * 0.05; // 5% del ancho si es menor a 800 px
    } else {
      horizontalPadding = screenWidth * 0.20; // 20% del ancho si es mayor o igual a 800 px
    }
    double imageSize = screenWidth < 480 ? 100.0 :(screenWidth > 1000 ? 200 : 150);

    // Determinar el espacio vertical para botones basado en el ancho de la pantalla
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

    double iconSize = screenWidth > 480 ? 34.0 : 24.0;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding , vertical: 20), // Ajusta el padding para controlar el ancho
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20), 
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Color del borde
                      width: 1, // Grosor del borde
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Redondeo del borde
                    
                  ), // Agrega padding dentro del contenedor
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(90.0), // Radio del borde redondo
                      child: Image.asset(
                        'assets/images/avatarpolicias.jpg',
                        height: imageSize, // Altura de la imagen
                        fit: BoxFit.cover, // Ajuste de la imagen
                      ),
                    ),
                    SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                    Text('BIENVENIDO',
                      style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),),
                    SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: "Correo electrónico",
                        fillColor: Colors.black,
                        border: OutlineInputBorder(),
                      ),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),
                    ),
                    SizedBox(height: verticalSpacing),
                    TextField(
                      controller: _passwordController, 
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "Contraseña",
                        fillColor: Colors.black,
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
                      style: GoogleFonts.inter(fontSize: bodyFontSize),
                    ),
                    SizedBox(height: vertiSpacing),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                      ),
                      icon: Icon(Icons.login, size: iconSize, color: Colors.black), // Icono con color definido
                      label: Text('ACCEDER', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
                      onPressed: () async {
                        bool loggedIn = await _controller.login(_emailController.text, _passwordController.text);
                        if (loggedIn) {
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacementNamed(context, '/dashboard');
                        } else {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login failed')));
                        }
                      },
                    ),

                    SizedBox(height: vertiSpacing),

                    Text('O', style: GoogleFonts.inter(fontSize: titleFontSize)),

                    SizedBox(height: vertiSpacing),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.white, // Color de fondo
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                      ),
                      icon: Icon(FontAwesomeIcons.google, size: iconSize, color: Colors.black), // Asegúrate de que `iconSize` esté definido
                      label: Text('Acceder con Google', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black)),
                      onPressed: (null), //async {
                        //bool result = await _controller.loginWithGoogle();
                        //if (result) {
                          // ignore: use_build_context_synchronously
                          //Navigator.pushReplacementNamed(context, '/dashboard');
                        //} else {
                          // ignore: use_build_context_synchronously
                          //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login with Google failed')));
                        //}
                      //},
                    ),

                    SizedBox(height: vertiSpacing),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                        
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                      ),
                      icon: Icon(FontAwesomeIcons.question, size: iconSize, color: Colors.black), // Icono con color definido
                      label: Text('¿Olvidó su contraseña?', style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black)),
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RecoveryScreen()),
                        );
                      },
                    ),
                    SizedBox(height: vertiSpacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No tienes una cuenta, aún...", style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                            );
                          },
                          child: Text('Registrate', style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ), 
              ),
            ),
          ),
          //mainAxisAlignment: MainAxisAlignment.center, 
        ),
      //),
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

  double getPadding(double screenWidth, double screenHeight, double smallSpacing, double mediumSpacing, double largeSpacing) {
    if (screenWidth < 600 || screenHeight < 400) {
      return smallSpacing;
    } else if (screenWidth < 1200 || screenHeight < 800) {
      return mediumSpacing;
    } else {
      return largeSpacing;
    }
  } 
}