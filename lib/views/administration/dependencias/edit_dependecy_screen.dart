import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/administration/dependencias/dependency_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class EditDependecyScreen extends StatefulWidget {
  final Dependecy dependecy;
  

  const EditDependecyScreen({super.key, required this.dependecy});

  @override
  // ignore: library_private_types_in_public_api
  _EditDependecyScreenState createState() => _EditDependecyScreenState();
}

class _EditDependecyScreenState extends State<EditDependecyScreen> {
  late TextEditingController _provinciaController;
  late TextEditingController _nDistritosController;
  late TextEditingController _parroquiaController;
  late TextEditingController _codDistritoController;
  late TextEditingController _nameDistritoController;
  late TextEditingController _nCircuitosController;
  late TextEditingController _codCircuitoController;
  late TextEditingController _nameCircuitoController;
  late TextEditingController _nSubcircuitosController;
  late TextEditingController _codSubcircuitoController;
  late TextEditingController _nameSubcircuitoController;

  @override
  void initState() {
    super.initState();
    _provinciaController = TextEditingController(text: widget.dependecy.provincia);
    _nDistritosController = TextEditingController(text: widget.dependecy.nDistr.toString());
    _parroquiaController = TextEditingController(text: widget.dependecy.parroquia);
    _codDistritoController = TextEditingController(text: widget.dependecy.codDistr);
    _nameDistritoController = TextEditingController(text: widget.dependecy.nameDistr);
    _nCircuitosController = TextEditingController(text: widget.dependecy.nCircuit.toString());
    _codCircuitoController = TextEditingController(text: widget.dependecy.codCircuit);
    _nameCircuitoController = TextEditingController(text: widget.dependecy.nameCircuit);
    _nSubcircuitosController = TextEditingController(text: widget.dependecy.nsCircuit.toString());
    _codSubcircuitoController = TextEditingController(text: widget.dependecy.codsCircuit);
    _nameSubcircuitoController = TextEditingController(text: widget.dependecy.namesCircuit);
  }

  @override
  void dispose() {
    _provinciaController.dispose();
    _nDistritosController.dispose();
    _parroquiaController.dispose();
    _codDistritoController.dispose();
    _nameDistritoController.dispose();
    _nCircuitosController.dispose();
    _codCircuitoController.dispose();
    _nameCircuitoController.dispose();
    _nSubcircuitosController.dispose();
    _codSubcircuitoController.dispose();
    _nameSubcircuitoController.dispose();
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
                                labelText: 'Código del Distrito',
                                hintText: 'Código del Distrito',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),

                            SizedBox(height: verticalSpacing),

                             TextField(
                              controller: _nameDistritoController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del Distrito',
                                hintText: 'Nombre del Distrito',
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
                                  labelText: 'Código del Circuito',
                                  hintText: 'Código del Circuito',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                              ),

                              SizedBox(height: verticalSpacing),

                              TextField(
                                controller: _nameCircuitoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre del Circuito',
                                  hintText: 'Nombre del Circuito',
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
                                  labelText: 'Código del Subcircuito',
                                  hintText: 'Código del Subcircuito',
                                  fillColor: Colors.black,
                                  border: OutlineInputBorder(),
                                ),
                                style: GoogleFonts.inter(fontSize: bodyFontSize),
                              ),

                              SizedBox(height: verticalSpacing),

                              TextField(
                                controller: _nameSubcircuitoController,
                                decoration: const InputDecoration(
                                  labelText: 'Nombre del Subcircuito',
                                  hintText: 'Nombre del Subcircuito',
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
                      final updatedDependecy = Dependecy(
                        id: widget.dependecy.id,
                        provincia: _provinciaController.text,
                        nDistr: int.tryParse(_nDistritosController.text) ?? 0,
                        parroquia: _parroquiaController.text,
                        codDistr: _codDistritoController.text,
                        nameDistr: _nameDistritoController.text,
                        nCircuit: int.tryParse(_nCircuitosController.text) ?? 0,
                        codCircuit: _codCircuitoController.text,
                        nameCircuit: _nameCircuitoController.text,
                        nsCircuit: int.tryParse(_nSubcircuitosController.text) ?? 0,
                        codsCircuit: _codSubcircuitoController.text,
                        namesCircuit: _nameSubcircuitoController.text,
                        fechacrea: DateTime.now(),
                      );

                      await DependecyController().updateDependecy(updatedDependecy);
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