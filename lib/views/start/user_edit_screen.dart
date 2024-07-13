
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/start/user_controller.dart';
import 'package:sispol_7/models/start/user_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class UserEditScreen extends StatefulWidget {
  const UserEditScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _cargoController = TextEditingController();
  final _cedulaController = TextEditingController();
  final _emailController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _telefonoController = TextEditingController();

  Usuario? _usuario;

   @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    LoginController loginController = LoginController();
    Usuario? usuario = await loginController.getCurrentUser();
    setState(() {
      _usuario = usuario;
      if (_usuario != null) {
        _nombreController.text = _usuario!.nombre;
        _apellidoController.text = _usuario!.apellido;
        _cargoController.text = _usuario!.rol;
        _cedulaController.text = _usuario!.cedula;
        _emailController.text = _usuario!.email;
        _usuarioController.text = _usuario!.usuario;
        _telefonoController.text = _usuario!.telefono;
      }
    });
  }

  void _updateUser() async {
    try {
      await FirebaseFirestore.instance.collection('usuarios').doc(_usuario!.uid).update({
        'nombres': _nombreController.text,
        'apellidos': _apellidoController.text,
        'cargo': _cargoController.text,
        'cedula': _cedulaController.text,
        'email': _emailController.text,
        'usuario': _usuarioController.text,
        'telefono': _telefonoController.text,
        'fechaCreacion': Timestamp.now(),
      });
      } catch (e) {
        throw Exception('Error al actualizar la información: $e');
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageSize = screenWidth < 480 ? 100.0 :(screenWidth > 1000 ? 200 : 150);

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
  
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);
    
    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);

    // Determinar el espacio vertical para botones basado en el ancho de la pantalla
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

     double iconSize = screenWidth > 480 ? 34.0 : 24.0;

    // Establecemos el padding basado en el ancho de la pantalla
    double horizontalPadding;
    if (screenWidth < 800) {
      horizontalPadding = screenWidth * 0.05; // 5% del ancho si es menor a 800 px
    } else {
      horizontalPadding = screenWidth * 0.20; // 20% del ancho si es mayor o igual a 800 px
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal:horizontalPadding, vertical: 20), // Ajusta el padding según sea necesario
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90.0), // Radio del borde redondo
                    child: Image.asset(
                      'assets/images/avatarpolicias.jpg',
                      height: imageSize, // Altura de la imagen
                      fit: BoxFit.cover, // Ajuste de la imagen
                    ),
                  ),
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nombres',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _nombreController, decoration: const InputDecoration(hintText: "Nombres", 
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Apellidos',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _apellidoController, decoration: const InputDecoration(hintText: 'Apellidos',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Identificación',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _cedulaController, decoration: const InputDecoration(hintText: 'Identificación',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teléfono celular',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _telefonoController, decoration: const InputDecoration(hintText: 'Teléfono celular',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Usuario',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _usuarioController, decoration: const InputDecoration(hintText: 'Usuario',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rol',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _cargoController, enabled: false, // Esto hace que el TextField no sea modificable
                        decoration: const InputDecoration(hintText: 'Rol',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Correo electrónico',
                        style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: verticalSpacing / 2),
                      TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'Correo electrónico',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),

                  SizedBox(height: verticalSpacing),

                  SizedBox(height: vertiSpacing),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 56, 171, 171),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                      onPressed: () async {
                        _updateUser();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Guardar cambios',
                        style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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