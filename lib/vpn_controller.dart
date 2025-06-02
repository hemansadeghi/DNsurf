
import 'package:flutter/services.dart';

class VPNController {
  static const platform = MethodChannel('vpn_channel');

  static Future<void> startVPN(String dns1, String dns2) async {
    try {
      await platform.invokeMethod('startVPN', {'dns1': dns1, 'dns2': dns2});
    } on PlatformException catch (e) {
      print("Failed to start VPN: '${e.message}'.");
    }
  }

  static Future<void> stopVPN() async {
    try {
      await platform.invokeMethod('stopVPN');
    } on PlatformException catch (e) {
      print("Failed to stop VPN: '${e.message}'.");
    }
  }
}
