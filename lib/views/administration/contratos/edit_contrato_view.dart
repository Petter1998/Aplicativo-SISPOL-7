import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/contratos/contrato_controller.dart';
import 'package:sispol_7/models/administration/contratos/contrato_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class EditContratoScreen extends StatefulWidget {
  final Contrato contrato;

  const EditContratoScreen({super.key, required this.contrato});

  @override
  // ignore: library_private_types_in_public_api
  _EditContratoScreenState createState() => _EditContratoScreenState();
}

class _EditContratoScreenState extends State<EditContratoScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _fechainicioController;
  late TextEditingController _fechafinController;
  late TextEditingController _tipocontratoController;
  late TextEditingController _proveedorController;
  late TextEditingController _tiporepuestosController;
  late TextEditingController _vehiculoscubiertosController;
  late TextEditingController _montoController;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.contrato.nombre);
    _fechainicioController = TextEditingController(text: widget.contrato.fechainicio);
    _fechafinController = TextEditingController(text: widget.contrato.fechafin);
    _tipocontratoController = TextEditingController(text: widget.contrato.tipocontrato);
    _proveedorController = TextEditingController(text: widget.contrato.proveedor);
    _tiporepuestosController = TextEditingController(text: widget.contrato.tiporepuestos);
    _vehiculoscubiertosController = TextEditingController(text: widget.contrato.vehiculoscubiertos);
    _montoController = TextEditingController(text: widget.contrato.monto.toString());
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _fechainicioController.dispose();
    _fechafinController.dispose();
    _tipocontratoController.dispose();
    _proveedorController.dispose();
    _tiporepuestosController.dispose();
    _vehiculoscubiertosController.dispose();
    _montoController.dispose();
    super.dispose();
  }

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
                      Icons.edit_document,
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
                      onPressed: () async {
                        final updatedContrato = Contrato(
                          id: widget.contrato.id,
                          nombre: _nombreController.text,
                          fechainicio: _fechainicioController.text,
                          fechafin: _fechafinController.text,
                          tipocontrato: _tipocontratoController.text,
                          proveedor: _proveedorController.text,
                          tiporepuestos: _tiporepuestosController.text,
                          vehiculoscubiertos: _vehiculoscubiertosController.text,
                          monto: double.tryParse(_montoController.text) ?? 0.0,
                          fechacrea: DateTime.now(),
                        );

                        await ContratosController().updateContrato(updatedContrato);
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
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
}
