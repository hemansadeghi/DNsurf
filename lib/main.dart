
import 'package:flutter/material.dart';
import 'vpn_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DNS VPN',
      debugShowCheckedModeBanner: false,
      home: const DNSHome(),
    );
  }
}

class DNSHome extends StatefulWidget {
  const DNSHome({super.key});

  @override
  State<DNSHome> createState() => _DNSHomeState();
}

class _DNSHomeState extends State<DNSHome> {
  final List<Map<String, String>> dnsList = [
    {'name': 'Google DNS', 'dns1': '8.8.8.8', 'dns2': '8.8.4.4'},
    {'name': 'Cloudflare Warp', 'dns1': '1.1.1.1', 'dns2': '1.0.0.1'},
    {'name': 'Electro DNS', 'dns1': '78.157.42.100', 'dns2': '78.157.42.101'},
    {'name': 'Shecan', 'dns1': '178.22.122.100', 'dns2': '185.51.200.2'},
    {'name': 'OpenDNS', 'dns1': '208.67.222.222', 'dns2': '208.67.220.220'},
    {'name': 'AdGuard DNS', 'dns1': '94.140.14.14', 'dns2': '94.140.15.15'},
  ];

  int selectedIndex = 0;
  bool isConnected = false;

  void toggleVPN() async {
    final dns = dnsList[selectedIndex];
    if (!isConnected) {
      await VPNController.startVPN(dns['dns1']!, dns['dns2']!);
    } else {
      await VPNController.stopVPN();
    }
    setState(() {
      isConnected = !isConnected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DNS VPN')),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: toggleVPN,
              child: Text(isConnected ? "Disconnect" : "Connect"),
            ),
          ),
          const SizedBox(height: 30),
          const Text("Select DNS"),
          Expanded(
            child: ListView.builder(
              itemCount: dnsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(dnsList[index]['name']!),
                  subtitle: Text('${dnsList[index]['dns1']} / ${dnsList[index]['dns2']}'),
                  trailing: Radio(
                    value: index,
                    groupValue: selectedIndex,
                    onChanged: (val) {
                      setState(() {
                        selectedIndex = val!;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
