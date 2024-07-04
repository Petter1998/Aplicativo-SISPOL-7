import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/emergency/vehicle_part_controller.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';


class RegistrationVehiclePartiScreen extends StatefulWidget {
  const RegistrationVehiclePartiScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationVehiclePartiScreenState createState() => _RegistrationVehiclePartiScreenState();
}

class _RegistrationVehiclePartiScreenState extends State<RegistrationVehiclePartiScreen> {

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _motorController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _chasisController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _peligController = TextEditingController();
  final TextEditingController _cilindrajeController = TextEditingController();
  final TextEditingController _capacidadPasController = TextEditingController();
  final TextEditingController _capacidadCarController = TextEditingController();
  final TextEditingController _kilometrajeController = TextEditingController();
  final TextEditingController _kilometrajeAController = TextEditingController();
  final TextEditingController _responsable1Controller = TextEditingController();

  String? _selectedTipo;
  final List<String> tipos = ['Auto', 'Motocicleta', 'Camioneta'];

  String? _selectedNivel;
  final List<String> niveles = ['Baja', 'Media', 'Alta'];

  final VehiclePartController _vehicleController = VehiclePartController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');


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
                      Icons.directions_car, // Icono de usuario
                      size: imageSize, // Tamaño del icono
                      color: Colors.black, // Color del icono
                    ),
                  ),
                  
                  SizedBox(height: verticalSpacing), // Espacio ajustado según el ancho de la pantalla

                  TextField(controller: _marcaController,
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

                  TextField(
                    controller: _motorController,
                    decoration: const InputDecoration(
                      labelText: 'Motor',
                      hintText: 'Motor',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _placaController,
                    decoration: const InputDecoration(
                      labelText: 'Placa',
                      hintText: 'Placa',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                    TextField(
                    controller: _chasisController,
                    decoration: const InputDecoration(
                      labelText: 'Chasis',
                      hintText: 'Chasis',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
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

                  DropdownButtonFormField<String>(
                    value: _selectedNivel,
                    hint: Text('Nivel de Peligrosidad Operativos', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Nivel',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedNivel = newValue;
                        _peligController.text = newValue!; // Sincroniza el valor seleccionado con el controlador
                      });
                    },
                    items: niveles.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),
           
                  TextField(
                    controller: _cilindrajeController,
                    decoration: const InputDecoration(
                      labelText: 'Cilindraje en CC',
                      hintText: 'Cilindraje en CC',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),

                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _capacidadPasController,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad de Pasajeros',
                      hintText: 'Capacidad de Pasajeros',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _capacidadCarController,
                    decoration: const InputDecoration(
                      labelText: 'Capacidad de Carga en Toneladas',
                      hintText: 'Capacidad de Carga en Toneladas',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _kilometrajeController,
                    decoration: const InputDecoration(
                      labelText: 'Kilometraje del Vehiculo',
                      hintText: 'Kilometraje del Vehiculo',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _responsable1Controller,
                    decoration: const InputDecoration(
                      labelText: 'Propietario',
                      hintText: 'Nombres Completos',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
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
                      _registeVehicle();
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

  void _registeVehicle() {
    int? kilometraje = int.tryParse(_kilometrajeController.text);
    if (kilometraje != null) {
      _kilometrajeAController.text = kilometraje.toString();
    }
    
    // Recoge los datos del formulario y los pasa al controlador
    Map<String, dynamic> vehData = {
      'marca': _marcaController.text,
      'modelo': _modeloController.text,
      'motor': _motorController.text,
      'placa': _placaController.text,
      'chasis': _chasisController.text,
      'tipo': _tipoController.text,
      'peligrosidad': _peligController.text,
      'cilindraje': double.tryParse(_cilindrajeController.text),
      'capacidadPasajeros': int.tryParse(_capacidadPasController.text),
      'capacidadCarga': int.tryParse(_capacidadCarController.text),
      'kilometraje': kilometraje,
      'kilometrajeA': kilometraje,
      'responsable1': _responsable1Controller.text,
    };

    // Usa el controlador para registrar el vehículo
    _vehicleController.registeVehicle(context,{
      ...vehData,
      'fechaCreacion': FieldValue.serverTimestamp(), // Agrega la fecha de creación
    });
  }
}