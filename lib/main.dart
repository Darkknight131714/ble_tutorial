import 'package:ble/connected.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<DiscoveredDevice> result = [];
  late Stream<ConnectionStateUpdate> temp;
  String status = "IDK";
  Future<void> getDevices() async {
    final flutterReactiveBle = FlutterReactiveBle();

    result.clear();
    setState(() {});
    flutterReactiveBle.scanForDevices(
        withServices: [],
        scanMode: ScanMode.balanced,
        requireLocationServicesEnabled: true).listen((device) {
      bool flag = true;
      for (var de in result) {
        if (de.id == device.id) {
          flag = false;
          break;
        }
      }
      if (flag) {
        result.add(device);
        setState(() {});
      }
    }, onError: (err) {
      print("YO" + err);
    });
  }

  Future<void> connect(DiscoveredDevice device) async {
    FlutterReactiveBle().connectToDevice(id: device.id).listen((update) {
      setState(() {
        status = update.connectionState.toString();
        if (update.connectionState == DeviceConnectionState.connected) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => Connected(device: device)),
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(status),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              onTap: () async {
                await connect(result[index]);
              },
              title: Text(result[index].name),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getDevices();
        },
        child: Icon(Icons.scanner),
      ),
    );
  }
}
