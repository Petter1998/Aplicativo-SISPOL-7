import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/reports/reports_controller.dart';
import 'package:sispol_7/models/reports/reports_model.dart';
import 'package:sispol_7/views/reports/reports_view.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class SearchReportView extends StatefulWidget {
  final List<Reportes> searchResults;

  const SearchReportView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchReportViewState createState() => _SearchReportViewState();
}

class _SearchReportViewState extends State<SearchReportView> {
  final ReportesController _controller = ReportesController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  List<Reportes> _reportes = [];
  // ignore: prefer_final_fields

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
                        pw.Text('Reporte de Ordenes de Trabajo Finalizadas de Mantenimiento', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                        pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                        pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text('Detalles de las ordenes de trabajo finalizadas en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 10),
                ],
              ),
              pw.TableHelper.fromTextArray(
                headers: <String>[
                  'ID', 'Fecha de \nSolicitud',
                  'Fecha de \nRegistro',
                  'Fecha de \nEntrega',
                  'Responsable que \nEntrega',
                  'Responsable que \nRetira',
                  'Kilometraje \nActual',
                  'Kilometraje \nPróximo \nMantenimiento',
                  'Tipo de \nMantenimiento',
                  'Mantenimiento \nComplementario',
                  'Observaciones',
                  'Fecha de \nCreación'],
                  data: _reportes.map((reportes) => [
                    reportes.id.toString(),
                    reportes.fechasol,
                    reportes.fechareg,
                    reportes.fechaentreg,
                    reportes.responsableentreg,
                    reportes.responsablereti,
                    reportes.kilometrajeActual.toString(),
                    reportes.kilometrajeProx.toString(),
                    reportes.tipoMant,
                    reportes.mantComple,
                    reportes.observaciones,
                    reportes.fechacrea != null ? dateFormat.format(reportes.fechacrea!) : 'N/A',
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
          rows: widget.searchResults.map((reportes) {
            return DataRow(cells: [
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
                      _buildCell(reportes.fechacrea != null ? dateFormat.format(reportes.fechacrea!) : 'N/A'),
              DataCell(
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _controller.deleteReporte(reportes.id);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ]);
          }).toList(),
        ),
      ),
    floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportesView()),
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