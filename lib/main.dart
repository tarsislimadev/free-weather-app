import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

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
  double temperature = -100;
  String error = '';

  final dio = Dio();

  void requestOpenMeteoApi() {
    dio
        .get(
          'https://api.open-meteo.com/v1/forecast?latitude=-22.393518&longitude=-47.564724&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m',
        )
        .then((response) {
          setState(() {
            temperature = response.data['current']['temperature_2m'];
            error = ''; // Clear any previous errors
          });
        })
        .catchError((error) {
          print('Error fetching temperature: $error');
          setState(() {
            error = 'Error fetching temperature';
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    requestOpenMeteoApi();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Temperature:'),
            Text('$temperature°C'),
            if (error.isNotEmpty) Text(error)
          ],
        ),
      ),
    );
  }
}
