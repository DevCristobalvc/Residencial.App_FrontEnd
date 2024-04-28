import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'pin_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add any state variables you need for the screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .grey.shade900, // Adjust to match the uploaded image's background
      appBar: AppBar(
        title: Text('Residencial.App'),
        centerTitle: true,
        backgroundColor: Colors.grey
            .shade900, // Adjust to match the uploaded image's top bar color
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Hola CRISTOBAL, ultimo registro 7:33 am',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                StatusIndicator(label: 'RFID: DETECTADO', isDetected: true),
                StatusIndicator(label: 'GPS: DETECTADO', isDetected: true),
                StatusIndicator(label: 'BOTÓN: EN ESPERA', isDetected: false),
                // Add a large round button here
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PinEntryScreen()),
                      );
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.green, // The color of the button
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.power_settings_new,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final String label;
  final bool isDetected;

  const StatusIndicator({
    Key? key,
    required this.label,
    required this.isDetected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDetected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
