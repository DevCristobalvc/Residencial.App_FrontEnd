import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PinEntryScreen extends StatefulWidget {
  @override
  _PinEntryScreenState createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  String _pin = '';

  // Mapa que relaciona los PINs con los valores de URL respectivos
  final Map<String, String> pinToUrl = {
    '0301': 'REU63E',
    '1102': 'NMM673',
    '0103': 'CUL951',
    '1001': 'SWC82D',
    '1002': 'URUS',
  };

  void _onNumberPress(String number) {
    setState(() {
      if (_pin.length < 4) {
        // Suponiendo que el PIN tiene 4 dígitos
        _pin += number;
      }
    });
  }

  Future<void> _validatePin() async {
    // Definir el endpoint base
    var baseUrl = 'http://localhost:4000/registro/';

    // Verificar si el PIN está en el mapa pinToUrl
    if (pinToUrl.containsKey(_pin)) {
      // Obtener el valor de URL correspondiente al PIN
      var value = pinToUrl[_pin];

      // Construir la URL completa con el valor de URL obtenido
      var url = Uri.parse(baseUrl + value!);

      // Realizar la solicitud HTTP GET
      var response = await http.post(url);

      // Verificar el código de estado de la respuesta
      if (response.statusCode == 200) {
        // El PIN se validó correctamente
        print('PIN validado y estado actualizado exitosamente');
        // Línea para reiniciar el valor del PIN y refrescar la página
        setState(() {
          _pin = '';
        });
      } else {
        // Mostrar el mensaje de error
        print('Error al validar el PIN: ${response.body}');
      }
    } else {
      // El PIN ingresado no está en el mapa pinToUrl
      print('PIN no válido');
    }
  }

  Widget _buildNumberButton(String number) {
    return Container(
      width: 75, // Ajustar para el tamaño del botón
      height: 75, // Ajustar para el tamaño del botón
      margin: EdgeInsets.all(10), // Espacio alrededor del botón
      child: ElevatedButton(
        onPressed: () => _onNumberPress(number),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade800, // Color del botón
          shape: CircleBorder(), // Hace que el botón sea circular
        ),
        child: Text(
          number,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text('Residencial.App'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Hola CRISTOBAL, último registro 7:33 am',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20), // Añadir espacio si es necesario
          _buildStatusIndicator('RFID: DETECTADO', true),
          _buildStatusIndicator('GPS: DETECTADO', true),
          _buildStatusIndicator('BOTÓN: EN ESPERA', false),
          SizedBox(height: 40), // Añadir espacio si es necesario
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              padding: EdgeInsets.all(10),
              children: List.generate(10, (index) {
                // Ajustar el orden de los números para que el '0' esté en la última posición
                return _buildNumberButton(
                    index == 9 ? '0' : (index + 1).toString());
              }),
            ),
          ),
          ElevatedButton(
            onPressed: _validatePin,
            child: Text('Validar PIN'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(String text, bool isActive) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          Icon(
            isActive ? Icons.check_circle : Icons.remove_circle,
            color: isActive ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}
