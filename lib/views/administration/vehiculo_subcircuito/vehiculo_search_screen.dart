import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/flota_vehicular/vehicle_controller.dart';
import 'package:sispol_7/controllers/administration/vehiculo_subcircuito/vehisub_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';
import 'package:sispol_7/views/administration/vehiculo_subcircuito/vehiculo_assig_subcircuit.dart';
import 'package:sispol_7/views/administration/vehiculo_subcircuito/vehiculo_subcircuit_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class VehiculoSearchResultView extends StatefulWidget {
  final List<Vehicle> searchResults;

  const VehiculoSearchResultView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _VehiculoSearchResultViewState createState() => _VehiculoSearchResultViewState();
}

class _VehiculoSearchResultViewState extends State<VehiculoSearchResultView> {
  // ignore: unused_field
  final VehicleController _vehiclecontroller = VehicleController();
  final VehiSubController _vehisubcontroller = VehiSubController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Vehicle> _vehicles = [];
  

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }


  void _refreshData() {
    _fetchVehicles();
  }


  void _fetchVehicles() async {
    List<Vehicle> vehicles = await _vehiclecontroller.fetchVehicles();
    setState(() {
      _vehicles= vehicles;
    });
  }


  Future<void> _generatePDF() async {
    try {
      final pdf = pw.Document();
      final logoImage = pw.MemoryImage(
        (await rootBundle.load('assets/images/Escudo.jpg')).buffer.asUint8List(),
      );
      final currentDate = DateTime.now();
      final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
      final formattedTime = DateFormat('HH:mm:ss').format(currentDate);

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (pw.Context context) => [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    'Sistema Integral de Automatización y Optimización para la Subzona 7 de la Policía Nacional en Loja',
                    style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logoImage, width: 70, height: 70),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Reporte de Vehiculos asignado a Subcircuito', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Detalles de Vehiculo - Subcircuito en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
              ],
            ),
            pw.TableHelper.fromTextArray(
              headers: <String>[
              'ID', 'Marca', 'Modelo', 'Motor', 'Placa', 'Chasis', 'Tipo', 'Cilindraje',
                'Capacidad de Pasajeros', 'Capacidad de Carga', 'Kilometraje', 'Dependencia',
                'Responsable 1', 'Responsable 2', 'Responsable 3',
                'Responsable 4','Fecha de Creación'],
                data: widget.searchResults.map((vehicle) => [
                  vehicle.id.toString(),
                  vehicle.marca,
                  vehicle.modelo,
                  vehicle.motor,
                  vehicle.placa,
                  vehicle.chasis,
                  vehicle.tipo,
                  vehicle.cilindraje.toString(),
                  vehicle.capacidadPas.toString(),
                  vehicle.capacidadCar.toString(),
                  vehicle.kilometraje.toString(),
                  vehicle.dependencia,
                  vehicle.responsable1,
                  vehicle.responsable2,
                  vehicle.responsable3,
                  vehicle.responsable4,
                  vehicle.fechacrea != null
                      ? dateFormat.format(vehicle.fechacrea!)
                      : 'N/A',
              ]).toList(),
              cellStyle: const pw.TextStyle(fontSize: 8), // Reduce el tamaño de la fuente de los datos
              headerStyle: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold), // Aplica fontWeight.bold a los encabezados
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellAlignment: pw.Alignment.center,
            ),
          ], 
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error generando el PDF: $e');
    }
  }

  void _showAssignDialog() async{
    List<Dependecy> dependencias = await _vehisubcontroller.fetchDependencias();
    String? selectedSubcircuito;
    

    showDialog(
      // ignore: use_build_context_synchronously
      context: context,
      builder: (context) {
        return AlertDialog(
          title:  Text('Asignar a Subcircuito',
          style: GoogleFonts.inter(color: Colors.black),),
          content: DropdownButtonFormField<String>(
            items: dependencias.map((dependencia) {
              return DropdownMenuItem<String>(
                value: dependencia.namesCircuit,
                child: Text(dependencia.namesCircuit),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedSubcircuito = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar',
              style: GoogleFonts.inter(color: Colors.black),),
            ),
             TextButton(
            onPressed: () async {
              if (selectedSubcircuito != null) {
                List<Vehicle> selectedVehicles = _vehicles
                    .where((vehicle) => _vehisubcontroller.selectedIds.contains(vehicle.id))
                    .toList();

                  try {
                    // 1. Verificar si hay vehiculos seleccionados
                    if (selectedVehicles.isEmpty) {
                      throw Exception('Seleccione al menos un registro.');
                    }

                    // 2. Verificar si alguno ya está asignado a otro subcircuito
                    if (await _vehisubcontroller.isAnyVehicleAlreadyAssigned(selectedVehicles, selectedSubcircuito!)) {
                      throw Exception('Uno o más registros ya están asignados a otro subcircuito.');
                    }

                    // 3. Verificar si ya pertenecen al subcircuito seleccionado
                    bool alreadyAssignedToSelectedSubcircuit = false;
                    for (var vehicle in selectedVehicles) {
                      final subcircuitoDoc = await FirebaseFirestore.instance
                          .collection('vehiculo_subcircuito')
                          .doc(selectedSubcircuito) // Verificar en el subcircuito seleccionado
                          .collection(selectedSubcircuito!)
                          .where('id', isEqualTo: vehicle.id)
                          .limit(1)
                          .get();

                      if (subcircuitoDoc.docs.isNotEmpty) {
                        alreadyAssignedToSelectedSubcircuit = true;
                        break; // Salir del bucle si encontramos uno ya asignado
                      }
                    }

                    if (alreadyAssignedToSelectedSubcircuit) {
                      throw Exception('Uno o todos los registros seleccionados ya pertenecen al subcircuito seleccionado.');
                    }

                    // Si todas las verificaciones pasan, proceder con la asignación
                    // ignore: use_build_context_synchronously
                    await _vehisubcontroller.assignToSubcircuito(context, selectedVehicles, selectedSubcircuito!);
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VehicleSubcircuitoAssignedView(subcircuitoName: selectedSubcircuito!),
                    ));
                  } catch (e) {
                    // Mostrar diálogo de error si se lanza una excepción
                    showDialog(
                      // ignore: use_build_context_synchronously
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Error de Asignación',
                        style: GoogleFonts.inter(color: Colors.black),),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            child: Text('OK',
                            style: GoogleFonts.inter(color: Colors.black),),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: Text('Asignar', style: GoogleFonts.inter(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 20 : 22);
    double bodyFontSize = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 18 : 20);

    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    // ignore: no_leading_underscores_for_local_identifiers
    DataColumn _buildColumn(String label) {
      return DataColumn(
        label: Text(
          label,
          style: GoogleFonts.inter(fontSize: titleFontSize,fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
    }

    // ignore: no_leading_underscores_for_local_identifiers
    DataCell _buildCell(String text) {
      return DataCell(
        Text(
          text,
          style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black),
        ),
      );
    }
    
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            _buildColumn('Select'),
            _buildColumn('ID'),
            _buildColumn('Marca'),
            _buildColumn('Modelo'),
            _buildColumn('Motor'),
            _buildColumn('Placa'),
            _buildColumn('Chasis'),
            _buildColumn('Tipo'),
            _buildColumn('Cilindraje\n (cc)'),
            _buildColumn('Capacidad de \n  Pasajeros'),
            _buildColumn('Capacidad de \n  Carga(Ton)'),
            _buildColumn('Kilometraje'),
            _buildColumn('Dependencia'),
            _buildColumn('Responsable \n1'),
            _buildColumn('Responsable \n2'),
            _buildColumn('Responsable \n3'),
            _buildColumn('Responsable \n4'),
            _buildColumn('Fecha de \nCreación'),
          ],
          rows: widget.searchResults.map((vehicle) {
            return DataRow(
                    selected: _vehisubcontroller.selectedIds.contains(vehicle.id),
                    onSelectChanged: (selected) {
                      setState(() {
                        _vehisubcontroller.toggleSelection(vehicle.id);
                      });
                    },
                    cells: [
                      DataCell(Checkbox(
                        value: _vehisubcontroller.selectedIds.contains(vehicle.id),
                        onChanged: (selected) {
                          setState(() {
                            _vehisubcontroller.toggleSelection(vehicle.id);
                          });
                        },
                      )),
              _buildCell(vehicle.id.toString()),
              _buildCell(vehicle.marca),
              _buildCell(vehicle.modelo),
              _buildCell(vehicle.motor),
              _buildCell(vehicle.placa),
              _buildCell(vehicle.chasis),
              _buildCell(vehicle.tipo),
              _buildCell(vehicle.cilindraje.toString()),
              _buildCell(vehicle.capacidadPas.toString()),
              _buildCell(vehicle.capacidadCar.toString()),
              _buildCell(vehicle.kilometraje.toString()),
              _buildCell(vehicle.dependencia),
              _buildCell(vehicle.responsable1),
              _buildCell(vehicle.responsable2),
              _buildCell(vehicle.responsable3),
              _buildCell(vehicle.responsable4),
              _buildCell(vehicle.fechacrea != null
                  ? dateFormat.format(vehicle.fechacrea!)
                  : 'N/A'),
            ]);
          }).toList(),
        ),
      ),
    floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           FloatingActionButton(
            onPressed: _showAssignDialog,
            // ignore: sort_child_properties_last
            child: Icon(Icons.assignment_add, size: iconSize,color:  Colors.black),
            tooltip: 'Asignar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),


          FloatingActionButton(
            onPressed: () {
              // Acción para refrescar o actualizar
              _refreshData();
            },
            tooltip: 'Refrescar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _generatePDF,
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize,color:  Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VehiclesSubcircuitView()),
              );
            },
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.arrow_back, size: iconSize, color:  Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}