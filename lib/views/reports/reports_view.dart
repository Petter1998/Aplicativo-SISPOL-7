import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/reports/reports_controller.dart';
import 'package:sispol_7/models/reports/reports_model.dart';
//import 'package:pdf/pdf.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';
import 'package:intl/intl.dart';
//import 'package:pdf/widgets.dart' as pw;
//import 'package:printing/printing.dart';

class ReportesView extends StatefulWidget {
  const ReportesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReportesViewState createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  final ReportesController _controller = ReportesController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Reportes> _reportes = [];
  List<int> _selectedReports = [];

  @override
  void initState() {
    super.initState();
    _fetchReporte();
  }

  void _fetchReporte() async {
    List<Reportes> reportes = await _controller.fetchReporte();
    setState(() {
      _reportes = reportes;
    });
  }

  void _refreshData() {
    _fetchReporte();
  }

  void _showSearchDialog() {
    String query = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buscar Reporte',
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
                decoration: const InputDecoration(hintText: "Ingrese el nombre del Responsable que entregó el Vehículo"),
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
                List<Reportes> results = await _controller.searchReporte(query);
                if (results.isEmpty) {
                  _showNoResultsAlert();
                } else {
                  // ignore: use_build_context_synchronously
                  //Navigator.of(context).push(
                   // MaterialPageRoute(
                      //builder: (context) => SearchVehicleView(searchResults: results),
                   // ),
                  //);
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
          content: Text('No se encontró ningún reporte con esos valores.',
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
          style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black),
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
      body: FutureBuilder<List<Reportes>>(
        future: _controller.fetchReporte(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final reportes = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Checkbox(
                    value: _selectedReports.length == reportes.length && reportes.isNotEmpty,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedReports = reportes.map((rep) => rep.id).toList();
                        } else {
                          _selectedReports.clear();
                        }
                      });
                    },
                  )),
                  _buildColumn('ID'),
                  _buildColumn('Fecha de \nSolicitud'),
                  _buildColumn('Fecha de \nRegistro'),
                  _buildColumn('Fecha de \nEntrega'),
                  _buildColumn('Responsable que \nEntrega'),
                  _buildColumn('Responsable que \nRetira'),
                  _buildColumn('Kilometraje \nActual'),
                  _buildColumn('Kilometraje \nPróximo \nMantenimiento'),
                  _buildColumn('Tipo de \nMantenimiento'),
                  _buildColumn('Mantenimiento \nComplementario'),
                  _buildColumn('Observaciones'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                ],
                rows: reportes.map((reportes) {
                  return DataRow(
                    selected: _selectedReports.contains(reportes.id),
                    onSelectChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedReports.add(reportes.id);
                        } else {
                          _selectedReports.remove(reportes.id);
                        }
                      });
                    },
                    cells: [
                      DataCell(Checkbox(
                        value: _selectedReports.contains(reportes.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedReports.add(reportes.id);
                            } else {
                              _selectedReports.remove(reportes.id);
                            }
                          });
                        },
                      )),
                      _buildCell(reportes.id.toString()),
                      _buildCell(reportes.fechasol),
                      _buildCell(reportes.fechareg),
                      _buildCell(reportes.fechaentreg),
                      _buildCell(reportes.responsableentreg),
                      _buildCell(reportes.responsablereti),
                      _buildCell(reportes.kilometrajeActual.toString()),
                      _buildCell(reportes.kilometrajeProx.toString()),
                      _buildCell(reportes.tipoMant),
                      _buildCell(reportes.mantComple),
                      _buildCell(reportes.observaciones),
                      _buildCell(reportes.fechacrea != null ? _dateFormat.format(reportes.fechacrea!) : 'N/A'),
                      DataCell(
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _controller.deleteReporte(reportes.id);
                                  setState(() {
                                    _fetchReporte();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
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
              //Navigator.push(
                //context,
                //MaterialPageRoute(builder: (context) => const WorkOrderScreen()),
              //);
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
            tooltip: 'Nuevo Reporte',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _showSearchDialog,
            // ignore: sort_child_properties_last
            child: Icon(Icons.search, size: iconSize, color: Colors.black),
            tooltip: 'Buscar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              _refreshData();
            },
            tooltip: 'Refrescar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Imprimir',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.print, size: iconSize, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
