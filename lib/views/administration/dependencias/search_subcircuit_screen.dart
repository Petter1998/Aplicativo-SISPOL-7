import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/dependencias/dependency_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/views/administration/dependencias/dependecys_view.dart';
import 'package:sispol_7/views/administration/dependencias/edit_dependecy_screen.dart';
import 'package:sispol_7/views/administration/dependencias/registration_dependecy_screen.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

// ignore: must_be_immutable
class SearchSubcircuitView extends StatelessWidget {
  final List<Dependecy> searchResults;
  final DependecyController _controller = DependecyController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  SearchSubcircuitView({super.key, required this.searchResults});

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 20 : 24);
    double bodyFontSize = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 18 : 20);

    // Determinando el tamaño de los iconos basado en el ancho de la pantalla
    double iconSize = screenWidth > 480 ? 34.0 : 20.0;

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
            _buildColumn('Fecha de Creación'),
            _buildColumn('Provincia'),
            _buildColumn('No. Distritos'),
            _buildColumn('Parroquia'),
            _buildColumn('Cod. Distrito'),
            _buildColumn('Nombre Distrito'),
            _buildColumn('No. Circuitos'),
            _buildColumn('Cod. Circuitos'),
            _buildColumn('Nombre Circuito'),
            _buildColumn('No. Subcircuitos'),
            _buildColumn('Cod. Subcircuito'),
            _buildColumn('Nombre Subcircuito'),
            _buildColumn('Opciones'),
          ],
          rows: searchResults.map((dependecy) {
            return DataRow(cells:[
              _buildCell(dependecy.id.toString()),
              _buildCell(dependecy.fechacrea != null ? dateFormat.format(dependecy.fechacrea!) : 'N/A'),
              _buildCell(dependecy.provincia),
              _buildCell(dependecy.nDistr.toString()),
              _buildCell(dependecy.parroquia),
              _buildCell(dependecy.codDistr),
              _buildCell(dependecy.nameDistr),
              _buildCell(dependecy.nCircuit.toString()),
              _buildCell(dependecy.codCircuit),
              _buildCell(dependecy.nameCircuit),
              _buildCell(dependecy.nsCircuit.toString()),
              _buildCell(dependecy.codsCircuit),
              _buildCell(dependecy.namesCircuit),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                     Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditDependecyScreen(dependecy: dependecy,),
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _controller.deleteDependecy(dependecy.id);
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
                MaterialPageRoute(builder: (context) => const RegistrationDependecyScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Register New User',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              // Implement generate report functionality
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.picture_as_pdf, size: iconSize, color:  Colors.black),
            tooltip: 'Generate Report',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DependencysView()),
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