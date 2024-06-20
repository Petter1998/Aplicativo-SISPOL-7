import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/contratos/contrato_controller.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class RegistContratoScreen extends StatefulWidget {
  const RegistContratoScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistContratoScreenState createState() => _RegistContratoScreenState();
}

class _RegistContratoScreenState extends State<RegistContratoScreen> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _fechainicioController = TextEditingController();
  final TextEditingController _fechafinController = TextEditingController();
  final TextEditingController _tipocontratoController = TextEditingController();
  final TextEditingController _proveedorController = TextEditingController();
  final TextEditingController _tiporepuestosController = TextEditingController();
  final TextEditingController _vehiculoscubiertosController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final ContratosController _contratoController = ContratosController();

  String? _selectedTipo;
  final List<String> tipos = ['Auto', 'Motocicleta', 'Camioneta', 'Todos'];

  String? _selectedRepuestos;
  final List<String> repuest = ['Motor', 'Transmisión', 'Suspensión y Dirección',
   'Frenos', 'Eléctricos y Electrónicos', 'Carrocería y Exterior', 'Neumáticos y Llantas', 
   'Interior', 'Todos los Repuestos'
  ];

  String? _selectedContrat;
  final List<String> contrat = ['Suministro', 'Mantenimiento', 'Concesión', 'Abierto', 'Renting'];

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageSize = screenWidth < 480 ? 100.0 :(screenWidth > 1000 ? 200 : 150);

    // Determinar el tamaño de la fuente basado en el ancho de la pantalla
    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);

    // Determinar el espacio vertical basado en el ancho de la pantalla
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);
    // Determinar el espacio vertical para botones basado en el ancho de la pantalla
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);

    double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    // Establecemos el padding basado en el ancho de la pantalla
    double horizontalPadding;
    if (screenWidth < 800) {
      horizontalPadding = screenWidth * 0.05; // 5% del ancho si es menor a 800 px
    } else {
      horizontalPadding = screenWidth * 0.20; // 20% del ancho si es mayor o igual a 800 px
    }

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
                      Icons.handshake_outlined,
                      size: imageSize,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _nombreController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre del Contrato',
                                hintText: 'Nombre del Contrato',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _proveedorController,
                              decoration: const InputDecoration(
                                labelText: 'Proveedor',
                                hintText: 'Proveedor',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            DropdownButtonFormField<String>(
                              value: _selectedRepuestos,
                              hint: Text('Tipo de Repuestos', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Repuestos',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRepuestos = newValue;
                                  _tiporepuestosController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: repuest.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),

                            DropdownButtonFormField<String>(
                              value: _selectedTipo,
                              hint: Text('Vehículos Cubiertos', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Vehículos Cubiertos',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTipo = newValue;
                                  _vehiculoscubiertosController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: tipos.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: _fechainicioController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Inicio',
                                hintText: 'Fecha de Inicio',
                                fillColor: Colors.black,
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _fechainicioController.text = _dateFormat.format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _fechafinController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Finalización',
                                hintText: 'Fecha de Finalización',
                                fillColor: Colors.black,
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.calendar_today),
                                  onPressed: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime(2100),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _fechafinController.text = _dateFormat.format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),

                            DropdownButtonFormField<String>(
                              value: _selectedContrat,
                              hint: Text('Tipo de Contrato', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Contrato',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedContrat = newValue;
                                  _tipocontratoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: contrat.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),

                            TextField(
                              controller: _montoController,
                              decoration: const InputDecoration(
                                labelText: 'Monto',
                                hintText: 'Monto',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: verticalSpacing),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
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
                      onPressed: () {
                        _registerContrato();
                      },
                      child: Text('Registrar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold, color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
        child: Icon(Icons.arrow_back, size: iconSize, color: Colors.black),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }

  void _registerContrato() {
    // Recoge los datos del formulario y los pasa al controlador
    Map<String, dynamic> contData = {
      'nombreContrato': _nombreController.text,
      'fechaInicio': _fechainicioController.text,
      'fechaFinal': _fechafinController.text,
      'tipoContrato': _tipocontratoController.text,
      'proveedor': _proveedorController.text,
      'tipoRepuestos': _tiporepuestosController.text,
      'vehiculosCubiertos': _vehiculoscubiertosController.text,
      'monto': double.parse(_montoController.text),
    };

    // Usa el controlador para registrar el contrato
    _contratoController.registerContrato(context, {
      ...contData,
      'fechaCreacion': FieldValue.serverTimestamp(), // Agrega la fecha de creación
    });
  }
}
