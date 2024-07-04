import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/models/documents/documents_model.dart';
import 'package:sispol_7/models/reports/reports_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class CompletReportView extends StatefulWidget {
  final Documentos documento;

  const CompletReportView({super.key, required this.documento});

  @override
  // ignore: library_private_types_in_public_api
  _CompletReportViewState createState() => _CompletReportViewState();
}

class _CompletReportViewState extends State<CompletReportView> {
  late TextEditingController _fechasolController;
  late TextEditingController _fecharegController;
  late TextEditingController _fechaentregController;
  late TextEditingController _responsableentregController;
  late TextEditingController _kilometrajeActualController;
  late TextEditingController _kilometrajeProxController;
  late TextEditingController _tipoMantController;
  late TextEditingController _mantCompleController;
  late TextEditingController _observacionesController;

  String? _selectedResponsablereti;
  List<String> responsablesRetira = [];

  @override
  void initState() {
    super.initState();
    _fechasolController = TextEditingController();
    _fecharegController = TextEditingController(text: widget.documento.fecha);
    _fechaentregController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(DateTime.now()));
    _responsableentregController = TextEditingController(text: widget.documento.responsable);
    _kilometrajeActualController = TextEditingController(text: widget.documento.kilometrajeActual.toString());
    _kilometrajeProxController = TextEditingController(
      text: (widget.documento.tipo == 'auto' || widget.documento.tipo == 'camioneta')
          ? (widget.documento.kilometrajeActual + 5000).toString()
          : (widget.documento.kilometrajeActual + 2000).toString()
    );
    _tipoMantController = TextEditingController(text: widget.documento.tipoMant);
    _mantCompleController = TextEditingController(text: widget.documento.mantComple);
    _observacionesController = TextEditingController();

    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch data from solicitud_mantenimiento
      QuerySnapshot solicitudSnapshot = await FirebaseFirestore.instance
          .collection('solicitud_mantenimiento')
          .where('placa', isEqualTo: widget.documento.placa)
          .where('responsable', isEqualTo: widget.documento.responsable)
          .get();

      if (solicitudSnapshot.docs.isNotEmpty) {
        var solicitudData = solicitudSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          if (solicitudData['fechaCreacion'] is Timestamp) {
            _fechasolController.text = (solicitudData['fechaCreacion'] as Timestamp).toDate().toString();
          } else {
            _fechasolController.text = '';
          }
        });
      }

      // Fetch responsables from vehiculos
      QuerySnapshot vehiculoSnapshot = await FirebaseFirestore.instance
          .collection('vehiculos')
          .where('placa', isEqualTo: widget.documento.placa)
          .get();

      if (vehiculoSnapshot.docs.isNotEmpty) {
        var vehiculoData = vehiculoSnapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          responsablesRetira = [
            if (vehiculoData['responsable1'] != null && vehiculoData['responsable1'] != 'N/A') vehiculoData['responsable1'].toString(),
            if (vehiculoData['responsable2'] != null && vehiculoData['responsable2'] != 'N/A') vehiculoData['responsable2'].toString(),
            if (vehiculoData['responsable3'] != null && vehiculoData['responsable3'] != 'N/A') vehiculoData['responsable3'].toString(),
            if (vehiculoData['responsable4'] != null && vehiculoData['responsable4'] != 'N/A') vehiculoData['responsable4'].toString(),
          ].where((responsable) => responsable.isNotEmpty).toList();
        });
      }
    } catch (e) {
      // Maneja cualquier error que ocurra durante la obtención de datos
      // ignore: avoid_print
      print("Error fetching data: $e");
    }
  }

  @override
  void dispose() {
    _fechasolController.dispose();
    _fecharegController.dispose();
    _fechaentregController.dispose();
    _responsableentregController.dispose();
    _kilometrajeActualController.dispose();
    _kilometrajeProxController.dispose();
    _tipoMantController.dispose();
    _mantCompleController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  Future<void> _saveReport() async {
    final newReport = Reportes(
      id: widget.documento.id,
      fechasol: _fechasolController.text,
      fechareg: _fecharegController.text,
      fechaentreg: _fechaentregController.text,
      responsableentreg: _responsableentregController.text,
      responsablereti: _selectedResponsablereti ?? '',
      kilometrajeActual: int.parse(_kilometrajeActualController.text),
      kilometrajeProx: int.parse(_kilometrajeProxController.text),
      tipoMant: _tipoMantController.text,
      mantComple: _mantCompleController.text,
      observaciones: _observacionesController.text,
      fechacrea: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('reportes')
        .doc(newReport.id.toString())
        .set(newReport.toMap());

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth < 480 ? 100.0 :(screenWidth > 1000 ? 200 : 150);
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

    double horizontalPadding = screenWidth < 800 ? screenWidth * 0.05 : screenWidth * 0.20;
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90.0),
                    child: Icon(
                      Icons.library_books_outlined,
                      size: imageSize,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _fechasolController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Solicitud',
                      hintText: 'Fecha de Solicitud',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _fecharegController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Registro',
                      hintText: 'Fecha de Registro',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _fechaentregController,
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Entrega',
                      hintText: 'Fecha de Entrega',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _responsableentregController,
                    decoration: const InputDecoration(
                      labelText: 'Responsable Entrega',
                      hintText: 'Responsable Entrega',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  DropdownButtonFormField<String>(
                    value: _selectedResponsablereti,
                    hint: Text('Responsable Retira', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Responsable Retira',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedResponsablereti = newValue;
                      });
                    },
                    items: responsablesRetira.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _kilometrajeActualController,
                    decoration: const InputDecoration(
                      labelText: 'Kilometraje Actual',
                      hintText: 'Kilometraje Actual',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _kilometrajeProxController,
                    decoration: const InputDecoration(
                      labelText: 'Kilometraje Próximo Mantenimiento',
                      hintText: 'Kilometraje Próximo Mantenimiento',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _tipoMantController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Mantenimiento',
                      hintText: 'Tipo de Mantenimiento',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _mantCompleController,
                    decoration: const InputDecoration(
                      labelText: 'Mantenimiento Complementario',
                      hintText: 'Mantenimiento Complementario',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  TextField(
                    controller: _observacionesController,
                    decoration: const InputDecoration(
                      labelText: 'Observaciones',
                      hintText: 'Observaciones',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: vertiSpacing),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                      ),
                      onPressed: _saveReport,
                      child: Text(
                        'Guardar cambios',
                        style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }
}
