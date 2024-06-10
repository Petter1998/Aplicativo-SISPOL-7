import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/administration/flota_vehicular/vehicle_controller.dart';
import 'package:sispol_7/widgets/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/footer.dart';


class RegistrationVehicleScreen extends StatefulWidget {
  const RegistrationVehicleScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationVehicleScreenState createState() => _RegistrationVehicleScreenState();
}

class _RegistrationVehicleScreenState extends State<RegistrationVehicleScreen> {

  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _motorController = TextEditingController();
  final TextEditingController _placaController = TextEditingController();
  final TextEditingController _chasisController = TextEditingController();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _cilindrajeController = TextEditingController();
  final TextEditingController _capacidadPasController = TextEditingController();
  final TextEditingController _capacidadCarController = TextEditingController();
  final TextEditingController _kilometrajeController = TextEditingController();
  final TextEditingController _dependenciaController = TextEditingController();
  final TextEditingController _responsable1Controller = TextEditingController();
  final TextEditingController _responsable2Controller = TextEditingController();
  final TextEditingController _responsable3Controller = TextEditingController();
  final TextEditingController _responsable4Controller = TextEditingController();

  String? _selectedTipo;
  final List<String> tipos = ['Auto', 'Motocicleta', 'Camioneta'];

  final VehicleController _vehicleController = VehicleController();
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _fetchDependencias();
  }

  String? _selectedDependencia;
  List<String> dependencias = [];

  
  // ignore: unused_element
  Future<void> _fetchDependencias() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('dependencias').get();
    List<String> fetchedDependencias = snapshot.docs.map((doc) => doc['nombreDistrito'] as String).toList();
    setState(() {
      dependencias = fetchedDependencias.toSet().toList(); // Eliminar duplicados
    });
  }

  String? _selectedResponsable1;
  String? _selectedResponsable2;
  String? _selectedResponsable3;
  String? _selectedResponsable4;
  List<String> personalDisponible = [];
  List<String> personalFiltered1 = [];
  List<String> personalFiltered2 = [];
  List<String> personalFiltered3 = [];
  List<String> personalFiltered4 = [];
  
  Future<void> _fetchPersonal(String dependencia) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('personal')
        .where('dependencia', isEqualTo: dependencia)
        .get();
    List<String> fetchedPersonal = snapshot.docs.map((doc) 
    // ignore: unnecessary_cast
    => '${doc['nombres']} ${doc['apellidos']}' as String).toList();
    setState(() {
      personalDisponible = fetchedPersonal.toSet().toList(); // Eliminar duplicados
      personalFiltered1 = List.from(personalDisponible);
      personalFiltered2 = List.from(personalDisponible);
      personalFiltered3 = List.from(personalDisponible);
      personalFiltered4 = List.from(personalDisponible);
    });
  }

  void _onDependenciaChanged(String? newValue) {
    setState(() {
      _selectedDependencia = newValue;
      _dependenciaController.text = newValue!;
      _selectedResponsable1 = null;
      _selectedResponsable2 = null;
      _selectedResponsable3 = null;
      _selectedResponsable4 = null;
    });
    if (newValue != null) {
      _fetchPersonal(newValue);
    }
  }

  void _onResponsable1Changed(String? newValue) {
    setState(() {
      _selectedResponsable1 = newValue;
      _responsable1Controller.text = newValue!; 
      personalFiltered2 = personalDisponible.where((item) => item != newValue).toList();
      _selectedResponsable2 = null;
      _selectedResponsable3 = null;
      _selectedResponsable4 = null;
      personalFiltered3 = List.from(personalDisponible);
    });
  }

  void _onResponsable2Changed(String? newValue) {
    setState(() {
      _selectedResponsable2 = newValue;
      _responsable2Controller.text = newValue!; 
      personalFiltered3 = personalDisponible.where((item) => item != _selectedResponsable1 && item != newValue).toList();
      _selectedResponsable3 = null;
      _selectedResponsable4 = null;
    });
  }

  void _onResponsable3Changed(String? newValue) {
    setState(() {
      _selectedResponsable3 = newValue;
      _responsable3Controller.text = newValue!; 
      personalFiltered4 = personalDisponible.where((item) => item != _selectedResponsable1 && item != _selectedResponsable2 && item != newValue).toList();
      _selectedResponsable4 = null;
    });
  }

  void _onResponsable4Changed(String? newValue) {
    setState(() {
      _selectedResponsable4 = newValue;
      _responsable4Controller.text = newValue!; 
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

                   DropdownButtonFormField<String>(
                    value: _selectedDependencia,
                    hint: Text('Dependencia', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Dependencia',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onDependenciaChanged,
                    items: dependencias.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedResponsable1,
                    hint: Text('Responsable N.1', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Responsable N.1',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onResponsable1Changed,
                    items: personalFiltered1.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedResponsable2,
                    hint: Text('Responsable N.2', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Responsable N.2',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onResponsable2Changed,
                    items: personalFiltered2.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedResponsable3,
                    hint: Text('Responsable N.3', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Responsable N.3',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onResponsable3Changed,
                    items: personalFiltered3.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: verticalSpacing),

                  DropdownButtonFormField<String>(
                    value: _selectedResponsable4,
                    hint: Text('Responsable N.4', style: GoogleFonts.inter(fontSize: bodyFontSize)),
                    decoration: const InputDecoration(
                      labelText: 'Responsable N.4',
                      fillColor: Colors.black,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onResponsable4Changed,
                    items: personalFiltered4.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: GoogleFonts.inter(fontSize: bodyFontSize)),
                      );
                    }).toList(),
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
                      _registerVehicle();
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

  void _registerVehicle() {
    // Recoge los datos del formulario y los pasa al controlador
    Map<String, dynamic> vehData = {
      'marca': _marcaController.text,
      'modelo': _modeloController.text,
      'motor': _motorController.text,
      'placa': _placaController.text,
      'chasis': _chasisController.text,
      'tipo': _tipoController.text,
      'cilindraje': double.tryParse(_cilindrajeController.text),
      'capacidadPasajeros': int.tryParse(_capacidadPasController.text),
      'capacidadCarga': int.tryParse(_capacidadCarController.text),
      'kilometraje': int.tryParse(_kilometrajeController.text),
      'dependencia': _dependenciaController.text,
    };

    // Añadir responsables si no están vacíos
    if (_responsable1Controller.text.isNotEmpty) {
      vehData['responsable1'] = _responsable1Controller.text;
    }
    if (_responsable2Controller.text.isNotEmpty) {
      vehData['responsable2'] = _responsable2Controller.text;
    }
    if (_responsable3Controller.text.isNotEmpty) {
      vehData['responsable3'] = _responsable3Controller.text;
    }
    if (_responsable4Controller.text.isNotEmpty) {
      vehData['responsable4'] = _responsable4Controller.text;
    }

    // Usa el controlador para registrar el vehículo
    _vehicleController.registerVehicle(context,{
      ...vehData,
      'fechaCreacion': FieldValue.serverTimestamp(), // Agrega la fecha de creación
    });
  }

}
