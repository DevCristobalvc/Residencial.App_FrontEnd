import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

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

class DashboardView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Color(0xFF343A40),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: UserInfoWidget(),
            ),
            Expanded(
              flex: 3,
              child: ChartsWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFE9ECEF),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información del Usuario',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Text('Placa: ABC123'),
          Text('Nombre: Juan Pérez'),
          Text('Celular: 123-456-7890'),
          Text('Último Registro: 12/05/2024 10:30 AM'),
          SizedBox(height: 60.0), // Espacio adicional antes de la imagen
          Image.asset(
            'images/carro.png', // Reemplaza con la ruta correcta de tu imagen
            height: 330.0,
            width: 550.0,
            fit: BoxFit.cover,
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
              color: Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: charts.PieChart<String>(
              _createData(),
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
              color: Color(0xFFE9ECEF),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child:
                Placeholder(), // Aquí puedes agregar el gráfico de historial de entrada y salida
          ),
        ),
      ],
    );
  }

  List<charts.Series<ChartData, String>> _createData() {
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
}

class ChartData {
  final String label;
  final int value;
  final Color color;

  ChartData(this.label, this.value, {this.color = const Color(0xFF000000)});
}
