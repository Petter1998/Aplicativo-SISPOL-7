import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/documents/documents_controller.dart';
import 'package:sispol_7/models/documents/documents_model.dart';
import 'package:sispol_7/views/documents/documents_view.dart';
import 'package:sispol_7/views/documents/work_order.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

// ignore: must_be_immutable
class SearchOrderView extends StatefulWidget {
  final List<Documentos> searchResults;

  const SearchOrderView({super.key, required this.searchResults});

  @override
  // ignore: library_private_types_in_public_api
  _SearchOrderViewState createState() => _SearchOrderViewState();
}

class _SearchOrderViewState extends State<SearchOrderView> {
  final DocumentosController2 _controller = DocumentosController2();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // ignore: unused_field
  List<Documentos> _documentos = [];
  // ignore: prefer_final_fields
  List<int> _selectedDocuments = [];

  @override
  void initState() {
    super.initState();
    _fetchDocumentos();
  }

  void _fetchDocumentos() async {
    List<Documentos> documentos = await _controller.fetchDocumentos();
    setState(() {
      _documentos= documentos;
    });
  }

  void _refreshData() {
    _fetchDocumentos();
  }

  void _finalizeDocuments() async {
    for (int id in _selectedDocuments) {
      await _controller.ordenCollection.doc(id.toString()).update({'estado': 'Finalizada'});
      // Buscar el documento correspondiente al id
      // ignore: unused_local_variable
      Documentos documento = _documentos.firstWhere((doc) => doc.id == id);
      
      // Navegar a CompletReportView con el documento seleccionado
      // ignore: use_build_context_synchronously
    }
    setState(() {
      _selectedDocuments.clear();
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
                        pw.Text('Reporte de Ordenes de Tabajo para Mantenimiento', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
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
                  'ID', 'Fecha',
                  'Hora',
                  'Kilometraje \nActual',
                  'Estado',
                  'Tipo',
                  'Placa',
                  //'Marca',
                  //'Modelo',
                  'Cédula',
                  'Responsable',
                  //'Asunto',
                  //'Detalle',
                  'Tipo de \nMantenimiento',
                  'Mantenimiento \nComplementario',
                  'Total',
                  'Fecha de \nCreación'],
                  data: widget.searchResults.map((documentos) => [
                    documentos.id.toString(),
                    documentos.fecha.toString(),
                    documentos.hora,
                    documentos.kilometrajeActual.toString(),
                    documentos.estado,
                    documentos.tipo,
                    documentos.placa,
                    //documentos.marca,
                    //documentos.modelo,
                    documentos.cedula,
                    documentos.responsable,
                    //documentos.asunto,
                    //documentos.detalle,
                    documentos.tipoMant,
                    documentos.mantComple,
                    documentos.total.toString(),
                    documentos.fechacrea != null
                        ? dateFormat.format(documentos.fechacrea!)
                        : 'N/A',
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
            DataColumn(label: Checkbox(
                    value: _selectedDocuments.length == widget.searchResults.length && widget.searchResults.isNotEmpty,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedDocuments = widget.searchResults.map((doc) => doc.id).toList();
                        } else {
                          _selectedDocuments.clear();
                        }
                      });
                    },
                  )),
                  _buildColumn('ID'),
                  _buildColumn('Fecha'),
                  _buildColumn('Hora'),
                  _buildColumn('Kilometraje \nActual'),
                  _buildColumn('Estado'),
                  _buildColumn('Tipo'),
                  _buildColumn('Placa'),
                  _buildColumn('Marca'),
                  _buildColumn('Modelo'),
                  _buildColumn('Cédula'),
                  _buildColumn('Responsable'),
                  _buildColumn('Asunto'),
                  _buildColumn('Detalle'),
                  _buildColumn('Tipo de Mantenimiento'),
                  _buildColumn('Mantenimiento Complementario'),
                  _buildColumn('Total'),
                  _buildColumn('Fecha de \nCreación'),
                  _buildColumn('Opciones'),
                  ],
          rows: widget.searchResults.map((documentos) {
            return DataRow(
              selected: _selectedDocuments.contains(documentos.id),
              onSelectChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedDocuments.add(documentos.id);
                  } else {
                    _selectedDocuments.remove(documentos.id);
                  }
                });
              },
              cells: [
                DataCell(Checkbox(
                  value: _selectedDocuments.contains(documentos.id),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedDocuments.add(documentos.id);
                      } else {
                        _selectedDocuments.remove(documentos.id);
                      }
                    });
                  },
                )),
                _buildCell(documentos.id.toString()),
                _buildCell(documentos.fecha.toString()),
                _buildCell(documentos.hora),
                _buildCell(documentos.kilometrajeActual.toString()),
                _buildCell(documentos.estado),
                _buildCell(documentos.tipo),
                _buildCell(documentos.placa),
                _buildCell(documentos.marca),
                _buildCell(documentos.modelo),
                _buildCell(documentos.cedula),
                _buildCell(documentos.responsable),
                _buildCell(documentos.asunto),
                _buildCell(documentos.detalle),
                _buildCell(documentos.tipoMant),
                _buildCell(documentos.mantComple),
                _buildCell(documentos.total.toString()),
                _buildCell(documentos.fechacrea != null
                    ? dateFormat.format(documentos.fechacrea!)
                    : 'N/A'),
              DataCell(
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          _controller.deleteDoc(documentos.id);
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
              Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const WorkOrderScreen()),
              );
            },
            // ignore: sort_child_properties_last
            child: Icon(Icons.add, size: iconSize,color:  Colors.black),
            tooltip: 'Nueva Orden de Trabajo',
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
          const SizedBox(width: 20),

          FloatingActionButton(
            onPressed: _finalizeDocuments,
            tooltip: 'Finalizar',
            backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
            child: Icon(Icons.task_rounded, size: iconSize,color:  Colors.black),
          ),

          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DocumentosView()),
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