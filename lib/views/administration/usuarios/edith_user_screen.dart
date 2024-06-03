import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/users/users_controller.dart';
import 'package:sispol_7/models/administration/users/users_model.dart' as MyUserModel;
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';


class EditUserScreen extends StatefulWidget {
  final MyUserModel.User user;
  // ignore: use_super_parameters
  const EditUserScreen({Key? key, required this.user}) : super(key: key);
  

  @override
  // ignore: library_private_types_in_public_api
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _idController;
  late TextEditingController _phoneController;
  late TextEditingController _usernameController;
  late TextEditingController _positionController;
  late TextEditingController _emailController;

   @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _surnameController = TextEditingController(text: widget.user.surname);
    _idController = TextEditingController(text: widget.user.cedula);
    _phoneController = TextEditingController(text: widget.user.telefono);
    _usernameController = TextEditingController(text: widget.user.user);
    _positionController = TextEditingController(text: widget.user.cargo);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _idController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    UserController userController = UserController();
    MyUserModel.User updatedUser = MyUserModel.User(
      uid: widget.user.uid,
      id: widget.user.id,
      name: _nameController.text,
      surname: _surnameController.text,
      cedula: _idController.text,
      telefono: _phoneController.text,
      user: _usernameController.text,
      cargo: _positionController.text,
      fechacrea: widget.user.fechacrea,
      email: _emailController.text,
    );

    await userController.updateUser(updatedUser);

    // Update Firebase Authentication Email
    if (_emailController.text != widget.user.email) {
      await userController.updateUserEmail(widget.user.uid, _emailController.text);
    }

    // Redirige a la pantalla UserView después de guardar los cambios
    // ignore: use_build_context_synchronously
    //Navigator.pushReplacementNamed(context, '/listuser');
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

                    TextField(controller: _idController, decoration: const InputDecoration(hintText: 'Identificación',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _phoneController, decoration: const InputDecoration(hintText: 'Teléfono celular',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _usernameController, decoration: const InputDecoration(hintText: 'Usuario',
                        fillColor: Colors.black, border: OutlineInputBorder(),),
                        style: GoogleFonts.inter(fontSize: bodyFontSize),),
                    SizedBox(height: verticalSpacing),

                    TextField(controller: _positionController, decoration: const InputDecoration(hintText: 'Cargo',
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
                    onPressed: () {
                      _saveChanges;
                      Navigator.pushReplacementNamed(context, '/listuser');
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