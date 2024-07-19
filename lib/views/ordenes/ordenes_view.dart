import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/controllers/ordenes/ordenes_controller.dart';
import 'package:sispol_7/models/ordenes/ordenes_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class OrdenesView extends StatefulWidget {
  const OrdenesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrdenesViewState createState() => _OrdenesViewState();
}

class _OrdenesViewState extends State<OrdenesView> {
  final OrdenController _controller = OrdenController();

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  List<Orden> _ordenes = [];
  List<int> _selectedOrdenes = [];

  @override
  void initState() {
    super.initState();
    _fetchOrdenes();
  }

  void _fetchOrdenes() async {
    List<Orden> ordenes = await _controller.fetchOrdenes();
    setState(() {
      _ordenes = ordenes;
    });
  }

  void _refreshData() {
    _fetchOrdenes();
  }

  void _showSearchDialog() {
    String query = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Buscar Orden de Trabajo',
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
                decoration: const InputDecoration(hintText: "Ingrese la placa"),
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
                List<Orden> results = await _controller.searchOrden(query);
                if (results.isEmpty) {
                  _showNoResultsAlert();
                } else {
                  // ignore: use_build_context_synchronously
                  //Navigator.of(context).push(
                    //MaterialPageRoute(
                      //builder: (context) => SearchOrdenView(searchResults: results),
                    //),
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
          title: Text(
            'No se encontraron resultados',
            style: GoogleFonts.inter(color: Colors.black),
          ),
          content: Text(
            'No se encontró ninguna Orden de Trabajo con esos valores.',
            style: GoogleFonts.inter(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _finalizeOrdenes() async {
    for (int id in _selectedOrdenes) {
      await _controller.ordenCollection.doc(id.toString()).update({'estado': 'Finalizada'});
      //Orden orden = _ordenes.firstWhere((doc) => doc.id == id);

      //Navigator.of(context).push(
       // MaterialPageRoute(
          //builder: (context) => CompletReportView(orden: orden),
       // ),
      //);
    }
    setState(() {
      _selectedOrdenes.clear();
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
                      pw.Text('Reporte de Ordenes de Trabajo para Mantenimiento', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                      pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Detalles de las ordenes de trabajo en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
            ],
          ),
          pw.TableHelper.fromTextArray(
            headers: <String>[
              'ID',
              'Fecha de Emisión',
              'Personal que Emite',
              'Personal del Vehículo',
              'Estado',
              'Vehículo',
              'Lubricantes',
              'Repuestos',
            ],
            data: _ordenes.map((orden) => [
              orden.id.toString(),
              orden.fechaEmision,
              orden.personalEmite,
              orden.personalVehiculo,
              orden.estado,
              orden.vehiculo,
              orden.lubricantes ?? 'N/A',
              orden.repuestos ?? 'N/A',
              
            ]).toList(),
            cellStyle: const pw.TextStyle(fontSize: 7), // Reduce el tamaño de la fuente de los datos
            headerStyle: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold), // Aplica fontWeight.bold a los encabezados
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

    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 20 : 22);
    double bodyFontSize = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 18 : 20);
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
      body: FutureBuilder<List<Orden>>(
        future: _controller.fetchOrdenes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final ordenes = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Checkbox(
                    value: _selectedOrdenes.length == ordenes.length && ordenes.isNotEmpty,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedOrdenes = ordenes.map((orden) => orden.id).toList();
                        } else {
                          _selectedOrdenes.clear();
                        }
                      });
                    },
                  )),
                  _buildColumn('ID'),
                  _buildColumn('Fecha de Emisión'),
                  _buildColumn('Personal que Emite'),
                  _buildColumn('Personal del Vehículo'),
                  _buildColumn('Estado'),
                  _buildColumn('Vehículo'),
                  _buildColumn('Lubricantes'),
                  _buildColumn('Repuestos'),
                  _buildColumn('Opciones'),
                ],
                rows: ordenes.map((orden) {
                  return DataRow(
                    selected: _selectedOrdenes.contains(orden.id),
                    onSelectChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          _selectedOrdenes.add(orden.id);
                        } else {
                          _selectedOrdenes.remove(orden.id);
                        }
                      });
                    },
                    cells: [
                      DataCell(Checkbox(
                        value: _selectedOrdenes.contains(orden.id),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              _selectedOrdenes.add(orden.id);
                            } else {
                              _selectedOrdenes.remove(orden.id);
                            }
                          });
                        },
                      )),
                      _buildCell(orden.id.toString()),
                      _buildCell(orden.fechaEmision),
                      _buildCell(orden.personalEmite),
                      _buildCell(orden.personalVehiculo),
                      _buildCell(orden.estado),
                      _buildCell(orden.vehiculo),
                      _buildCell(orden.lubricantes ?? 'N/A'),
                      _buildCell(orden.repuestos ?? 'N/A'),
                      DataCell(
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _controller.deleteOrden(orden.id);
                                  setState(() {
                                    _fetchOrdenes();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
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
             // Navigator.push(
               // context,
                //MaterialPageRoute(builder: (context) => const WorkOrderScreen()),
             // );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
            tooltip: 'Nueva Orden de Trabajo',
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
            onPressed: _refreshData,
            tooltip: 'Refrescar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _generatePDF,
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _finalizeOrdenes,
            tooltip: 'Finalizar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.task_rounded, size: iconSize, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
