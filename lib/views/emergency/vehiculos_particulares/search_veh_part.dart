import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/emergency/vehicle_part_controller.dart';
import 'package:sispol_7/models/emergency/vehicle_model.dart';
import 'package:sispol_7/views/emergency/vehiculos_particulares/regist_veh_part.dart';
import 'package:sispol_7/views/emergency/vehiculos_particulares/vehicles_part_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class SearchVehiclePartView extends StatefulWidget {
  final List<Vehicle> searchResults;

  const SearchVehiclePartView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchVehiclePartViewState createState() => _SearchVehiclePartViewState();
}

class _SearchVehiclePartViewState extends State<SearchVehiclePartView> {
  final VehiclePartController _controller = VehiclePartController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _fetchVehicles() async {
    setState(() {
      // Actualiza la lista de vehículos
    });
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
            _buildColumn('Propietario'),
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
              _buildCell(vehicle.responsable1),
              _buildCell(vehicle.fechacrea != null
                  ? dateFormat.format(vehicle.fechacrea!)
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VehiclesPartView()),
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