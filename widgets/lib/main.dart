import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

// 🏠 Pantalla Principal con Imagen Dinámica
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _backgroundImage = 'assets/img1.jpg'; // Imagen por defecto

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
  }

  Future<void> _loadBackgroundImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _backgroundImage = prefs.getString('backgroundImage') ?? 'assets/img1.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(_backgroundImage, fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.3)), // Oscurecer fondo
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/profile'),
                child: Text('Ver Perfil'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await Navigator.pushNamed(context, '/settings');
                  _loadBackgroundImage(); // Recargar imagen después de configurar
                },
                child: Text('Configuración'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 👤 Pantalla de Perfil
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Perfil")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nombre: Juan Pérez", style: TextStyle(fontSize: 20)),
            Text("Correo: juanperez@email.com", style: TextStyle(fontSize: 20)),
            Text("Edad: 25", style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

// ⚙️ Pantalla de Configuración (para cambiar imagen de fondo)
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<String> images = ['assets/img1.jpg', 'assets/img2.jpg', 'assets/img3.jpg'];
  String _selectedImage = 'assets/background1.jpg';

  Future<void> _saveBackgroundImage(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('backgroundImage', imagePath);
    setState(() {
      _selectedImage = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Configuración de Fondo")),
      body: Column(
        children: images.map((imagePath) {
          return ListTile(
            leading: Image.asset(imagePath, width: 50, height: 50),
            title: Text(imagePath),
            trailing: _selectedImage == imagePath ? Icon(Icons.check, color: Colors.green) : null,
            onTap: () {
              _saveBackgroundImage(imagePath);
            },
          );
        }).toList(),
      ),
    );
  }
}
