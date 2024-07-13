import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/repuestos/repuestos_controller.dart';
import 'package:sispol_7/models/administration/repuestos/repuestos_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class EditRepuestoScreen extends StatefulWidget {
  final Repuesto repuesto;

  const EditRepuestoScreen({super.key, required this.repuesto});

  @override
  // ignore: library_private_types_in_public_api
  _EditRepuestoScreenState createState() => _EditRepuestoScreenState();
}

class _EditRepuestoScreenState extends State<EditRepuestoScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _fechaAdquiController;
  late TextEditingController _contratoController;
  late TextEditingController _modeloController;
  late TextEditingController _marcaController;
  late TextEditingController _ubicacionController;
  late TextEditingController _precioController;
  late TextEditingController _cantidadController;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.repuesto.nombre);
    _fechaAdquiController = TextEditingController(text: widget.repuesto.fechaadqui);
    _contratoController = TextEditingController(text: widget.repuesto.contrato);
    _modeloController = TextEditingController(text: widget.repuesto.modelo);
    _marcaController = TextEditingController(text: widget.repuesto.marca);
    _ubicacionController = TextEditingController(text: widget.repuesto.ubicacion);
    _precioController = TextEditingController(text: widget.repuesto.precio.toString());
    _cantidadController = TextEditingController(text: widget.repuesto.cantidad.toString());
    _fetchContratos();
    _selectedContrato = widget.repuesto.contrato;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _fechaAdquiController.dispose();
    _contratoController.dispose();
    _modeloController.dispose();
    _marcaController.dispose();
    _ubicacionController.dispose();
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  String? _selectedContrato;
  List<String> contratos = [];

  Future<void> _fetchContratos() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('contratos').get();
    List<String> fetchedContratos = snapshot.docs.map((doc) => doc['tipoContrato'] as String).toList();
    setState(() {
      contratos = fetchedContratos.toSet().toList(); // Eliminar duplicados
    });
  }

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
                                labelText: 'Nombre',
                                hintText: 'Nombre',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _modeloController,
                              decoration: const InputDecoration(
                                labelText: 'Modelo',
                                hintText: 'Modelo',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            DropdownButtonFormField<String>(
                              value: _selectedContrato,
                              hint: Text('Tipo', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Tipo de Contrato',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedContrato = newValue;
                                  _contratoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: contratos.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _cantidadController,
                              decoration: const InputDecoration(
                                labelText: 'Cantidad',
                                hintText: 'Cantidad',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
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
                              controller: _fechaAdquiController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Adquisición',
                                hintText: 'Fecha de Adquisición',
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
                                        _fechaAdquiController.text = _dateFormat.format(pickedDate);
                                      });
                                    }
                                  },
                                ),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _marcaController,
                              decoration: const InputDecoration(
                                labelText: 'Marca',
                                hintText: 'Marca',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _ubicacionController,
                              decoration: const InputDecoration(
                                labelText: 'Ubicación en Almacén',
                                hintText: 'Ubicación en Almacén',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _precioController,
                              decoration: const InputDecoration(
                                labelText: 'Precio de Compra',
                                hintText: 'Precio de Compra',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
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
                        final updatedRepuesto = Repuesto(
                          id: widget.repuesto.id,
                          nombre: _nombreController.text,
                          fechaadqui: _fechaAdquiController.text,
                          contrato: _contratoController.text,
                          modelo: _modeloController.text,
                          marca: _marcaController.text,
                          ubicacion: _ubicacionController.text,
                          precio: double.tryParse(_precioController.text) ?? 0.0,
                          cantidad: int.tryParse(_cantidadController.text) ?? 0,
                          fechacrea: DateTime.now(),
                        );

                        await RepuestosController().updateRepuesto(updatedRepuesto);
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
