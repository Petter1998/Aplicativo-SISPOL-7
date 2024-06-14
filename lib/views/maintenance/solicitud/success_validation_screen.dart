import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sispol_7/views/maintenance/solicitud/registration_soli_view.dart';
import 'package:sispol_7/views/maintenance/solicitud/validation_screen.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class VehicleInfoScreen extends StatelessWidget {
  final DocumentSnapshot<Map<String, dynamic>> vehicleDoc;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final String nombreCompleto;

  VehicleInfoScreen({super.key, required this.vehicleDoc, required this.nombreCompleto});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = vehicleDoc.data()!;
    double screenWidth = MediaQuery.of(context).size.width;
    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 20 : 22);
    double bodyFontSize = screenWidth < 600 ? 15 : (screenWidth < 1200 ? 18 : 20);
    double customPadding = screenWidth > 1000 ? 300 : 20;
    // Determinar el espacio vertical para botones basado en el ancho de la pantalla
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

    return Scaffold(
    key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Center (
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: customPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: titleFontSize, color: Colors.black),
                    children: <TextSpan>[
                      const TextSpan(text: 'Estimado '),
                      TextSpan(text: nombreCompleto, 
                      style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ', el vehículo a su cargo es:'),
                    ],
                  ),
                ),
                SizedBox(height: vertiSpacing),
                 Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FixedColumnWidth(210),
                    1: FlexColumnWidth(),
                  },
                  children: [
                    _buildTableRow('Tipo', data['tipo'],titleFontSize, bodyFontSize),
                    _buildTableRow('Placa', data['placa'],titleFontSize, bodyFontSize),
                    _buildTableRow('Chasis', data['chasis'],titleFontSize, bodyFontSize),
                    _buildTableRow('Marca', data['marca'],titleFontSize, bodyFontSize),
                    _buildTableRow('Modelo', data['modelo'],titleFontSize, bodyFontSize),
                    _buildTableRow('Motor', data['motor'].toString(),titleFontSize, bodyFontSize),
                    _buildTableRow('Kilometraje (km)', data['kilometraje'].toString(),titleFontSize, bodyFontSize),
                    _buildTableRow('Cilindraje (cc)', data['cilindraje'].toString(),titleFontSize, bodyFontSize),
                    _buildTableRow('Dependencia', data['dependencia'],titleFontSize, bodyFontSize),
                  ],
                ),
                //SizedBox(height: vertiSpacing),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
              ),
              child:Text('Confirmar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)), 
              onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationSoliScreen(
                        vehicleDoc: vehicleDoc,
                        nombreCompleto: nombreCompleto,
                      ),
                    ),
                  );
              },
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
              ),
              child:Text('Regresar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)), 
              onPressed: () async {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                      builder: (context) => ValidationScreen(),
                    ),
                );
              }
            ),
          ],
        ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }

  TableRow _buildTableRow(String label, String value, double titleFontSize, double bodyFontSize) {
    return TableRow(
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          color: const Color.fromRGBO(15, 57, 155, 1),
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          color: Colors.white,
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
