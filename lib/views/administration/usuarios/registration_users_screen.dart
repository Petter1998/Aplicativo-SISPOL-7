import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/access/rol_controller.dart';
import 'package:sispol_7/controllers/administration/personal/personal_controller.dart';
import 'package:sispol_7/controllers/administration/users/users_controller.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';


class RegistrationUsersScreen extends StatefulWidget {
  const RegistrationUsersScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationUsersScreenState createState() => _RegistrationUsersScreenState();
}

class _RegistrationUsersScreenState extends State<RegistrationUsersScreen> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   final TextEditingController _fechanaciController = TextEditingController();
  final TextEditingController _tipoSangreController = TextEditingController();
  final TextEditingController _ciudadNaciController = TextEditingController();
  final TextEditingController _rangoController = TextEditingController();
  final TextEditingController _dependenciaController = TextEditingController();
  final UsersController _usersController = UsersController();

  String? _selectedRole;
  List<String> _roles = [];

  String? _selectedRango;
  final List<String> rangos = ['Capitán', 'Teniente', 'Subteniente', 'Sargento Primero',
  'Sargento Segundo', 'Cabo Primero', 'Cabo Segundo'];

  String? _selectedDependencia;
  List<String> dependencias = [];

  @override
  void initState() {
    super.initState();
    _fetchRol();
    _fetchDependencias();
  }

  Future<void> _fetchRol() async {
    List<String> rolesList = await RolesController().fetchRol();
    setState(() {
      _roles = rolesList;
    });
  }

  Future<void> _fetchDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dependencias').get();
    List<String> fetchedDependencias = snapshot.docs.map((doc) => doc['nombreDistrito'] as String).toList();
    setState(() {
      dependencias = fetchedDependencias.toSet().toList(); // Eliminar duplicados
    });
  }


  final PersonalController _personalController = PersonalController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');


  bool _obscurePassword = true;

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
                    
                  TextField(controller: _nameController, decoration: const InputDecoration(
                      labelText: 'Nombres',
                      hintText: 'Nombres',
                      fillColor: Colors.black, border: OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
                  SizedBox(height: verticalSpacing),

                  TextField(controller: _surnameController, decoration: const InputDecoration(
                      labelText: 'Apellidos',
                      hintText: 'Apellidos',
                      fillColor: Colors.black, border: OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _fechanaciController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      hintText: 'Fecha de Nacimiento',
                      fillColor: Colors.black,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _fechanaciController.text = _dateFormat.format(pickedDate);
                            });
                          }
                        },
                      ),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _tipoSangreController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Sangre',
                      hintText: 'Tipo de Sangre',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _ciudadNaciController,
                    decoration: const InputDecoration(
                      labelText: 'Ciudad de Nacimiento',
                      hintText: 'Ciudad de Nacimiento',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(controller: _idController, decoration: const InputDecoration(
                      labelText: 'Identificación',
                      hintText: 'Identificación',
                      fillColor: Colors.black, border: OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
                  SizedBox(height: verticalSpacing),

                  TextField(controller: _phoneController, decoration: const InputDecoration(
                      labelText: 'Teléfono celular',
                      hintText: 'Teléfono celular',
                      fillColor: Colors.black, border: OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedRango,
                    hint: Text('Rango o Grado', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Rango o Grado',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRango = newValue;
                        _rangoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                      });
                    },
                    items: rangos.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedDependencia,
                    hint: Text('Dependencia', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Dependencia',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDependencia = newValue;
                        _dependenciaController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                      });
                    },
                    items: dependencias.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(controller: _usernameController, decoration: const InputDecoration(
                      labelText: 'Usuario',
                      hintText: 'Usuario',
                      fillColor: Colors.black, border: OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    hint: Text('Rol', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Rol',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                        _positionController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                      });
                    },
                    items: _roles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),
                  
                  TextField(controller: _emailController, decoration: const InputDecoration(
                      labelText: 'Correo electrónico',
                      hintText: 'Correo electrónico',
                      fillColor: Colors.black, border: OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
                  SizedBox(height: verticalSpacing),

                  TextField(controller: _passwordController, obscureText: _obscurePassword, 
                    decoration: InputDecoration(labelText: 'Contraseña', hintText: 'Contraseña',
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
                      fillColor: Colors.black, border: const OutlineInputBorder(),),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),),
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
                      _registerUsers();
                    },
                    child: Text('Registrar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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

  void _registerUsers() {
    // Recoge los datos del formulario y los pasa al controlador
    Map<String, dynamic> userData = {
      'nombres': _nameController.text,
      'apellidos': _surnameController.text,
      'cedula': _idController.text,
      'telefono': _phoneController.text,
      'usuario': _usernameController.text,
      'cargo': _positionController.text,
      'email': _emailController.text,
      // No pasamos la contraseña al guardar en Firestore
    };

    // Usa el controlador para registrar al usuario
    _usersController.registerUsers(context, {
      ...userData,
      'password': _passwordController.text, // Solo se usa para Firebase Auth
    });

    Map<String, dynamic> depData = {
      'cedula': int.parse(_idController.text),
      'nombres': _nameController.text,
      'apellidos': _surnameController.text,
      'fechaNacimiento': _fechanaciController.text.isNotEmpty ? Timestamp.fromDate(_dateFormat.parse(_fechanaciController.text)) : null,
      'tipoSangre': _tipoSangreController.text,
      'ciudadNacimiento': _ciudadNaciController.text,
      'telefono': int.parse(_phoneController.text),
      'rangoGrado': _rangoController.text,
      'dependencia': _dependenciaController.text,
    };

    // Usa el controlador para registrar la dependencia
    _personalController.registerPerson(context, {
      ...depData,
      'fechaCreacion': FieldValue.serverTimestamp(), // Agrega la fecha de creación
    });
  }
}
