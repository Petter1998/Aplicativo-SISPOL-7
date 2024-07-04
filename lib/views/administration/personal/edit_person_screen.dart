import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/personal/personal_controller.dart';
import 'package:sispol_7/models/administration/personal/personal_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class EditPersonScreen extends StatefulWidget {
  final Personal personal;
  

  const EditPersonScreen({super.key, required this.personal});

  @override
  // ignore: library_private_types_in_public_api
  _EditPersonScreenState createState() => _EditPersonScreenState();
}

class _EditPersonScreenState extends State<EditPersonScreen> {
  
  late TextEditingController _cedulaController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _fechanaciController;
  late TextEditingController _tipoSangreController;
  late TextEditingController _ciudadNaciController;
  late TextEditingController _telefonoController;
  late TextEditingController _rangoController;
  late TextEditingController _dependenciaController;

  @override
  void initState() {
    super.initState();
    _cedulaController = TextEditingController(text: widget.personal.cedula.toString());
    _nameController = TextEditingController(text: widget.personal.name);
    _surnameController = TextEditingController(text: widget.personal.surname);
    _fechanaciController = TextEditingController(text: widget.personal.fechanaci != null 
    ? DateFormat('dd/MM/yyyy').format(widget.personal.fechanaci!) : '');
    _tipoSangreController = TextEditingController(text: widget.personal.tipoSangre);
    _ciudadNaciController = TextEditingController(text: widget.personal.ciudadNaci);
    _telefonoController = TextEditingController(text: widget.personal.telefono.toString());
    _rangoController = TextEditingController(text: widget.personal.rango);
    _dependenciaController = TextEditingController(text: widget.personal.dependencia);

    _fetchDependencias();
  }

  @override
  void dispose() {
    _cedulaController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _fechanaciController.dispose();
    _tipoSangreController.dispose();
    _ciudadNaciController.dispose();
    _telefonoController.dispose();
    _rangoController.dispose();
    _dependenciaController.dispose();
    super.dispose();
  }

  String? _selectedRango;
  final List<String> rangos = ['Capitán', 'Teniente', 'Subteniente', 'Sargento Primero',
  'Sargento Segundo', 'Cabo Primero', 'Cabo Segundo'];

  String? _selectedDependencia;
  List<String> dependencias = [];

  Future<void> _fetchDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dependencias').get();
    List<String> fetchedDependencias = snapshot.docs.map((doc) => doc['nombreDistrito'] as String).toList();
    setState(() {
      dependencias = fetchedDependencias.toSet().toList(); // Eliminar duplicados
    });
  }


  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

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

     double iconSize = screenWidth > 480 ? 34.0 : 27.0;

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
                    
                  TextField(controller: _cedulaController,
                    decoration: const InputDecoration(
                      labelText: 'Identificación',
                      hintText: 'Identificación',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombres',
                      hintText: 'Nombres',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _surnameController,
                    decoration: const InputDecoration(
                      labelText: 'Apellidos',
                      hintText: 'Apellidos',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

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
           
                  TextField(
                    controller: _telefonoController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      hintText: 'Teléfono',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

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
                      final updatedPersonal = Personal(
                        id: widget.personal.id,
                        cedula: int.parse(_cedulaController.text),
                        name: _nameController.text,
                        surname: _surnameController.text,
                        fechanaci: _fechanaciController.text.isNotEmpty ? DateFormat('dd/MM/yyyy').parse(_fechanaciController.text) : null,
                        tipoSangre: _tipoSangreController.text,
                        ciudadNaci: _ciudadNaciController.text,
                        telefono: int.parse(_telefonoController.text),
                        rango: _rangoController.text,
                        dependencia: _dependenciaController.text,
                        fechacrea: DateTime.now(),
                      );

                      await PersonalController().updatePersonal(updatedPersonal);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Guardar cambios', 
                      style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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



