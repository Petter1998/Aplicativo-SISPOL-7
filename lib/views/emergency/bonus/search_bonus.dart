import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/models/emergency/vehicle_model.dart';
import 'package:sispol_7/views/emergency/vehiculos_particulares/vehicles_part_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class SearchBonusView extends StatefulWidget {
  final List<Vehicle> searchResults;

  const SearchBonusView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchBonusViewState createState() => _SearchBonusViewState();
}

class _SearchBonusViewState extends State<SearchBonusView> {
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  
  double calculateBonus(int kmInicial, int kmActual, String peligrosidad) {
    double factor;
    switch (peligrosidad.toLowerCase()) {
      case 'baja':
        factor = 0.10;
        break;
      case 'media':
        factor = 0.15;
        break;
      case 'alta':
        factor = 0.20;
        break;
      default:
        factor = 0.0;
    }
    return (kmActual - kmInicial) * factor;
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
            _buildColumn('Kilometraje \n Inicial'),
            _buildColumn('Kilometraje \n Actual'),
            _buildColumn('Propietario'),
            _buildColumn('Bono'),
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
          ],
          rows: widget.searchResults.map((vehicle) {
            double bono = calculateBonus(vehicle.kilometraje, vehicle.kilometrajeA, vehicle.pelig);
            return DataRow(cells: [
              _buildCell(vehicle.id.toString()),
              _buildCell(vehicle.kilometraje.toString()),
              _buildCell(vehicle.kilometrajeA.toString()),
              _buildCell(vehicle.responsable1),
              _buildCell('\$${bono.toStringAsFixed(2)}'),
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