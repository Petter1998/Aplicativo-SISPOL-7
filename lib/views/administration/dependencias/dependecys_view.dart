import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/administration/dependencias/dependency_controller.dart';
import 'package:sispol_7/models/administration/dependencias/dependecy_model.dart';
import 'package:sispol_7/views/administration/dependencias/edit_dependecy_screen.dart';
import 'package:sispol_7/views/administration/dependencias/registration_dependecy_screen.dart';
import 'package:sispol_7/views/administration/dependencias/search_subcircuit_screen.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class DependencysView extends StatefulWidget {
  const DependencysView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DependencysViewState createState() => _DependencysViewState();
}


class _DependencysViewState extends State<DependencysView> {
  final DependecyController _controller = DependecyController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Dependecy> _dependecys = [];

  @override
  void initState() {
    super.initState();
    _fetchDependecys();
  }

  void _fetchDependecys() async {
    List<Dependecy> dependecys = await _controller.fetchDependecys();
    setState(() {
      _dependecys = dependecys;
    });
  }

  void _refreshData() {
    _fetchDependecys();
  }

  void _showSearchDialog() {
    String query = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Subcircuito',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: const InputDecoration(hintText: "Ingrese el nombre del Subcircuito"),
            style: GoogleFonts.inter( color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Buscar',
              style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Dependecy> results = await _controller.searchDependencies(query);
                  if (results.isEmpty) {
                    _showNoResultsAlert();
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SearchSubcircuitView(searchResults: results),
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
          content: Text('No se encontró ninguna dependencia con ese nombre.',
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

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          // ignore: deprecated_member_use
          return pw.Table.fromTextArray(
            headers: <String>[
              'ID', 'Fecha de Creación', 'Provincia', 'No. Distritos', 'Parroquia', 
              'Cod. Distrito', 'Nombre Distrito', 'No. Circuitos', 'Cod. Circuitos', 'Nombre Circuito', 
              'No. Subcircuitos', 'Cod. Subcircuito', 'Nombre Subcircuito'],
              data: _dependecys.map((dependecy) => [
                dependecy.id.toString(),
                dependecy.fechacrea != null ? _dateFormat.format(dependecy.fechacrea!) : 'N/A',
                dependecy.provincia,
                dependecy.nDistr.toString(),
                dependecy.parroquia,
                dependecy.codDistr,
                dependecy.nameDistr,
                dependecy.nCircuit.toString(),
                dependecy.codCircuit,
                dependecy.nameCircuit,
                dependecy.nsCircuit.toString(),
                dependecy.codsCircuit,
                dependecy.namesCircuit,
              ]).toList(),
          );
        },
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
      body: FutureBuilder<List<Dependecy>>(
        future: _controller.fetchDependecys(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final dependecys = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Provincia'),
                  _buildColumn('No. \nDistritos'),
                  _buildColumn('Parroquia'),
                  _buildColumn('Cod. \nDistrito'),
                  _buildColumn('Nombre \nDistrito'),
                  _buildColumn('No. \nCircuitos'),
                  _buildColumn('Cod. \nCircuitos'),
                  _buildColumn('Nombre \nCircuito'),
                  _buildColumn('No. \nSubcircuitos'),
                  _buildColumn('Cod. \nSubcircuito'),
                  _buildColumn('Nombre \nSubcircuito'),
                  _buildColumn('Opciones'),
                ],
                rows: dependecys.map((dependecy) {
                  return DataRow(cells:[
                    _buildCell(dependecy.id.toString()),
                    _buildCell(dependecy.fechacrea != null ? _dateFormat.format(dependecy.fechacrea!) : 'N/A'),
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
                            setState(() {
                              _fetchDependecys();
                            });
                          },
                        ),
                      ],
                    )),
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
               MaterialPageRoute(builder: (context) => const RegistrationDependecyScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Registrar una nueva Dependencia',
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