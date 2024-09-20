import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'welcome.dart'; // Import WelcomeScreen

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  // Function to handle user login
  Future<void> loginUser() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      try {
        final response = await http.get(
          Uri.parse('https://ujikom2024pplg.smkn4bogor.sch.id/0078728255/users.php'),
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);

          // Check if any user matches the entered username and password
          final user = data.firstWhere(
            (user) => user['username'] == username && user['password'] == password,
            orElse: () => null,
          );

          if (user != null) {
            // If user found, navigate to WelcomeScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomeScreen()), // Navigate to WelcomeScreen
            );
          } else {
            setState(() {
              _errorMessage = 'Invalid username or password';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'Error during login. Please try again.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter username and password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login'),
        backgroundColor: Color.fromARGB(255, 107, 168, 247), // Warna biru
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 107, 168, 247), // Warna biru
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Login'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}