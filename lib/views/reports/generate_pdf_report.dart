import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/administration/floating_report.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class GeneratePDFReport extends StatelessWidget {
  GeneratePDFReport({super.key});

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _generatePDF(BuildContext context) async {
    final pdf = pw.Document();
    final logoImage = pw.MemoryImage(
      (await rootBundle.load('assets/images/Escudo.jpg')).buffer.asUint8List(),
    );
    final currentDate = DateTime.now();
    final formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
    final formattedTime = DateFormat('HH:mm:ss').format(currentDate);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.portrait,
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
                      pw.Text('Orden de Trabajo Finalizada de Mantenimiento', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                      pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Formato Manual de Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildRichText('Fecha de Solicitud: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Fecha de Registro: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Fecha de Entrega del Vehículo: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Responsable que entregó el vehículo: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Responsable que retira el vehículo: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Kilometraje Actual: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Kilometraje para el Próximo Mantenimiento: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Tipo de Mantenimiento: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Mantenimiento Complementario: ', '________________________'),
              pw.SizedBox(height: 14),
              _buildRichText('Observaciones: ', '________________________'),
              pw.SizedBox(height: 30),
              pw.Divider(),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Firma:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.Container(
                    width: 200,
                    child: pw.Divider(),
                  ),
                ],
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

  pw.Widget _buildRichText(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        children: [
          pw.TextSpan(text: label, style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.TextSpan(text: value, style: const pw.TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 34 : 28);
    // Establecer el padding basado en el ancho de la pantalla
    double customPadding = screenWidth > 1000 ? 250 : 20;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      floatingActionButton: const MyUSER24(),
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding (
              padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20), // Ajusta el padding para controlar el ancho
              child: Text(
                'Aquí podrá generar el PDF del formato de Reporte de Mantenimiento',
                style: 
                GoogleFonts.inter(fontSize: titleFontSize),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                  
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                ),
                onPressed: () => _generatePDF(context),
                child: Text('Generar Formato de Reporte(PDF)', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
              ),
            ),
          ],
        ),   
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}