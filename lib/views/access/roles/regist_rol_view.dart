import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/access/rol_controller.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class RegistRoleScreen extends StatefulWidget {
  const RegistRoleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistRoleScreenState createState() => _RegistRoleScreenState();
}

class _RegistRoleScreenState extends State<RegistRoleScreen> {
  final TextEditingController _rolController = TextEditingController();
  final TextEditingController _autorController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _nivelaccesoController = TextEditingController();
  final TextEditingController _usuariosasignadosController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  final RolesController _rolesController = RolesController();

  String? _selectedEstado;
  final List<String> estados = ['Activo', 'Inactivo'];

  String? _selectedAcceso;
  final List<String> accesos = ['Alto', 'Medio', 'Bajo'];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageSize = screenWidth < 480 ? 100.0 : (screenWidth > 1000 ? 200 : 150);

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
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: Icon(
                      Icons.person_add,
                      size: imageSize,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _rolController,
                              decoration: const InputDecoration(
                                labelText: 'Rol',
                                hintText: 'Rol',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _autorController,
                              decoration: const InputDecoration(
                                labelText: 'Autor',
                                hintText: 'Autor',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedEstado,
                              hint: Text('Estado', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Estado',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedEstado = newValue;
                                  _estadoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: estados.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),
                            DropdownButtonFormField<String>(
                              value: _selectedAcceso,
                              hint: Text('Nivel', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Nivel de Acceso',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedAcceso = newValue;
                                  _nivelaccesoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: accesos.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _descripcionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      hintText: 'Descripción',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),
                  SizedBox(height: vertiSpacing),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                      onPressed: () {
                        _registerRole();
                      },
                      child: Text('Registrar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black)),
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
        child: Icon(Icons.arrow_back, size: iconSize, color: Colors.black),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }

  void _registerRole() {
    // Recoge los datos del formulario y los pasa al controlador
    Map<String, dynamic> roleData = {
      'rol': _rolController.text,
      'autor': _autorController.text,
      'descripcion': _descripcionController.text,
      'nivelAcceso': _nivelaccesoController.text,
      'usuariosAsignados': _usuariosasignadosController.text.isNotEmpty ? int.parse(_usuariosasignadosController.text) : 0,
      'estado': _estadoController.text,
    };

    // Usa el controlador para registrar el rol
    _rolesController.registerRole(context, {
      ...roleData,
      'fechaCreacion': FieldValue.serverTimestamp(), // Agrega la fecha de creación
    });
  }
}
