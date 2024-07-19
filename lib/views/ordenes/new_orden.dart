import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/ordenes/ordenes_controller.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';


class WorkOrdenScreen extends StatefulWidget {
  const WorkOrdenScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WorkOrdenScreenState createState() => _WorkOrdenScreenState();
}

class _WorkOrdenScreenState extends State<WorkOrdenScreen> {
  final TextEditingController _personalEmiteController = TextEditingController();
  final TextEditingController _personalVehiculoController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _vehiculoController = TextEditingController();
  final TextEditingController _lubricantesController = TextEditingController();
  final TextEditingController _repuestosController = TextEditingController();

  final OrdenController _ordenController = OrdenController();
  //final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  ///String? _selectedTipo;
  final List<String> tipos = ['Auto', 'Motocicleta', 'Camioneta'];

  String? _selectedEstado;
  final List<String> estados = ['En Progreso', 'Finalizada'];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth < 480 ? 100.0 : (screenWidth > 1000 ? 200 : 150);
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);
    //double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);
    double iconSize = screenWidth > 480 ? 34.0 : 27.0;
    double horizontalPadding = screenWidth < 800 ? screenWidth * 0.05 : screenWidth * 0.20;

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
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: Icon(
                      Icons.receipt_long_rounded,
                      size: imageSize,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _personalEmiteController,
                          decoration: const InputDecoration(
                            labelText: 'Personal que Emite',
                            hintText: 'Personal que Emite',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _personalVehiculoController,
                          decoration: const InputDecoration(
                            labelText: 'Personal del Vehículo',
                            hintText: 'Personal del Vehículo',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
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
                              _estadoController.text = newValue!;
                            });
                          },
                          items: estados.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _vehiculoController,
                    decoration: const InputDecoration(
                      labelText: 'Vehículo',
                      hintText: 'Vehículo',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _lubricantesController,
                    decoration: const InputDecoration(
                      labelText: 'Lubricantes',
                      hintText: 'Lubricantes',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _repuestosController,
                    decoration: const InputDecoration(
                      labelText: 'Repuestos',
                      hintText: 'Repuestos',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),
                 
                  SizedBox(height: verticalSpacing),
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
                        _registerOrden();
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

  void _registerOrden() async {
    try {
      final Map<String, dynamic> ordenData = {
        'personalEmite': _personalEmiteController.text,
        'personalVehiculo': _personalVehiculoController.text,
        'estado': _estadoController.text,
        'vehiculo': _vehiculoController.text,
        'lubricantes': _lubricantesController.text,
        'repuestos': _repuestosController.text,
        
      };

      await _ordenController.registerOrden(context, {
        ...ordenData,
        'fechaEmision': FieldValue.serverTimestamp(),
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Orden registrada exitosamente')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    }
  }
}
