import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/emergency/vehicle_part_controller.dart';
import 'package:sispol_7/models/emergency/vehicle_model.dart';
import 'package:sispol_7/views/emergency/vehiculos_particulares/regist_veh_part.dart';
import 'package:sispol_7/views/emergency/vehiculos_particulares/search_veh_part.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class VehiclesPartView extends StatefulWidget {
  const VehiclesPartView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VehiclesPartViewState createState() => _VehiclesPartViewState();
}

class _VehiclesPartViewState extends State<VehiclesPartView> {
  final VehiclePartController _controller = VehiclePartController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Vehicle> _vehicles = [];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  void _fetchVehicles() async {
    List<Vehicle> vehicles = await _controller.fetchVehicles();
    setState(() {
      _vehicles= vehicles;
    });
  }

  void _refreshData() {
    _fetchVehicles();
  }

  void _showSearchDialog() {
    String query = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buscar Vehículo',
            style: GoogleFonts.inter(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  query = value;
                },
                decoration: const InputDecoration(hintText: "Ingrese la placa o chasis"),
                style: GoogleFonts.inter(color: Colors.black),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Buscar',
                style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Vehicle> results = await _controller.searchVehicle(query);
                if (results.isEmpty) {
                  _showNoResultsAlert();
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchVehiclePartView(searchResults: results),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showNoResultsAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No se encontraron resultados',
          style: GoogleFonts.inter(color: Colors.black),),
          content: Text('No se encontró ningún Vehiculo Particular con ese valores.',
          style: GoogleFonts.inter(color: Colors.black),),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
              style: GoogleFonts.inter(color: Colors.black),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Vehicle vehicle) {
    final TextEditingController observationController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Vehículo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('¿Está seguro de que desea eliminar este vehículo?'),
              TextField(
                controller: observationController,
                decoration: const InputDecoration(
                  labelText: 'Observación',
                  hintText: 'Ingrese la observación',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                String observation = observationController.text;
                if (observation.isNotEmpty) {
                  await _controller.deleteVehicle(vehicle, observation);
                  setState(() {
                    _fetchVehicles();
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('La observación es requerida para eliminar un vehículo.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }


  Future<void> _generatePDF() async {
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
                        pw.Text('Reporte de Flota Vehicular Particular', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Detalles de los vehículos particulares en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ],
              ),
              pw.TableHelper.fromTextArray(
                headers: <String>[
                  'ID', 'Marca', 'Modelo', 'Motor', 'Placa', 'Chasis', 'Tipo', 'Peligrosidad','Cilindraje',
                  'Cap Pasaj', 'Cap Carga', 'Km Inicial', 'Km Actual',
                  'Propietario', 'Fecha de Creación'
                ],
                data: _vehicles.map((vehicle) => [
                  vehicle.id.toString(),
                  vehicle.marca,
                  vehicle.modelo,
                  vehicle.motor,
                  vehicle.placa,
                  vehicle.chasis,
                  vehicle.tipo,
                  vehicle.pelig,
                  vehicle.cilindraje.toString(),
                  vehicle.capacidadPas.toString(),
                  vehicle.capacidadCar.toString(),
                  vehicle.kilometraje.toString(),
                  vehicle.kilometrajeA.toString(),
                  vehicle.responsable1,
                  vehicle.fechacrea != null ? _dateFormat.format(vehicle.fechacrea!) : 'N/A',
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
      body: FutureBuilder<List<Vehicle>>(
        future: _controller.fetchVehicles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final vehicles = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Kilometraje \n Inicial'),
                  _buildColumn('Kilometraje \n Actual'),
                  _buildColumn('Propietario'),
                  _buildColumn('Marca'),
                  _buildColumn('Modelo'),
                  _buildColumn('Motor'),
                  _buildColumn('Placa'),
                  _buildColumn('Chasis'),
                  _buildColumn('Tipo'),
                  _buildColumn('Nivel \nPeligrosidad'),
                  _buildColumn('Cilindraje\n (cc)'),
                  _buildColumn('Capacidad de \n  Pasajeros'),
                  _buildColumn('Capacidad de \n  Carga(Ton)'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                ],
                rows: vehicles.map((vehicle) {
                  return DataRow(cells: [
                    _buildCell(vehicle.id.toString()),
                    _buildCell(vehicle.kilometraje.toString()),
                    _buildCell(vehicle.kilometrajeA.toString()),
                    _buildCell(vehicle.responsable1),
                    _buildCell(vehicle.marca),
                    _buildCell(vehicle.modelo),
                    _buildCell(vehicle.motor),
                    _buildCell(vehicle.placa),
                    _buildCell(vehicle.chasis),
                    _buildCell(vehicle.tipo),
                    _buildCell(vehicle.pelig),
                    _buildCell(vehicle.cilindraje.toString()),
                    _buildCell(vehicle.capacidadPas.toString()),
                    _buildCell(vehicle.capacidadCar.toString()),
                    _buildCell(vehicle.fechacrea != null
                        ? _dateFormat.format(vehicle.fechacrea!)
                        : 'N/A'),
                    DataCell(
                      Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                _showDeleteDialog(context, vehicle);
                                },
                              ),
                            ],
                          ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            );
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const RegistrationVehiclePartScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar un nuevo Vehiculo',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _showSearchDialog,
            // ignore: sort_child_properties_last
            child: Icon(Icons.search, size: iconSize,color:  Colors.black),
            tooltip: 'Buscar',
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
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}