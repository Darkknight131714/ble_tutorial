import 'package:ble/connected.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
  List<BluetoothDevice> result = [];
  String status = "IDK";
  bool connecting = false;
  Future<void> getDevices() async {
    final flutterBlue = FlutterBlue.instance;

    result.clear();
    flutterBlue.connectedDevices
        .asStream()
        .listen((List<BluetoothDevice> devices) {
      for (BluetoothDevice device in devices) {
        result.add(device);
        print("HEy" + device.toString());
      }
    });
    setState(() {});
    flutterBlue.startScan(
      timeout: Duration(seconds: 2),
    );

// Listen to scan results
    var subscription = flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        result.add(r.device);
        setState(() {});
      }
    });

// Stop scanning
    flutterBlue.stopScan();
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      setState(() {
        connecting = true;
      });
      await device.connect();
      setState(() {
        connecting = false;
        result.clear();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: ((context) {
            return Connected(device: device);
          }),
        ),
      );
    } catch (e) {
      if (e.toString() !=
          "PlatformException(already_connected, connection with device already exists, null, null)") {
        print("HHHH" + e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Couldnt Connect"),
          ),
        );
        setState(() {
          connecting = false;
        });
      } else {
        setState(() {
          connecting = false;
          result.clear();
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: ((context) {
              return Connected(device: device);
            }),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(status),
      ),
      body: connecting
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
