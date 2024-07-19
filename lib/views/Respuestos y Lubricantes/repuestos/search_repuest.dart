import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/repuestos/repuests_controller.dart';
import 'package:sispol_7/models/repuestos/repuest_model.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/repuestos/edit_repuest.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/repuestos/regist_repuest.dart';
import 'package:sispol_7/views/Respuestos%20y%20Lubricantes/repuestos/repuests_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

// ignore: must_be_immutable
class SearchRepuestView extends StatefulWidget {
  final List<Repuest> searchResults;

  const SearchRepuestView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchRepuestViewState createState() => _SearchRepuestViewState();
}

class _SearchRepuestViewState extends State<SearchRepuestView> {
  final RepuestoController _controller = RepuestoController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  void _fetchRepuesto() async {
    setState(() {});
  }

  void _refreshData() {
    _fetchRepuesto();
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
             'ID', 'ID Emisor', 'Nombre', 'Fecha de Ingreso', 'Categoría', 'Marca', 'Modelo', 'Proveedor', 'Precio', 'Stock'],
            data: widget.searchResults.map((repuesto) => [
              repuesto.id.toString(),
                    repuesto.idUser.toString(),
                    repuesto.nombre,
                    dateFormat.format(repuesto.fechaIngreso),
                    repuesto.categoria,
                    repuesto.marca,
                    repuesto.modelo,
                    repuesto.proveedor,
                    repuesto.precio.toString(),
                    repuesto.stock.toString(),
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

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            _buildColumn('ID'),
            _buildColumn('ID \nEmisor'),
            _buildColumn('Nombre'),
            _buildColumn('Fecha \nIngreso'),
            _buildColumn('Categoría'),
            _buildColumn('Marca'),
            _buildColumn('Modelo'),
            _buildColumn('Proveedor'),
            _buildColumn('Precio'),
            _buildColumn('Stock'),
            _buildColumn('Opciones'),
          ],
          rows: widget.searchResults.map((repuesto) {
            return DataRow(cells: [
              _buildCell(repuesto.id.toString()),
              _buildCell(repuesto.idUser.toString()),
              _buildCell(repuesto.nombre),
              _buildCell(dateFormat.format(repuesto.fechaIngreso)),
              _buildCell(repuesto.categoria),
              _buildCell(repuesto.marca),
              _buildCell(repuesto.modelo),
              _buildCell(repuesto.proveedor),
              _buildCell(repuesto.precio.toString()),
              _buildCell(repuesto.stock.toString()),
              DataCell(Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditRepuestScreen(repuesto: repuesto),
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _controller.deleteRepuesto(repuesto.id);
                      setState(() {
                        _refreshData();
                      });
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
                MaterialPageRoute(builder: (context) => const RegistRepuestScreen()),
              );
            },
            tooltip: 'Registrar un Nuevo Repuesto',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.add, size: iconSize, color: Colors.black),
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
            onPressed: () {
              _refreshData();
            },
            tooltip: 'Refrescar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.refresh, size: iconSize, color: Colors.black),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RepuestsView()),
              );
            },
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.arrow_back, size: iconSize, color: Colors.black),
          ),
        ],
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
