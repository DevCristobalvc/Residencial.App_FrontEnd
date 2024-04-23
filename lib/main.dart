import 'package:flutter/material.dart';
import 'screens/login_roles_screen.dart'; // Asegúrate de importar correctamente el archivo.

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Residencial App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const LoginRolesScreen(), // La pantalla inicial es LoginRolesScreen
    );
  }
}
