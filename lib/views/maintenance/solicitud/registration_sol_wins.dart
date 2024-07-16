import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:sispol_7/widgets/global/success_icon_animation.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class RegistrationWinsScreen extends StatelessWidget {
  RegistrationWinsScreen({super.key, required this.nombreCompleto, required this.solicitudData});
  final String nombreCompleto;
  final Map<String, dynamic> solicitudData;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
   
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
                      pw.Text('Solicitud de Mantenimiento', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Fecha: $formattedDate', style: const pw.TextStyle(fontSize: 12)),
                      pw.Text('Hora: $formattedTime', style: const pw.TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Detalles de la solicitud en Sispol - 7', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildRichText('Fecha: ', '${solicitudData['fecha']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Hora: ', '${solicitudData['hora']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Kilometraje Actual: ', '${solicitudData['kilometrajeActual']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Estado: ', '${solicitudData['estado']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Tipo: ', '${solicitudData['tipo']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Placa: ', '${solicitudData['placa']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Marca: ', '${solicitudData['marca']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Modelo: ', '${solicitudData['modelo']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Motor: ', '${solicitudData['motor']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Chasis: ', '${solicitudData['chasis']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Cilindraje: ', '${solicitudData['cilindraje']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Dependencia: ', '${solicitudData['dependencia']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Responsable: ', '${solicitudData['responsable']}'),
              pw.SizedBox(height: 14),
              _buildRichText('Observaciones: ', '${solicitudData['observaciones']}'),
              pw.SizedBox(height: 14),
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
      body: Center(
        child: Column (
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SuccessIconAnimation(), // Aquí se muestra el ícono animado
            const SizedBox(height: 100),
            Padding (
              padding: EdgeInsets.symmetric(horizontal: customPadding , vertical: 20), // Ajusta el padding para controlar el ancho
              child: RichText( // Usa RichText para combinar estilos
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: titleFontSize),
                  children: <TextSpan>[
                    const TextSpan(text: 'Estimado '),
                    TextSpan(
                      text: nombreCompleto,
                      style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' su solicitud de Mantenimiento para su vehículo ha sido registrada con éxito. \n \n \n Genere su solicitud de forma obligatoria e imprímalo, para la posterior orden de trabajo. \n !GRACIAS¡'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
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
                child: Text('Generar PDF', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
              ),
            ),
          ],
        ),   
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}