import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    //o DART permite parâmetros opcionais, para tanto, basta colocá-los entre chaves
    //quem for passar um ou mais parâmetros opcionais, precisa passar no formato parametro: valor
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage('Flutter Demo Home Page'),
    );
  }

}

class MyHomePage extends StatefulWidget {
  ///chaves nos parâmetros, indicam a opcionalidade dos mesmos
  MyHomePage(this.title, {Key key}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  //membros que comecam com underline, são PRIVADOS
  int _numberOfSensors = 0;

  static const channel = const MethodChannel('app/sensors');

  void _findSensorsInPhisicalDevice() async{
    try {
      _showMyDialog();
      //assíncrona
      final int numberSensors = await channel.invokeMethod("checkSensors");

      setState(() {
        _numberOfSensors = numberSensors;
      });

      Navigator.pop(context);
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sensores"),
      ),
      body: Center(
        child: _numberOfSensors == 0 ?
          Text("Clique no FAB para saber quantos sensores seu dispositivo tem") :
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Este dispositivo possui:'),
              Text(
                '$_numberOfSensors',
                style: Theme.of(context).textTheme.headline4,
              ),
              Text('sensores'),
            ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _findSensorsInPhisicalDevice,
        tooltip: 'Increment',
        child: Icon(Icons.find_in_page),
      ),
    );
  }

  Future<void> _showMyDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aguarde'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Aguarde enquanto verificamos seu dispositivo!'),
              ],
            ),
          ),
        );
      },
    );
  }
}

