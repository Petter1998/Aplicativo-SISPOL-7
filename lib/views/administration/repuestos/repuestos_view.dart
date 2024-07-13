import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/repuestos/repuestos_controller.dart';
import 'package:sispol_7/models/administration/repuestos/repuestos_model.dart';
import 'package:sispol_7/views/administration/repuestos/edit_repuesto_view.dart';
import 'package:sispol_7/views/administration/repuestos/regist_repuestos_view.dart';
import 'package:sispol_7/views/administration/repuestos/search_repuestos_view.dart';
import 'package:pdf/pdf.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class RepuestosView extends StatefulWidget {
  const RepuestosView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RepuestosViewState createState() => _RepuestosViewState();
}

class _RepuestosViewState extends State<RepuestosView> {
  final RepuestosController _controller = RepuestosController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_field
  List<Repuesto> _repuestos = [];

  @override
  void initState() {
    super.initState();
    _fetchRepuesto();
  }

  void _fetchRepuesto() async {
    List<Repuesto> repuestos = await _controller.fetchRepuesto();
    setState(() {
      _repuestos = repuestos;
    });
  }

  void _refreshData() {
    _fetchRepuesto();
  }

  void _showSearchDialog() {
    String query = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buscar Repuesto',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          content: TextField(
            onChanged: (value) {
              query = value;
            },
            decoration: const InputDecoration(hintText: "Ingrese el nombre del repuesto"),
            style: GoogleFonts.inter(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Buscar',
                style: GoogleFonts.inter(color: Colors.black),
              ),
              onPressed: () async {
                List<Repuesto> results = await _controller.searchRepuestos(query);
                if (results.isEmpty) {
                  _showNoResultsAlert();
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchRepuestosView(searchResults: results),
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
            style: GoogleFonts.inter(color: Colors.black),
          ),
          content: Text('No se encontró ningún repuesto con ese nombre.',
            style: GoogleFonts.inter(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
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
                        pw.Text('Reporte de Repuestos', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Detalles de los Repuestos en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ],
              ),
              pw.TableHelper.fromTextArray(
                headers: <String>[
                  'ID', 'Fecha de Creación','Nombre',
                  'Fecha \nAdquisición',
                  'Tipo de \nContrato',
                  'Modelo',
                  'Marca',
                  'Ubicación \nen Almacén',
                  'Precio \nde Compra',
                  'Cantidad'],
                  data: _repuestos.map((repuesto) => [
                    repuesto.id.toString(),
                    repuesto.fechacrea != null ? _dateFormat.format(repuesto.fechacrea!) : 'N/A',
                    repuesto.nombre,
                    repuesto.fechaadqui,
                    repuesto.contrato,
                    repuesto.modelo,
                    repuesto.marca,
                    repuesto.ubicacion,
                    repuesto.precio.toString(),
                    repuesto.cantidad.toString(),
                    
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
      body: FutureBuilder<List<Repuesto>>(
        future: _controller.fetchRepuesto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final repuestos = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  _buildColumn('ID'),
                  _buildColumn('Nombre'),
                  _buildColumn('Fecha \nAdquisición'),
                  _buildColumn('Tipo de \nContrato'),
                  _buildColumn('Modelo'),
                  _buildColumn('Marca'),
                  _buildColumn('Ubicación \nen Almacén'),
                  _buildColumn('Precio \nde Compra'),
                  _buildColumn('Cantidad'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                ],
                rows: repuestos.map((repuesto) {
                  return DataRow(cells: [
                    _buildCell(repuesto.id.toString()),
                    _buildCell(repuesto.nombre),
                    _buildCell(repuesto.fechaadqui),
                    _buildCell(repuesto.contrato),
                    _buildCell(repuesto.modelo),
                    _buildCell(repuesto.marca),
                    _buildCell(repuesto.ubicacion),
                    _buildCell(repuesto.precio.toString()),
                    _buildCell(repuesto.cantidad.toString()),
                    _buildCell(repuesto.fechacrea != null ? _dateFormat.format(repuesto.fechacrea!) : 'N/A'),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditRepuestoScreen(repuesto: repuesto),
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _controller.deleteRepuesto(repuesto.id);
                            setState(() {
                              _fetchRepuesto();
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
                MaterialPageRoute(builder: (context) => const RegistRepuestoScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Repuesto',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              _showSearchDialog();
            },
            tooltip: 'Buscar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.search, size: iconSize, color: Colors.black),
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
            onPressed: _generatePDF,
            tooltip: 'Generar PDF',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.picture_as_pdf, size: iconSize, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
