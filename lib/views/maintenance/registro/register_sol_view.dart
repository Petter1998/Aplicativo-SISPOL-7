import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/controllers/maintenance/validation_controller.dart';
import 'package:sispol_7/views/maintenance/solicitud/validation_screen.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class RegisterSolView extends StatefulWidget {
  const RegisterSolView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterSolViewState createState() => _RegisterSolViewState();
}

class _RegisterSolViewState extends State<RegisterSolView> {
  final ValidationController controller = ValidationController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final TextEditingController _searchController = TextEditingController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late Future<List<Map<String, dynamic>>> _solicitudesFuture;
  List<int> _selectedSoli = [];

  @override
  void initState() {
    super.initState();
    _solicitudesFuture = controller.fetchSolicitudes();
  }

  void _refreshData() {
    setState(() {
      _solicitudesFuture = controller.fetchSolicitudes();
    });
  }
  
  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación de Eliminación'),
          content: const Text('¿Está seguro de que desea eliminar esta solicitud?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () async {
                try {
                  await controller.deleteSolicitud(id);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Solicitud eliminada exitosamente')),
                  );
                  _refreshData();
                } catch (error) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al eliminar la solicitud: $error')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar por Placa'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Placa',
              hintText: 'Ingrese la placa del vehículo',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Buscar'),
              onPressed: () {
                setState(() {
                  _solicitudesFuture = controller.searchSolicitudesByPlaca(_searchController.text.trim());
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _aprobaSoli() async {
    for (int id in _selectedSoli) {
      await controller.soliCollection.doc(id.toString()).update({'estado': 'Aprobada'});
    }
    setState(() {
      _selectedSoli.clear();
    });
    _refreshData();
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/Escudo.jpg')).buffer.asUint8List(),
    );
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    final formattedTime = DateFormat('HH:mm:ss').format(currentDate);
    // Esperar a que el Future se complete y obtener los datos
    final solicitudes = await _solicitudesFuture;

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
                      pw.Text('Reporte de Solicitudes de Mantenimiento', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                      pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Detalles de las solicitudes  en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: <String>[
                  'ID', 'Fecha', 'Hora', 'Estado', 'Kilometraje Actual', 'Chasis', 'Cilindraje', 'Dependencia',
                  'Marca', 'Modelo', 'Motor', 'Placa', 'Responsable', 'Observaciones', 'Tipo', 'Fecha de Creación',
                ],
                data: solicitudes.map((solicitud) => [
                  solicitud['id'].toString(),
                  solicitud['fecha'],
                  solicitud['hora'],
                  solicitud['estado'],
                  solicitud['kilometrajeActual'],
                  solicitud['chasis'],
                  solicitud['cilindraje'].toString(),
                  solicitud['dependencia'],
                  solicitud['marca'],
                  solicitud['modelo'],
                  solicitud['motor'],
                  solicitud['placa'],
                  solicitud['responsable'],
                  solicitud['observaciones'],
                  solicitud['tipo'],
                  solicitud['fechaCreacion'] != null
                      ? _dateFormat.format((solicitud['fechaCreacion'] as Timestamp).toDate())
                      : 'N/A',
                ]).toList(),
                cellStyle: const pw.TextStyle(fontSize: 7),
                headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.center,
              ),
            ],
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
          // ignore: unnecessary_null_comparison
          text != null ? text.toString() : 'N/A',
          style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black),
        ),
      );
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _solicitudesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final solicitudes = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Checkbox(
                    value: _selectedSoli.length == solicitudes.length && solicitudes.isNotEmpty,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSoli = solicitudes.map<int>((doc) => doc['id'] as int).toList();
                        } else {
                          _selectedSoli.clear();
                        }
                      });
                    },
                  )),
                  _buildColumn('ID'),
                  _buildColumn('Fecha'),
                  _buildColumn('Hora'),
                  _buildColumn('Estado'),
                  _buildColumn('Kilometraje Actual'),
                  _buildColumn('Chasis'),
                  _buildColumn('Cilindraje'),
                  _buildColumn('Dependencia'),
                  _buildColumn('Marca'),
                  _buildColumn('Modelo'),
                  _buildColumn('Motor'),
                  _buildColumn('Placa'),
                  _buildColumn('Responsable'),
                  _buildColumn('Observaciones'),
                  _buildColumn('Tipo'),
                  _buildColumn('Fecha de Creación'),
                  _buildColumn('Opciones'),
                ],
                rows: solicitudes.map((solicitud) {
                  return DataRow(
                    selected: _selectedSoli.contains(solicitud['id']),
                    onSelectChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedSoli.add(solicitud['id']);
                        } else {
                          _selectedSoli.remove(solicitud['id']);
                        }
                      });
                    },
                    cells: [
                      DataCell(
                        Checkbox(
                          value: _selectedSoli.contains(solicitud['id']),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedSoli.add(solicitud['id']);
                              } else {
                                _selectedSoli.remove(solicitud['id']);
                              }
                            });
                          },
                        ),
                      ),
                    _buildCell(solicitud['id'].toString()),
                    _buildCell(solicitud['fecha']),
                    _buildCell(solicitud['hora']),
                    _buildCell(solicitud['estado']),
                    _buildCell(solicitud['kilometrajeActual']),
                    _buildCell(solicitud['chasis']),
                    _buildCell(solicitud['cilindraje'].toString()),
                    _buildCell(solicitud['dependencia']),
                    _buildCell(solicitud['marca']),
                    _buildCell(solicitud['modelo']),
                    _buildCell(solicitud['motor']),
                    _buildCell(solicitud['placa']),
                    _buildCell(solicitud['responsable']),
                    _buildCell(solicitud['observaciones']),
                    _buildCell(solicitud['tipo']),
                    _buildCell(solicitud['fechaCreacion'] != null
                        ? _dateFormat.format((solicitud['fechaCreacion'] as Timestamp).toDate())
                        : 'N/A'),
                    DataCell(
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteDialog(context, solicitud['id']);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
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
               MaterialPageRoute(builder: (context) => ValidationScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.assignment_add, size: iconSize,color:  Colors.black),
            tooltip: 'Nueva Solicitud',
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
            tooltip: 'Refrescar o Regresar',
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
            onPressed: _aprobaSoli,
            tooltip: 'Aprobar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.task_rounded, size: iconSize,color:  Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}