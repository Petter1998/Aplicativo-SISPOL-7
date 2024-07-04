import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/flota_vehicular/vehicle_controller.dart';
import 'package:sispol_7/models/administration/flota_vehicular/vehicle_model.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';

class EditMyVehicleScreen extends StatefulWidget {
  final Vehicle vehicle;
  

  const EditMyVehicleScreen({super.key, required this.vehicle});

  @override
  // ignore: library_private_types_in_public_api
  _EditMyVehicleScreenState createState() => _EditMyVehicleScreenState();
}

class _EditMyVehicleScreenState extends State<EditMyVehicleScreen> {
  
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _motorController;
  late TextEditingController _placaController;
  late TextEditingController _chasisController;
  late TextEditingController _tipoController;
  late TextEditingController _cilindrajeController;
  late TextEditingController _capacidadPasController;
  late TextEditingController _capacidadCarController;
  late TextEditingController _kilometrajeController;
  late TextEditingController _dependenciaController;
  late TextEditingController _responsable1Controller;
  late TextEditingController _responsable2Controller;
  late TextEditingController _responsable3Controller;
  late TextEditingController _responsable4Controller;

  @override
  void initState() {
    super.initState();
    _marcaController = TextEditingController(text: widget.vehicle.marca);
    _modeloController = TextEditingController(text: widget.vehicle.modelo);
    _motorController = TextEditingController(text: widget.vehicle.motor);
    _placaController = TextEditingController(text: widget.vehicle.placa);
    _chasisController = TextEditingController(text: widget.vehicle.chasis);
    _tipoController = TextEditingController(text: widget.vehicle.tipo);
    _cilindrajeController = TextEditingController(text: widget.vehicle.cilindraje.toString());
    _capacidadPasController = TextEditingController(text: widget.vehicle.capacidadPas.toString());
    _capacidadCarController = TextEditingController(text: widget.vehicle.capacidadCar.toString());
    _kilometrajeController = TextEditingController(text: widget.vehicle.kilometraje.toString());
    _dependenciaController = TextEditingController(text:widget.vehicle.dependencia);
    _responsable1Controller = TextEditingController(text: widget.vehicle.responsable1);
    _responsable2Controller = TextEditingController(text: widget.vehicle.responsable2);
    _responsable3Controller = TextEditingController(text: widget.vehicle.responsable3);
    _responsable4Controller = TextEditingController(text: widget.vehicle.responsable4);
    _dependenciaController = TextEditingController(text: widget.vehicle.dependencia);
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _motorController.dispose();
    _placaController.dispose();
    _chasisController.dispose();
    _tipoController.dispose();
    _cilindrajeController.dispose();
    _capacidadPasController.dispose();
    _capacidadCarController.dispose();
    _kilometrajeController.dispose();
    _dependenciaController.dispose();
    _responsable1Controller.dispose();
    _responsable2Controller.dispose();
    _responsable3Controller.dispose();
    _responsable4Controller.dispose();
    _dependenciaController.dispose();
    super.dispose();
  }

  
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
                  ),
                  SizedBox(height: verticalSpacing),

                  TextField(
                    controller: _tipoController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Vehiculo',
                      hintText: 'Tipo de Vehiculo',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    readOnly: true,
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
                    controller: _dependenciaController,
                    decoration: const InputDecoration(
                      labelText: 'Dependencia',
                      hintText: 'Dependencia',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    style: GoogleFonts.inter(fontSize: bodyFontSize),
                    readOnly: true,
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
                    onPressed: () async {
                      final updatedVehicle = Vehicle(
                        id: widget.vehicle.id,
                        marca: _marcaController.text,
                        modelo: _modeloController.text,
                        motor: _motorController.text,
                        placa: _placaController.text,
                        chasis: _chasisController.text,
                        tipo: _tipoController.text,
                        cilindraje: double.tryParse(_cilindrajeController.text) ?? 0.0,
                        capacidadPas: int.tryParse(_capacidadPasController.text) ?? 0,
                        capacidadCar: int.tryParse(_capacidadCarController.text) ?? 0,
                        kilometraje: int.tryParse(_kilometrajeController.text) ?? 0,
                        dependencia: _dependenciaController.text,
                        responsable1: _responsable1Controller.text,
                        responsable2: _responsable2Controller.text,
                        responsable3: _responsable3Controller.text,
                        responsable4: _responsable4Controller.text,
                        fechacrea: DateTime.now(),
                      );
                       await VehicleController().updateMyVehicle(context, updatedVehicle);
                    },
                    child: Text(
                      'Guardar cambios', 
                      style: GoogleFonts.inter(fontSize: titleFontSize, fontWeight: FontWeight.bold,color: Colors.black)),
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
}