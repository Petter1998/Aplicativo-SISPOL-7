import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/lubricantes/lubricante_controller.dart';
import 'package:sispol_7/models/lubricantes/lubricantes_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class EditLubricanteScreen extends StatefulWidget {
  final Lubricante lubricante;

  const EditLubricanteScreen({super.key, required this.lubricante});

  @override
  // ignore: library_private_types_in_public_api
  _EditLubricanteScreenState createState() => _EditLubricanteScreenState();
}

class _EditLubricanteScreenState extends State<EditLubricanteScreen> {
  late TextEditingController _capacidadController;
  late TextEditingController _fechaVenceController;
  late TextEditingController _marcaController;
  late TextEditingController _nombreController;
  late TextEditingController _precioController;
  late TextEditingController _proveedorController;
  late TextEditingController _stockController;
  late TextEditingController _tipoController;
  late TextEditingController _viscosidadController;
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _capacidadController = TextEditingController(text: widget.lubricante.capacidad.toString());
    _fechaVenceController = TextEditingController(text: _dateFormat.format(widget.lubricante.fechaVence));
    _marcaController = TextEditingController(text: widget.lubricante.marca);
    _nombreController = TextEditingController(text: widget.lubricante.nombre);
    _precioController = TextEditingController(text: widget.lubricante.precio.toString());
    _proveedorController = TextEditingController(text: widget.lubricante.proveedor);
    _stockController = TextEditingController(text: widget.lubricante.stock.toString());
    _tipoController = TextEditingController(text: widget.lubricante.tipo);
    _viscosidadController = TextEditingController(text: widget.lubricante.viscosidad.toString());
  }

  @override
  void dispose() {
    _capacidadController.dispose();
    _fechaVenceController.dispose();
    _marcaController.dispose();
    _nombreController.dispose();
    _precioController.dispose();
    _proveedorController.dispose();
    _stockController.dispose();
    _tipoController.dispose();
    _viscosidadController.dispose();
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageSize = screenWidth < 480 ? 100.0 : (screenWidth > 1000 ? 200 : 150);

    double titleFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 24 : 28);
    double bodyFontSize = screenWidth < 600 ? 16 : (screenWidth < 1200 ? 18 : 20);
    double verticalSpacing = screenWidth < 600 ? 8 : (screenWidth < 1200 ? 25 : 30);
    double vertiSpacing = screenWidth < 600 ? 20 : (screenWidth < 1200 ? 35 : 40);
    double iconSize = screenWidth > 480 ? 34.0 : 27.0;

    double horizontalPadding;
    if (screenWidth < 800) {
      horizontalPadding = screenWidth * 0.05;
    } else {
      horizontalPadding = screenWidth * 0.20;
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
                            TextField(
                              controller: _tipoController,
                              decoration: const InputDecoration(
                                labelText: 'Tipo',
                                hintText: 'Tipo',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _viscosidadController,
                              decoration: const InputDecoration(
                                labelText: 'Viscosidad',
                                hintText: 'Viscosidad',
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
                              controller: _capacidadController,
                              decoration: const InputDecoration(
                                labelText: 'Capacidad (Lt)',
                                hintText: 'Capacidad (Lt)',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _stockController,
                              decoration: const InputDecoration(
                                labelText: 'Stock',
                                hintText: 'Stock',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _precioController,
                              decoration: const InputDecoration(
                                labelText: 'Precio',
                                hintText: 'Precio',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            TextField(
                              controller: _fechaVenceController,
                              decoration: InputDecoration(
                                labelText: 'Fecha de Vencimiento',
                                hintText: 'Fecha de Vencimiento',
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
                                        _fechaVenceController.text = _dateFormat.format(pickedDate);
                                      });
                                    }
                                  },
                                ),
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
                        final updatedLubricante = Lubricante(
                          id: widget.lubricante.id,
                          capacidad: double.tryParse(_capacidadController.text) ?? 0.0,
                          fechaIngreso: widget.lubricante.fechaIngreso,
                          fechaVence: _dateFormat.parse(_fechaVenceController.text),
                          idUser: widget.lubricante.idUser,
                          marca: _marcaController.text,
                          nombre: _nombreController.text,
                          precio: double.tryParse(_precioController.text) ?? 0.0,
                          proveedor: _proveedorController.text,
                          stock: int.tryParse(_stockController.text) ?? 0,
                          tipo: _tipoController.text,
                          viscosidad: _viscosidadController.text,
                        );

                        await LubricanteController().updateLubricante(updatedLubricante);
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
