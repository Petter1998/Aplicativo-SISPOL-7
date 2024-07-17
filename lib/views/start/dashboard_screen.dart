import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sispol_7/controllers/start/dashboard_controller.dart';
import 'package:sispol_7/widgets/global/appbar_sis7.dart';
import 'package:sispol_7/widgets/drawer/complex_drawer.dart';
import 'package:sispol_7/widgets/global/footer.dart';
import 'package:sispol_7/widgets/global/km_widget.dart';

// ignore: must_be_immutable
class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key, required this.userId});

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final MaintenanceController maintenanceController = MaintenanceController();
  final String userId;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarSis7(onDrawerPressed: () => scaffoldKey.currentState?.openDrawer()),
      drawer: const ComplexDrawer(),
      body: FutureBuilder<String>(
        future: maintenanceController.getUserRole(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No se pudo obtener el rol del usuario'));
          } else {
            String role = snapshot.data!;
            return SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1200) {
                    // Pantallas grandes
                    return _buildLargeScreenContent(role, screenWidth, screenHeight);
                  } else if (constraints.maxWidth > 1000) {
                    // Pantallas medianas
                    return _buildMediumScreenContent(role, screenWidth, screenHeight);
                  } else {
                    // Pantallas pequeñas
                    return _buildSmallScreenContent(role, screenWidth, screenHeight);
                  }
                },
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Footer(screenWidth: screenWidth),
    );
  }

  Widget _buildLargeScreenContent(String role, double screenWidth, double screenHeight) {
    if (role == 'Administrador') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPieChart(screenWidth, screenHeight),
                const SizedBox(width: 16),
                _buildLineChart(screenWidth, screenHeight),
                const SizedBox(width: 16),
                GaugeChartWidget(controller: maintenanceController, userId: userId),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPie2Chart(screenWidth, screenHeight),
                const SizedBox(width: 16),
                _buildBarChart(screenWidth, screenHeight),
              ],
            ),
          ],
        ),
      );
    } else if (role == 'Técnico 1' || role == 'Técnico 2') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildPieChart(screenWidth, screenHeight),
                const SizedBox(width: 16),
                GaugeChartWidget(controller: maintenanceController, userId: userId),
              ],
            ),
            const SizedBox(height: 16),
            _buildPie2Chart(screenWidth, screenHeight),
          ],
        ),
      );
    } else if (role == 'Personal Policial') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Flexible(
              child: GaugeChartWidget(controller: maintenanceController, userId: userId),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Rol de usuario no reconocido'));
    }
  }

  Widget _buildMediumScreenContent(String role, double screenWidth, double screenHeight) {
    if (role == 'Administrador') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: _buildPieChart(screenWidth, screenHeight)),
                const SizedBox(width: 16),
                Flexible(flex: 1, child: _buildLineChart(screenWidth, screenHeight)),
                const SizedBox(width: 16),
                Flexible(flex: 1, child: GaugeChartWidget(controller: maintenanceController, userId: userId)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: _buildPie2Chart(screenWidth, screenHeight)),
                const SizedBox(width: 16),
                Flexible(flex: 1, child: _buildBarChart(screenWidth, screenHeight)),
              ],
            ),
          ],
        ),
      );
    } else if (role == 'Técnico 1' || role == 'Técnico 2') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: _buildPieChart(screenWidth, screenHeight)),
                const SizedBox(width: 16),
                Flexible(flex: 1, child: GaugeChartWidget(controller: maintenanceController, userId: userId)),
              ],
            ),
            const SizedBox(height: 16),
            _buildPie2Chart(screenWidth, screenHeight),
          ],
        ),
      );
    } else if (role == 'Personal Policial') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Flexible(
              child: GaugeChartWidget(controller: maintenanceController, userId: userId),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Rol de usuario no reconocido'));
    }
  }

  Widget _buildSmallScreenContent(String role, double screenWidth, double screenHeight) {
    if (role == 'Administrador') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            GaugeChartWidget(controller: maintenanceController, userId: userId),
            const SizedBox(height: 16),
            _buildPieChart(screenWidth, screenHeight),
            const SizedBox(height: 16),
            _buildLineChart(screenWidth, screenHeight),
            const SizedBox(height: 16),
            _buildPie2Chart(screenWidth, screenHeight),
            const SizedBox(height: 16),
            _buildBarChart(screenWidth, screenHeight),
          ],
        ),
      );
    } else if (role == 'Técnico 1' || role == 'Técnico 2') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            GaugeChartWidget(controller: maintenanceController, userId: userId),
            const SizedBox(height: 16),
            _buildPieChart(screenWidth, screenHeight),
            const SizedBox(height: 16),
            _buildPie2Chart(screenWidth, screenHeight),
          ],
        ),
      );
    } else if (role == 'Personal Policial') {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Flexible(
              child: GaugeChartWidget(controller: maintenanceController, userId: userId),
            ),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Rol de usuario no reconocido'));
    }
  }
  // Método para construir el gráfico de pastel
  Widget _buildPieChart(double screenWidth, double screenHeight) {
    return FutureBuilder<Map<String, int>>(
      future: maintenanceController.getVehicleMaintenanceData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No hay información disponible',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          Map<String, int> data = snapshot.data!;
          List<PieChartSectionData> pieSections = [];
          int total = data.values.fold(0, (sum, count) => sum + count);

          data.forEach((vehicleType, count) {
            final percentage = (count / total * 100).toStringAsFixed(1);
            pieSections.add(
              PieChartSectionData(
                value: count.toDouble(),
                title: '$percentage%',
                color: getColor(vehicleType), // Define un método para asignar colores
                radius: screenWidth < 600 ? 55 : 50, // Ajustar el radio basado en el tamaño de la pantalla
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          });

          return Container(
            width: screenWidth < 1000 ? screenWidth * 0.8 : screenWidth * 0.3,
            height: screenHeight * 0.4, // Ajustar la altura si es necesario
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Text(
                  'Demanda de Solicitudes de Mantenimiento',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth < 600 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5), // Espacio entre el texto y el gráfico
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        // Ajustar el radio del espacio central basado en el tamaño de la pantalla
                        centerSpaceRadius: screenWidth < 600 ? 20 : 40,
                        sectionsSpace: 2, // Espacio entre secciones
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16), // Espacio entre el gráfico y la leyenda
                // Leyenda y título de la leyenda
                Column(
                  children: [
                    Text(
                      'Tipos de Vehículos',
                      style: GoogleFonts.inter(
                        fontSize: screenWidth < 600 ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8), // Espacio entre el título de la leyenda y la leyenda
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      children: data.keys.map((vehicleType) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: getColor(vehicleType),
                            ),
                            const SizedBox(width: 4),
                            Text(vehicleType),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Método para construir el gráfico de líneas
  Widget _buildLineChart(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth < 1000 ? screenWidth * 0.8 : screenWidth * 0.3,
      height: screenHeight * 0.4, // Ajustar la altura si es necesario
      padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            'Inversión de los últimos 3 meses en Mantenimiento',
            style: GoogleFonts.inter(
              fontSize: screenWidth < 600 ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5), // Espacio entre el texto y el gráfico
          Expanded(
            child: FutureBuilder<Map<String, double>>(
              future: maintenanceController.getMonthlyAmounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay información disponible',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  Map<String, double> data = snapshot.data!;
                  List<FlSpot> spots = [];
                  List<String> months = data.keys.toList();
                  int index = 0;

                  months.sort((a, b) {
                    DateTime aDate = DateFormat('MMM').parse(a);
                    DateTime bDate = DateFormat('MMM').parse(b);
                    return aDate.compareTo(bDate);
                  });

                  for (var month in months) {
                    spots.add(FlSpot(index.toDouble(), data[month]!));
                    index++;
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: true,
                            gradient: const LinearGradient( // Use gradient with LinearGradient object
                              colors: [Colors.lightBlueAccent, Colors.greenAccent],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            isStrokeCapRound: true,
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient( // Use gradient for belowBarData as well
                                colors: [
                                  Colors.lightBlueAccent.withOpacity(0.3),
                                  Colors.greenAccent.withOpacity(0.3)
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                            dotData: const FlDotData(
                              show: true,
                            ),
                          ),
                        ],
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                if (value.toInt() < months.length) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 3.0,
                                    child: Text(months[value.toInt()], style: style),
                                  );
                                } else {
                                  return const Text('');
                                }
                              },
                              interval: 1,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '\$${value.toInt()}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  
  // Método para construir el gráfico de pastel
  Widget _buildPie2Chart(double screenWidth, double screenHeight) {
    return FutureBuilder<Map<String, int>>(
      future: maintenanceController.getMaintenanceTypeData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No hay información disponible',
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
          );
        } else {
          Map<String, int> data = snapshot.data!;
          List<PieChartSectionData> pieSections = [];
          int total = data.values.fold(0, (sum, count) => sum + count);

          data.forEach((maintenanceType, count) {
            final percentage = (count / total * 100).toStringAsFixed(1);
            pieSections.add(
              PieChartSectionData(
                value: count.toDouble(),
                title: '$percentage%',
                color: getColor2(maintenanceType),
                radius: screenWidth < 600 ? 55 : 50,
                titleStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            );
          });

          return Container(
            width: screenWidth < 1000 ? screenWidth * 0.8 : screenWidth * 0.3,
            height: screenHeight * 0.4,
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                ),
              ],
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Text(
                  'Mantenimiento más Demandado',
                  style: GoogleFonts.inter(
                    fontSize: screenWidth < 600 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: screenWidth < 600 ? 20 : 40,
                        sectionsSpace: 2,
                      ),
                      swapAnimationDuration: const Duration(milliseconds: 300), // Optional animation
                      swapAnimationCurve: Curves.linear,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Column(
                  children: [
                    Text(
                      'Tipos de Mantenimiento',
                      style: GoogleFonts.inter(
                        fontSize: screenWidth < 600 ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 16.0,
                      children: data.keys.map((maintenanceType) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Descripción del Mantenimiento',
                                  style: GoogleFonts.inter(
                                  fontSize: screenWidth < 600 ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  ),),
                                  content: Text(getMaintenanceDescription(maintenanceType)),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cerrar',
                                      style: GoogleFonts.inter(
                                      fontSize: screenWidth < 600 ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Tooltip(
                            message: getMaintenanceDescription(maintenanceType),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: getColor2(maintenanceType),
                                ),
                                const SizedBox(width: 4),
                                Text(maintenanceType),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  // Método para construir el gráfico de barras
  Widget _buildBarChart(double screenWidth, double screenHeight) {
    return Container(
      width: screenWidth < 1000 ? screenWidth * 0.8 : screenWidth < 1200 ? screenWidth * 0.6 : screenWidth > 1200 ? screenWidth * 0.6 : screenWidth * 0.3,
      height: screenHeight * 0.4, // Ajustar la altura si es necesario
      padding: const EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(2, 2),
          ),
        ],
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        children: [
          Text(
            'Montos por Tipo de Contrato',
            style: GoogleFonts.inter(
              fontSize: screenWidth < 600 ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5), // Espacio entre el texto y el gráfico
          Expanded(
            child: FutureBuilder<Map<String, double>>(
              future: maintenanceController.getContractAmountsByType(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      'No hay información disponible',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  Map<String, double> data = snapshot.data!;
                  List<BarChartGroupData> barGroups = [];
                  int index = 0;

                  data.forEach((tipoContrato, monto) {
                    barGroups.add(
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: monto,
                            color: Colors.lightBlueAccent,
                            width: 15,
                          )
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    );
                    index++;
                  });

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: BarChart(
                      BarChartData(
                        barGroups: barGroups,
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                const style = TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                );
                                if (value.toInt() < data.keys.length) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 3.0,
                                    child: Text(data.keys.elementAt(value.toInt()), style: style),
                                  );
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text(
                                  '\$${(value / 1000).toStringAsFixed(1)}k',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                            ),
                          ),
                        ),
                        gridData: const FlGridData(show: true),
                        borderData: FlBorderData(show: true),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '\$${rod.toY.toString()}',
                                const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para asignar colores a las secciones del gráfico
  Color getColor(String vehicleType) {
    switch (vehicleType) {
      case 'Camioneta':
        return Colors.blue;
      case 'Auto':
        return Colors.orange;
      case 'Motocicleta':
        return Colors.purple;
      default:
        return Colors.green;
    }
  }

  // Método para asignar colores a las secciones del gráfico
  Color? getColor2(String maintenanceType) {
    switch (maintenanceType) {
      case 'Mantenimiento 1':
        return Colors.blueGrey;
      case 'Mantenimiento 2':
        return Colors.brown;
      case 'Mantenimiento 3':
        return Colors.yellow[800];
      default:
        return Colors.green;
    }
  }

  // Método para obtener la descripción del tipo de mantenimiento
  String getMaintenanceDescription(String maintenanceType) {
    switch (maintenanceType) {
      case 'Mantenimiento 1':
        return 'Cambio de aceite, revisión y cambio de pastillas, líquido de frenos y filtro de combustible.';
      case 'Mantenimiento 2':
        return 'Mantenimiento 1 más cambio de filtro de aire (excepto motocicletas), cambio del líquido refrigerante y cambio de luces delanteras y posteriores.';
      case 'Mantenimiento 3':
        return 'Cambio de batería y ajustes en el sistema eléctrico.';
      default:
        return 'Descripción no disponible';
    }
  }

}
