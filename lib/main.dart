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
      title: 'Free Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
      ),
      home: const MyHomePage(title: 'Free Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var apiUrl = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=-22.393518&longitude=-47.564724&current=temperature_2m');

  late Future<String> forecast;

  Future<String> httpClientGet() async {
    try {
      var response = await http.Client().get(apiUrl);
      if (response.statusCode == 200) {
        Map<String, dynamic> respMap = jsonDecode(response.body.toString());
        return '${respMap['current']['temperature_2m']}${respMap['current_units']['temperature_2m']}';
      } else {
        return  '${response.statusCode} ${response.reasonPhrase}';
      }
    } catch (e) {
      return  'Error: $e';
    }
  }

  @override
  initState() {
    super.initState();
    forecast = httpClientGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Temperature:'),
            FutureBuilder(
              future: forecast,
              builder: (context, snapshot) {
                if (snapshot.hasData) return Text(snapshot.data!.toString());
                return Text('Loading...');
              },
            ),
          ],
        ),
      ),
    );
  }
}
