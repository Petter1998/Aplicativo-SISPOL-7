import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/catalogos/catalogo_controller.dart';
import 'package:sispol_7/models/administration/catalogos/catalogo_model.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';

class EditCatalogoScreen extends StatefulWidget {
  final Catalogo catalogo;

  const EditCatalogoScreen({super.key, required this.catalogo});

  @override
  // ignore: library_private_types_in_public_api
  _EditCatalogoScreenState createState() => _EditCatalogoScreenState();
}

class _EditCatalogoScreenState extends State<EditCatalogoScreen> {
  late TextEditingController _nombreController;
  late TextEditingController _categoriaController;
  late TextEditingController _proveedorController;
  late TextEditingController _tiporepuestosController;
  late TextEditingController _vigenteController;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String? _selectedCategoria;
  final List<String> categorias = ['Auto', 'Motocicleta', 'Camioneta', 'Todos'];

  String? _selectedRepuestos;
  final List<String> repuest = [
    'Motor', 'Transmisión', 'Suspensión y Dirección',
    'Frenos', 'Eléctricos y Electrónicos', 'Carrocería y Exterior', 'Neumáticos y Llantas',
    'Interior', 'Todos los Repuestos'
  ];

  String? _selectedVigencia;
  final List<String> vigencias = ['Sí', 'No'];

  PlatformFile? _pdfFile;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.catalogo.nombre);
    _categoriaController = TextEditingController(text: widget.catalogo.categoria);
    _proveedorController = TextEditingController(text: widget.catalogo.proveedor);
    _tiporepuestosController = TextEditingController(text: widget.catalogo.tiporepuestos);
    _vigenteController = TextEditingController(text: widget.catalogo.vigente);
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _categoriaController.dispose();
    _proveedorController.dispose();
    _tiporepuestosController.dispose();
    _vigenteController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _pdfFile = result.files.single;
      });
    }
  }

  Future<String?> _uploadPdf(PlatformFile file) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('catalogo_pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf');
      final uploadTask = await storageReference.putData(file.bytes!);
      final downloadURL = await uploadTask.ref.getDownloadURL();
      return downloadURL;
    } catch (e) {
      // ignore: avoid_print
      print('Error al subir el PDF: $e');
      return null;
    }
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double imageSize = screenWidth < 480 ? 100.0 : (screenWidth > 1000 ? 200 : 150);

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
                                labelText: 'Nombre del Catálogo',
                                hintText: 'Nombre del Catálogo',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              style: GoogleFonts.inter(fontSize: bodyFontSize),
                            ),
                            SizedBox(height: verticalSpacing),
                            DropdownButtonFormField<String>(
                              value: _selectedCategoria,
                              hint: Text('Categoría', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Categoría',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategoria = newValue;
                                  _categoriaController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: categorias.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
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
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
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
                              value: _selectedVigencia,
                              hint: Text('Vigente', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                              decoration: const InputDecoration(
                                labelText: 'Vigente',
                                fillColor: Colors.black,
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedVigencia = newValue;
                                  _vigenteController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                                });
                              },
                              items: vigencias.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: verticalSpacing),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.picture_as_pdf, color: Colors.black,),
                              label: Text('Subir PDF', style: GoogleFonts.inter(fontSize: bodyFontSize, color: Colors.black)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(56, 171, 171, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                              ),
                              onPressed: _pickPdf,
                            ),
                            if (_pdfFile != null)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: verticalSpacing),
                                child: Text(
                                  'PDF seleccionado: ${_pdfFile!.name}',
                                  style: GoogleFonts.inter(fontSize: bodyFontSize),
                                ),
                              ),
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
                        final updatedCatalogo = Catalogo(
                          id: widget.catalogo.id,
                          nombre: _nombreController.text,
                          categoria: _categoriaController.text,
                          proveedor: _proveedorController.text,
                          tiporepuestos: _tiporepuestosController.text,
                          vigente: _vigenteController.text,
                          fechacrea: widget.catalogo.fechacrea,
                        );

                        if (_pdfFile != null) {
                          final pdfUrl = await _uploadPdf(_pdfFile!);
                          if (pdfUrl != null) {
                            updatedCatalogo.toMap()['pdfUrl'] = pdfUrl;
                          }
                        }

                        await CatalogosController().updateCatalogo(updatedCatalogo);
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
