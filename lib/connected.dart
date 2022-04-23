import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class Connected extends StatefulWidget {
  DiscoveredDevice device;
  Connected({required this.device});

  @override
  State<Connected> createState() => _ConnectedState();
}

class _ConnectedState extends State<Connected> {
  Future<void> services(device) async {
    final result = await FlutterReactiveBle().discoverServices(device.id);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Connected Screen"),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {},
            child: Text("Disconnect"),
          ),
          ElevatedButton(
            onPressed: () async {
              await services(widget.device);
            },
            child: Text("Services"),
          ),
        ],
      ),
    );
  }
}
