import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/dependencias/dependency_controller.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';


class RegistrationDependecyScreen extends StatefulWidget {
  const RegistrationDependecyScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationDependecyScreenState createState() => _RegistrationDependecyScreenState();
}

class _RegistrationDependecyScreenState extends State<RegistrationDependecyScreen> {

  final TextEditingController _provinciaController = TextEditingController();
  final TextEditingController _nDistritosController = TextEditingController();
  final TextEditingController _parroquiaController = TextEditingController();
  final TextEditingController _codDistritoController = TextEditingController();
  final TextEditingController _nameDistritoController = TextEditingController();
  final TextEditingController _nCircuitosController = TextEditingController();
  final TextEditingController _codCircuitoController = TextEditingController();
  final TextEditingController _nameCircuitoController = TextEditingController();
  final TextEditingController _nSubcircuitosController = TextEditingController();
  final TextEditingController _codSubcircuitoController = TextEditingController();
  final TextEditingController _nameSubcircuitoController = TextEditingController();

  final DependecysController _dependecysController = DependecysController();



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
                      Icons.share_location, // Icono de usuario
                      size: imageSize, // Tamaño del icono
                      color: Colors.black, // Color del icono
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                             TextField(controller: _provinciaController,
                              decoration: const InputDecoration(
                                labelText: 'Provincia',
                                hintText: 'Provincia',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _nDistritosController,
                              decoration: const InputDecoration(
                                labelText: 'Número de Distritos',
                                hintText: 'Número de Distritos',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _parroquiaController,
                              decoration: const InputDecoration(
                                labelText: 'Parroquia',
                                hintText: 'Parroquia',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _codDistritoController,
                              decoration: const InputDecoration(
                                labelText: 'Código Distrito',
                                hintText: 'Código Distrito',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                             TextField(
                              controller: _nameDistritoController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre Distrito',
                                hintText: 'Nombre Distrito',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _nCircuitosController,
                              decoration: const InputDecoration(
                                labelText: 'Número de Circuitos',
                                hintText: 'Número de Circuitos',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                      SizedBox(width: verticalSpacing), // Espacio entre las dos columnas
                      Expanded(
                        child: Column(
                          children: [
                             TextField(
                                controller: _codCircuitoController,
                                decoration: const InputDecoration(
                                  labelText: 'Código Circuito',
                                  hintText: 'Código Circuito',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                              ),

                              SizedBox(height: verticalSpacing),

                              TextField(
                                controller: _nameCircuitoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Circuito',
                                  hintText: 'Nombre Circuito',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                              ),

                              SizedBox(height: verticalSpacing),

                              TextField(
                                controller: _nSubcircuitosController,
                                decoration: const InputDecoration(
                                  labelText: 'Número de Subcircuitos',
                                  hintText: 'Número de Subcircuitos',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                                //keyboardType: TextInputType.number,
                              ),

                              SizedBox(height: verticalSpacing),

                              TextField(
                                controller: _codSubcircuitoController,
                                decoration: const InputDecoration(
                                  labelText: 'Código Subcircuito',
                                  hintText: 'Código Subcircuito',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                              ),

                              SizedBox(height: verticalSpacing),

                              TextField(
                                controller: _nameSubcircuitoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre Subcircuito',
                                  hintText: 'Nombre Subcircuito',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                              ),
                              SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                    ],
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
                    onPressed: () {
                      _registerDependecys();
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

  void _registerDependecys() {
    // Recoge los datos del formulario y los pasa al controlador
    Map<String, dynamic> depData = {
      'provincia': _provinciaController.text,
      'numeroDistritos': int.parse(_nDistritosController.text),
      'parroquia': _parroquiaController.text,
      'codigoDistrito': _codDistritoController.text,
      'nombreDistrito': _nameDistritoController.text,
      'numeroCircuitos':int.parse(_nCircuitosController.text),
      'codigoCircuito': _codCircuitoController.text,
      'nombreCircuito': _nameCircuitoController.text,
      'numeroSubcircuitos': int.parse(_nSubcircuitosController.text),
      'codigoSubcircuito': _codSubcircuitoController.text,
      'nombreSubcircuito': _nameSubcircuitoController.text,
    };

    // Usa el controlador para registrar la dependencia
    _dependecysController.registerDependecys(context, {
      ...depData,
      'fechaCreacion': FieldValue.serverTimestamp(), // Agrega la fecha de creación
    });
  }
}
