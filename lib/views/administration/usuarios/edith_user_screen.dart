import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/users/users_controller.dart';
import 'package:sispol_7/models/administration/users/users_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({super.key, required this.user});

  @override
  // ignore: library_private_types_in_public_api
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _cedulaController;
  late TextEditingController _cargoController;
  late TextEditingController _telefonoController;
  late TextEditingController _userController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _emailController = TextEditingController(text: widget.user.email);
    _cedulaController = TextEditingController(text: widget.user.cedula);
    _cargoController = TextEditingController(text: widget.user.cargo);
    _telefonoController = TextEditingController(text: widget.user.telefono);
    _userController = TextEditingController(text: widget.user.user);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _cedulaController.dispose();
    _cargoController.dispose();
    _telefonoController.dispose();
    _userController.dispose();
    super.dispose();
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
        padding: EdgeInsets.symmetric(horizontal:horizontalPadding , vertical: 20), // Ajusta el padding para controlar el ancho
        child: Center(
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
                    child: Icon(
                      Icons.person, // Icono de usuario
                      size: imageSize, // Tamaño del icono
                      color: Colors.black, // Color del icono
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                    
                    TextField(controller: _nameController, decoration: const InputDecoration(hintText: "Nombres", 
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _surnameController, decoration: const InputDecoration(hintText: 'Apellidos',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _cedulaController, decoration: const InputDecoration(hintText: 'Identificación',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _telefonoController, decoration: const InputDecoration(hintText: 'Teléfono celular',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _userController, decoration: const InputDecoration(hintText: 'Usuario',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _cargoController, decoration: const InputDecoration(hintText: 'Cargo',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _emailController, decoration: const InputDecoration(hintText: 'Correo electrónico',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    
                    SizedBox(height: verticalSpacing),

                    SizedBox(height: vertiSpacing),
                  
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                    ),
                    onPressed: () async {
                      final updatedUser = User(
                        uid: widget.user.uid,
                        id: widget.user.id,
                        name: _nameController.text,
                        surname: _surnameController.text,
                        email: _emailController.text,
                        cedula: _cedulaController.text,
                        cargo: _cargoController.text,
                        fechacrea: DateTime.now(),
                        telefono: _telefonoController.text,
                        user: _userController.text,
                      );
                      await UserController().updateUser(updatedUser);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: Text('Guardar cambios', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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