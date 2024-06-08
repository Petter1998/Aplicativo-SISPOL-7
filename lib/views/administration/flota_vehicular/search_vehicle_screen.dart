import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/flota_vehicular/vehicle_controller.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';
import 'package:sispol_7/views/administration/flota_vehicular/edit_vehicle_screen.dart';
import 'package:sispol_7/views/administration/flota_vehicular/registration_vehicle_screen.dart';
import 'package:sispol_7/views/administration/flota_vehicular/vehicle_view.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

// ignore: must_be_immutable
class SearchVehicleView extends StatefulWidget {
  final List<Vehicle> searchResults;

  const SearchVehicleView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchVehicleViewState createState() => _SearchVehicleViewState();
}

class _SearchVehicleViewState extends State<SearchVehicleView> {
  final VehicleController _controller = VehicleController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _fetchVehicles() async {
    setState(() {
      // Actualizar la lista de vehículos
    });
  }
  

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // ignore: deprecated_member_use
          return pw.Table.fromTextArray(
            headers: <String>[
              'ID', 'Marca', 'Modelo', 'Motor', 'Placa', 'Chasis', 'Tipo', 'Cilindraje',
              'Capacidad de Pasajeros', 'Capacidad de Carga', 'Kilometraje', 
              'Fecha de Creación'],
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
                vehicle.fechacrea != null
                    ? dateFormat.format(vehicle.fechacrea!)
                    : 'N/A',
              ]).toList(),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
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
            _buildColumn('Fecha de \nCreación'),
            _buildColumn('Opciones'),
          ],
          rows: widget.searchResults.map((vehicle) {
            return DataRow(cells: [
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
              _buildCell(vehicle.fechacrea != null
                  ? dateFormat.format(vehicle.fechacrea!)
                  : 'N/A'),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditVehicleScreen(vehicle: vehicle,),
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _showDeleteDialog(context, vehicle);
                    },
                  ),
                ],
              )),
            ]);
          }).toList(),
        ),
      ),
    floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrationVehicleScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar un nuevo Vehiculo',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
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
                MaterialPageRoute(builder: (context) => const VehiclesView()),
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