import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qwiklink Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PingPage(),
    );
  }
}

class PingPage extends StatefulWidget {
  const PingPage({super.key});

  @override
  State<PingPage> createState() => _PingPageState();
}

class _PingPageState extends State<PingPage> {
  String _message = 'Press the button to ping backend';

  Future<void> _pingBackend() async {
    try {
      const String baseUrl = 'http://10.125.144.52:3000/'; // ✅ explicitly root
      final uri = Uri.parse(baseUrl);

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _message = data['message'] ?? 'No message field in response';
        });
      } else {
        setState(() {
          _message = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Qwiklink Backend Test')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_message, textAlign: TextAlign.center),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pingBackend,
        child: const Icon(Icons.send),
      ),
    );
  }
}
