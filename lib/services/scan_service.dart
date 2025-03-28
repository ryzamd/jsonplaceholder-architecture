import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanService {
  static const EventChannel _eventChannel = EventChannel('com.example.scan_qr/scanner');
  static const MethodChannel _methodChannel = MethodChannel('com.example.scan_qr');
  
  // Callback for scan events
  static Function(String)? onBarcodeScanned;
  
  // List to keep track of scanned barcodes
  static final List<String> scannedBarcodes = [];

  // Initialize scanner listener
  static void initializeScannerListener(Function(String) onScanned) {
    onBarcodeScanned = onScanned;
    
    _eventChannel.receiveBroadcastStream().listen(
      (dynamic scanData) {
        if (scanData != null && scanData != "No Scan Data Found") {
          onBarcodeScanned?.call(scanData.toString());
          
          // Add to local history if not already there
          if (!scannedBarcodes.contains(scanData.toString())) {
            scannedBarcodes.add(scanData.toString());
          }
        }
      },
      onError: (dynamic error) {
        debugPrint("❌ Error receiving scan data: $error");
      }
    );
    
    // Set up method channel handler for scanner button press
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == "scannerKeyPressed") {
        String scannedData = call.arguments.toString();
        onBarcodeScanned?.call(scannedData);
      }
      return null;
    });
  }

  // Check if a key event is from the hardware scanner
  static bool isScannerButtonPressed(KeyEvent event) {
    // Common scanner button keycodes - you may need to adjust these
    const scannerKeyCodes = [120, 121, 122, 293, 294];
    return scannerKeyCodes.contains(event.logicalKey.keyId);
  }
}