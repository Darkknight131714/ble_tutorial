import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class Connected extends StatefulWidget {
  BluetoothDevice device;
  Connected({required this.device});

  @override
  State<Connected> createState() => _ConnectedState();
}

class _ConnectedState extends State<Connected> {
  List<BluetoothService> serv = [];
  Future<void> services(BluetoothDevice device) async {
    final flutterBlue = FlutterBlue.instance;
    List<BluetoothService> services = await device.discoverServices();
    services.forEach((service) {
      setState(() {
        serv.add(service);
      });
      // print(service.uuid.toString());
    });
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Screen"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            onPressed: () async {
              await disconnect(widget.device);
            },
            child: Text("Disconnect"),
          ),
          ElevatedButton(
            onPressed: () async {
              await services(widget.device);
            },
            child: Text("Services"),
          ),
          const SizedBox(
            height: 50,
          ),
          Text("Services"),
          Flexible(
            child: ListView.builder(
              itemCount: serv.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(serv[index].uuid.toString()),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
