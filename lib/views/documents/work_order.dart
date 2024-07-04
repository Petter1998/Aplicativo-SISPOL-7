import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/documents/documents_controller.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class WorkOrderScreen extends StatefulWidget {
  const WorkOrderScreen({super.key});

  
  @override
  // ignore: library_private_types_in_public_api
  _WorkOrderScreenState createState() => _WorkOrderScreenState();
}

class _WorkOrderScreenState extends State<WorkOrderScreen> {

  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _horaController = TextEditingController();
  final TextEditingController _kilometrajeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _responsableController = TextEditingController();
  final TextEditingController _asuntoController = TextEditingController();
  final TextEditingController _detalleController = TextEditingController();
  final TextEditingController _tipoMantController = TextEditingController();
  final TextEditingController _mantComplController = TextEditingController();
  final TextEditingController _tipocontController = TextEditingController();
  final DocumentosController2 _documentosController2 = DocumentosController2();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  final TextEditingController _subTotalController = TextEditingController();
  final TextEditingController _ivaController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();

  String? _selectedTipo;
  final List<String> tipos = ['Auto', 'Motocicleta', 'Camioneta'];

  String? _selectedEstado;
  final List<String> estados = ['En Progreso', 'Finalizada'];

  bool isMoto = true; // Variable para indicar si es motocicleta o carro

  double subTotal = 0.0;
  double iva = 0.0;
  double total = 0.0;

  bool isMantenimiento1 = false;
  bool isMantenimiento2 = false;
  bool isMantenimiento3 = false;

  bool isAlineacionBalanceo = false;
  bool isRevisionSuspension = false;
  bool isRevisionEscape = false;

