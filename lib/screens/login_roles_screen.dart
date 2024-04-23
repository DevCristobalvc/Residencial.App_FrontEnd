// Pantalla de selección de roles.

import 'package:flutter/material.dart';
import 'login_screen.dart';

class LoginRolesScreen extends StatelessWidget {
  const LoginRolesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF808080), // Fondo blanco para la pantalla
      appBar: AppBar(
        title: const Text('LoginRoles'),
        centerTitle: true,
        backgroundColor: Colors.transparent, // AppBar transparente
        elevation: 0, // Sin sombra
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize:
                MainAxisSize.min, // Columna del tamaño de su contenido
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png', // Asegúrate de que la ruta del asset sea correcta
                  height: 120.0,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Seleccione su rol',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              ...['Residente', 'Vigilante', 'Administrador', 'Ayuda'].map(
                (String role) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (role == 'Residente') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      } else {
                        // Aquí puedes manejar otros roles o mostrar un mensaje
                      }
                    },
                    child: Text(role),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                          0xFF6C757D), // Color gris oscuro para el fondo del botón
                      foregroundColor:
                          Colors.black, // Color del texto del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            30), // Botones con bordes redondeados
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 40),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
