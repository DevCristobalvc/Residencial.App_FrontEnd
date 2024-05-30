import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard View',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late Future<List<DashBoardItem>> futureDashBoardItems;
  DashBoardItem? selectedItem;

  @override
  void initState() {
    super.initState();
    futureDashBoardItems = fetchDashBoardItems();
  }

  Future<List<DashBoardItem>> fetchDashBoardItems() async {
    final response = await http
        .get(Uri.parse('http://localhost:4000/registro/usuarios-validos'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => DashBoardItem.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  Future<void> validarRegistro() async {
    if (selectedItem != null) {
      final response = await http.post(
        Uri.parse('http://localhost:4000/registro/validar'),
        body: json.encode({'placa': selectedItem!.placa}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print('Registro validado correctamente');
        setState(() {
          futureDashBoardItems = fetchDashBoardItems();
        });
      } else {
        print('Error al validar el registro');
      }
    } else {
      print('Selecciona un elemento antes de validar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xFF6C757D),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: validarRegistro,
          ),
          IconButton(
            icon: Icon(Icons.replay_outlined),
            onPressed: () {
              setState(() {
                futureDashBoardItems = fetchDashBoardItems();
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<DashBoardItem>>(
          future: futureDashBoardItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No hay residentes a la espera'));
            } else {
              final items = snapshot.data!;

              // Asegúrate de que selectedItem sea uno de los elementos en la lista
              if (selectedItem != null && !items.contains(selectedItem)) {
                selectedItem = null;
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        DropdownButton<DashBoardItem>(
                          hint: Text("Selecciona una placa"),
                          value: selectedItem,
                          onChanged: (DashBoardItem? newValue) {
                            setState(() {
                              selectedItem = newValue!;
                            });
                          },
                          items: items.map<DropdownMenuItem<DashBoardItem>>(
                              (DashBoardItem item) {
                            return DropdownMenuItem<DashBoardItem>(
                              value: item,
                              child: Text(item.placa),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 20.0),
                        selectedItem != null
                            ? UserInfoWidget(item: selectedItem!)
                            : Text(
                                'Selecciona una placa para ver los detalles'),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: ChartsWidget(),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  final DashBoardItem item;

  UserInfoWidget({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 145, 152, 160),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Residente',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Text('Placa: ${item.placa}'),
          Text('Nombre: ${item.nombre}'),
          Text('Torre: ${item.torre}'),
          Text('Apartamento: ${item.apartamento}'),
          Text('Celular: ${item.celular}'),
          Text('Último Registro: ${item.fecha}'),
          SizedBox(height: 20.0),
          Image.network(
            '${item.imagen}',
            height: 350.0,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object exception,
                StackTrace? stackTrace) {
              return Center(
                child: Text(
                  'Error al cargar la imagen',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChartsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 2,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 145, 152, 160),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: charts.PieChart<String>(
              _createPieData(),
              animate: true,
              defaultRenderer: charts.ArcRendererConfig<String>(
                arcWidth: 60,
                arcRendererDecorators: [
                  charts.ArcLabelDecorator<String>(
                    labelPosition: charts.ArcLabelPosition.outside,
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 145, 152, 160),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: charts.TimeSeriesChart(
              _createLineData(),
              animate: true,
            ),
          ),
        ),
      ],
    );
  }

  List<charts.Series<ChartData, String>> _createPieData() {
    final data = [
      ChartData('Dentro', 63, color: Colors.green),
      ChartData('Fuera', 70, color: Colors.red),
    ];

    return [
      charts.Series<ChartData, String>(
        id: 'Residencia',
        domainFn: (ChartData sales, _) => sales.label,
        measureFn: (ChartData sales, _) => sales.value,
        data: data,
        colorFn: (ChartData sales, _) =>
            charts.ColorUtil.fromDartColor(sales.color),
        labelAccessorFn: (ChartData sales, _) => '${sales.value}',
      )
    ];
  }

  List<charts.Series<TimeSeriesData, DateTime>> _createLineData() {
    final dataEntrada = [
      TimeSeriesData(DateTime(2024, 5, 10), 50),
      TimeSeriesData(DateTime(2024, 5, 11), 45),
      TimeSeriesData(DateTime(2024, 5, 12), 30),
      TimeSeriesData(DateTime(2024, 5, 13), 70),
    ];

    final dataSalida = [
      TimeSeriesData(DateTime(2024, 5, 10), 60),
      TimeSeriesData(DateTime(2024, 5, 11), 40),
      TimeSeriesData(DateTime(2024, 5, 12), 50),
      TimeSeriesData(DateTime(2024, 5, 13), 80),
    ];

    return [
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Entrada',
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: dataEntrada,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
      ),
      charts.Series<TimeSeriesData, DateTime>(
        id: 'Salida',
        domainFn: (TimeSeriesData data, _) => data.time,
        measureFn: (TimeSeriesData data, _) => data.value,
        data: dataSalida,
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
      ),
    ];
  }
}

class ChartData {
  final String label;
  final int value;
  final Color color;

  ChartData(this.label, this.value, {this.color = const Color(0xFF000000)});
}

class TimeSeriesData {
  final DateTime time;
  final int value;

  TimeSeriesData(this.time, this.value);
}

class DashBoardItem {
  final String placa;
  final String fecha;
  final String apartamento;
  final String imagen;
  final String nombre;
  final String torre;
  final String celular;

  DashBoardItem({
    required this.placa,
    required this.fecha,
    required this.apartamento,
    required this.imagen,
    required this.nombre,
    required this.torre,
    required this.celular,
  });

  factory DashBoardItem.fromJson(Map<String, dynamic> json) {
    return DashBoardItem(
      placa: json['placa'],
      fecha: json['fecha'],
      apartamento: json['apartamento'],
      imagen: json['imagen'],
      nombre: json['nombre'],
      torre: json['torre'],
      celular: json['celular'],
    );
  }
}