  bool showSubTotalAndIva = false; // Variable para controlar la visibilidad

  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        // ignore: avoid_print
        print('No hay imagen seleccionada.');
      }
    });
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageReference = FirebaseStorage.instance
          .ref()
          .child('work_order_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageReference.putFile(image); // Espera la tarea de subida
      final downloadURL = await uploadTask.ref.getDownloadURL();
      // ignore: avoid_print
      print('URL de la imagen subida: $downloadURL'); // Mensaje de depuración
      return downloadURL;
    } catch (e) {
      // ignore: avoid_print
      print('Error al subir la imagen: $e');
      return null;
    }
  }


  
  void _updateCosts() {
  subTotal = 0.0;

  if (isMantenimiento1) {
    subTotal += 43.59;
  }
  if (isMantenimiento2) {
    subTotal += 60.00;
  }
  if (isMantenimiento3) {
    subTotal += 180.00;
  }
  // Verifica el tipo de vehículo y aplica los costos correspondientes
  if (_selectedTipo == 'Motocicleta') {
    if (isAlineacionBalanceo) {
      subTotal += 10;
    }
    if (isRevisionSuspension) {
      subTotal += 15;
    }
    if (isRevisionEscape) {
      subTotal += 10;
    }
  } else { // Auto y Camioneta
    if (isAlineacionBalanceo) {
      subTotal += 20;
    }
    if (isRevisionSuspension) {
      subTotal += 30;
    }
    if (isRevisionEscape) {
      subTotal += 20;
    }
  }

  iva = subTotal * 0.12;
  total = subTotal + iva;

  _subTotalController.text = subTotal.toStringAsFixed(2);
  _ivaController.text = iva.toStringAsFixed(2);
  _totalController.text = total.toStringAsFixed(2);
}


  void _onMantenimientoChanged(int mantenimiento) {
    setState(() {
      if (mantenimiento == 1) {
        isMantenimiento1 = !isMantenimiento1;
        if (isMantenimiento1) {
          _tipoMantController.text = 'Mantenimiento 1';
          isMantenimiento2 = false;
        } else {
          _tipoMantController.text = '';
        }
      } else if (mantenimiento == 2) {
        isMantenimiento2 = !isMantenimiento2;
        if (isMantenimiento2) {
          _tipoMantController.text = 'Mantenimiento 2';
          isMantenimiento1 = false;
        } else {
          _tipoMantController.text = '';
        }
      } else if (mantenimiento == 3) {
        isMantenimiento3 = !isMantenimiento3;
        if (isMantenimiento3) {
          if (isMantenimiento1) {
            _tipoMantController.text = 'Mantenimiento 1, Mantenimiento 3';
          } else if (isMantenimiento2) {
            _tipoMantController.text = 'Mantenimiento 2, Mantenimiento 3';
          } else {
            _tipoMantController.text = 'Mantenimiento 3';
          }
        } else {
          if (isMantenimiento1) {
            _tipoMantController.text = 'Mantenimiento 1';
          } else if (isMantenimiento2) {
            _tipoMantController.text = 'Mantenimiento 2';
          } else {
            _tipoMantController.text = '';
          }
        }
      }
      _updateCosts(); // Llama a la función de actualización de costos
    });
  }


  void _onMantenimientoComplChanged() {
    setState(() {
      List<String> mantenimientos = [];
      if (isAlineacionBalanceo) mantenimientos.add('Alineación y balanceo de neumáticos');
      if (isRevisionSuspension) mantenimientos.add('Revisión y ajuste del sistema de suspensión');
      if (isRevisionEscape) mantenimientos.add('Revisión del sistema de escape');
      _mantComplController.text = mantenimientos.join(', ');

      _updateCosts(); // Llamar a la función de actualización de costos
    });
  }

  Future<void> _fetchResponsable() async {
    String cedula = _cedulaController.text.trim();
    int? cedulaInt = int.tryParse(cedula);

    if (cedulaInt != null) {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('personal')
          .where('cedula', isEqualTo: cedulaInt)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> personalDoc = querySnapshot.docs.first;
        String nombres = personalDoc['nombres'] ?? '';
        String apellidos = personalDoc['apellidos'] ?? '';
        setState(() {
          _responsableController.text = '$nombres $apellidos';
        });
      } else {
        setState(() {
          _responsableController.text = '';
        });
      }
    } else {
      setState(() {
        _responsableController.text = '';
      });
    }
  }

  Future<void> _fetchVehicleDetails() async {
    String placa = _placaController.text.trim();

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('vehiculos')
        .where('placa', isEqualTo: placa)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> vehicleDoc = querySnapshot.docs.first;
      String marca = vehicleDoc['marca'] ?? '';
      String modelo = vehicleDoc['modelo'] ?? '';
      setState(() {
        _marcaController.text = marca;
        _modeloController.text = modelo;
      });
    } else {
      setState(() {
        _marcaController.text = '';
        _modeloController.text = '';
      });
    }
  }

  String? _selectedTipoContrato;
  List<String> tipoContratos = [];

  @override
  void initState() {
    super.initState();
    _fetchTipoContratos();
  }

  Future<void> _fetchTipoContratos() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('contratos').get();
      final tipos = snapshot.docs.map((doc) => doc['tipoContrato'].toString()).toSet().toList();
      setState(() {
        tipoContratos = tipos;
      });
    } catch (e) {
      // Manejo de error
      // ignore: avoid_print
      print('Error fetching tipoContrato: $e');
    }
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
        padding: EdgeInsets.symmetric(horizontal:horizontalPadding , vertical: 20), // Ajusta el padding para controlar el ancho
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Color del borde
                  width: 1, // Grosor del borde
                ),
                borderRadius: BorderRadius.circular(10.0), // Redondeo del borde
                
              ), // Agrega padding dentro del contenedor
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(90.0), // Radio del borde redondo
                    child: Icon(
                      Icons.receipt_long_rounded, // Icono de solictud
                      size: imageSize, // Tamaño del icono
                      color: Colors.black, // Color del icono
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _fechaController,
                          decoration: InputDecoration(
                            labelText: 'Fecha',
                            hintText: 'Fecha',
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
                                    _fechaController.text = _dateFormat.format(pickedDate);
                                  });
                                }
                              },
                            ),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _horaController,
                          decoration: const InputDecoration(
                            labelText: 'Hora',
                            hintText: 'Hora',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                        ),
                      ),
                    ],
                  ),     
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _kilometrajeController,
                    decoration: const InputDecoration(
                      labelText: 'Kilometraje Actual',
                      hintText: 'Kilometraje Actual',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  Row(
                    children: [
                      Expanded(
                        child:  DropdownButtonFormField<String>(
                          value: _selectedEstado,
                          hint: Text('Estado', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                          decoration: const InputDecoration(
                            labelText: 'Estado',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedEstado = newValue;
                              _estadoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                            });
                          },
                          items: estados.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedTipo,
                          hint: Text('Tipo de Vehiculo', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                          decoration: const InputDecoration(
                            labelText: 'Tipo de Vehiculo',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTipo = newValue;
                              _tipoController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                              _updateCosts(); // Actualizar costos cuando cambia el tipo de vehículo
                            });
                          },
                          items: tipos.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),   
                  SizedBox(height: verticalSpacing),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _placaController,
                          decoration: const InputDecoration(
                            labelText: 'Placa',
                            hintText: 'Placa',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                          onChanged: (value) {
                            _fetchVehicleDetails();
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(controller: _marcaController,
                          decoration: const InputDecoration(
                            labelText: 'Marca',
                            hintText: 'Marca',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                        ),
                      ),
                    ],
                  ),  
                  SizedBox(height: verticalSpacing),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _modeloController,
                          decoration: const InputDecoration(
                            labelText: 'Modelo',
                            hintText: 'Modelo',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(controller: _cedulaController,
                          decoration: const InputDecoration(
                            labelText: 'Cédula',
                            hintText: 'Cédula',
                            fillColor: Colors.black,
                            border: OutlineInputBorder(),
                          ),
                          style: GoogleFonts.inter(fontSize: bodyFontSize),
                          onChanged: (value) {
                            _fetchResponsable();
                          },
                        ),
                      ),
                    ],
                  ), 
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _responsableController,
                    decoration: const InputDecoration(
                      labelText: 'Responsable',
                      hintText: 'Responsable',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _asuntoController,
                    decoration: const InputDecoration(
                      labelText: 'Asunto',
                      hintText: 'Asunto',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),
                  
                  TextField(
                    controller: _detalleController,
                    decoration: const InputDecoration(
                      labelText: 'Detalle',
                      hintText: 'Detalle',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedTipoContrato,
                    hint: Text('Tipo de Contrato', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Contrato',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTipoContrato = newValue;
                        _tipocontController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                      });
                    },
                    items: tipoContratos.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  Text(
                    'Seleccione el tipo de mantenimiento:',
                    style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Mantenimiento 1 (Revisión y cambio de aceite, pastillas, líquidos de\nfrenos y filtro de Combustible)',
                      style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    value: isMantenimiento1,
                    onChanged: (value) {
                      _onMantenimientoChanged(1);
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Mantenimiento 2 (Mantenimiento 1 más cambio de filtro de aire, \ncambio de refrigerante y cambio de luces delanteras y posteriores)', 
                      style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    value: isMantenimiento2,
                    onChanged: (value) {
                      _onMantenimientoChanged(2);
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Mantenimiento 3 (Cambio de batería y ajustes en el sistema\neléctrico)', 
                    style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    value: isMantenimiento3,
                    onChanged: (value) {
                      _onMantenimientoChanged(3);
                    },
                  ),
                  SizedBox(height: verticalSpacing),

                  Text(
                    'Seleccione los mantenimientos complementarios:',
                    style: GoogleFonts.inter(fontSize: bodyFontSize, fontWeight: FontWeight.bold),
                  ),
                  CheckboxListTile(
                    title: Text('Alineación y balanceo de neumáticos', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    value: isAlineacionBalanceo,
                    onChanged: (bool? value) {
                      setState(() {
                        isAlineacionBalanceo = value!;
                        _onMantenimientoComplChanged();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Revisión y ajuste del sistema de suspensión', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    value: isRevisionSuspension,
                    onChanged: (bool? value) {
                      setState(() {
                        isRevisionSuspension = value!;
                        _onMantenimientoComplChanged();
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: Text('Revisión del sistema de escape', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    value: isRevisionEscape,
                    onChanged: (bool? value) {
                      setState(() {
                        isRevisionEscape = value!;
                        _onMantenimientoComplChanged();
                      });
                    },
                  ),
                  SizedBox(height: verticalSpacing),

                  if (_selectedTipoContrato == 'Mantenimiento' || _selectedTipoContrato == 'Suministro') ...[
                    TextField(
                      controller: _subTotalController,
                      decoration: const InputDecoration(
                        labelText: 'Sub Total',
                        hintText: 'Sub Total',
                        fillColor: Colors.black,
                        border: OutlineInputBorder(),
                      ),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),
                      readOnly: true,
                    ),
                    SizedBox(height: verticalSpacing),
                    TextField(
                      controller: _ivaController,
                      decoration: const InputDecoration(
                        labelText: 'IVA al 12%',
                        hintText: 'IVA al 12%',
                        fillColor: Colors.black,
                        border: OutlineInputBorder(),
                      ),
                      style: GoogleFonts.inter(fontSize: bodyFontSize),
                      readOnly: true,
                    ),
                    SizedBox(height: verticalSpacing),
                  ],
                  TextField(
                    controller: _totalController,
                    decoration: const InputDecoration(
                      labelText: 'Total',
                      hintText: 'Total',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),
                  if (_image != null)
                    kIsWeb
                    ? Image.network(
                        _image!.path,
                        height: 200,
                      )
                    : Image.file(
                        _image!,
                        height: 200,
                      ),
                  SizedBox(height: verticalSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt, color:  Colors.black),
                        label: Text('Tomar Foto',
                        style: GoogleFonts.inter(fontSize: bodyFontSize,color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                          
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                        ),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.photo_library, color:  Colors.black),
                        label: Text('Seleccionar de Galería',
                        style: GoogleFonts.inter(fontSize: bodyFontSize,color: Colors.black),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                          
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                        ),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  SizedBox(height: verticalSpacing),
                  SizedBox(height: vertiSpacing),
                 
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(56, 171, 171, 1), // Color de fondo
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18), // Padding interno del botón
                    ),
                    onPressed: () {
                      _registerDoc();
                    },
                    child: Text('Registrar', style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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
        child: Icon(Icons.arrow_back, size: iconSize, color:  Colors.black),
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }

  void _registerDoc() async {
    try {
      String? imageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage(_image!);
        if (imageUrl == null) {
          throw Exception('Error al subir la imagen'); // Manejo de error
        }
      }

      final Map<String, dynamic> docuData = {
        'fecha': _fechaController.text,
        'hora': _horaController.text,
        'kilometrajeActual': int.tryParse(_kilometrajeController.text),
        'estado': _estadoController.text,
        'tipo': _tipoController.text,
        'placa': _placaController.text,
        'marca': _marcaController.text,
        'modelo': _modeloController.text,
        'cedula': _cedulaController.text,
        'responsable': _responsableController.text,
        'asunto': _asuntoController.text,
        'detalle': _detalleController.text,
        'tipoMantenimiento': _tipoMantController.text,
        'mantenimientoComplementario': _mantComplController.text,
        'total': double.tryParse(_totalController.text),
        // ignore: unnecessary_null_comparison
        if (imageUrl != null) 'imagenUrl': imageUrl, // Solo agrega la URL si no es null
      };

      // ignore: use_build_context_synchronously
      await _documentosController2.registerDoc(context, {
        ...docuData,
        'fechaCreacion': FieldValue.serverTimestamp(),
      });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Documento registrado exitosamente')),
    );

    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrar: $e')),
      );
    }
  }
}