import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:jsonplaceholder_app/common/widgets/custom_navbar.dart';
import 'package:jsonplaceholder_app/widgets/qr_scan_widgets.dart';
import 'package:jsonplaceholder_app/common/constants/key_code_constants.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> with WidgetsBindingObserver {
  MobileScannerController? _controller;
  final FocusNode _focusNode = FocusNode();

  // State variables
  bool _cameraActive = false;
  bool _torchEnabled = false;
  bool _isSaving = false;
  String? _currentScannedValue;
  DateTime? _lastSnackbarTime;
  String? _lastSnackbarMessage;
  DateTime? _lastScanTime;
  final List<List<String>> _scannedItems = [];

  // Material data
  Map<String, String> _materialData = {
    'Material Name': '',
    'ID Number': '',
    'Quantity': '',
    'Receipt Date': '',
    'Supplier': '',
  };

  // EventChannel for hardware scanner
  static const EventChannel _eventChannel = EventChannel(
    'com.example.jsonplaceholder_app/scanner',
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _focusNode.requestFocus();

    // Initialize hardware scanner listener
    _initializeHardwareScanner();
  }

  @override
  void dispose() {
    _cleanUpCamera();
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _cleanUpCamera();
    } else if (state == AppLifecycleState.resumed) {
      if (_cameraActive) {
        _initializeCamera();
      }
    }
  }

  void _initializeHardwareScanner() {
    debugPrint("QR DEBUG: Initializing hardware scanner event channel");
    _eventChannel.receiveBroadcastStream().listen(
      (dynamic scanData) {
        debugPrint("QR DEBUG: 📟 Hardware scanner data received: $scanData");
        if (scanData != null && scanData.toString().isNotEmpty) {
          // Process the data from hardware scanner
          _processScannedData(scanData.toString(), isFromHardwareScanner: true);
        }
      },
      onError: (dynamic error) {
        debugPrint("QR DEBUG: ❌ Hardware scanner error: $error");
        _showSnackbar("Scanner error: $error", backgroundColor: Colors.red);
      },
    );
    debugPrint("QR DEBUG: Hardware scanner initialized");
  }

  void _initializeCamera() {
    // Dispose of any existing controller first
    _cleanUpCamera();

    debugPrint("QR DEBUG: Initializing camera scanner");

    try {
      // Create a new controller with appropriate settings
      _controller = MobileScannerController(
        // Include all common barcode formats
        formats: const [
          BarcodeFormat.qrCode,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.ean8,
          BarcodeFormat.ean13,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
          BarcodeFormat.codabar,
        ],
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        returnImage: false, // Optimize memory
        torchEnabled: _torchEnabled,
      );

      if (_cameraActive) {
        debugPrint("QR DEBUG: Starting camera scanner");
        _controller?.start();
      }

      debugPrint("QR DEBUG: Camera initialization successful");
    } catch (e) {
      debugPrint("QR DEBUG: ⚠️ Camera initialization error: $e");

      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Camera initialization error: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _cleanUpCamera() {
    // Release camera controller properly
    if (_controller != null) {
      try {
        _controller?.stop();
        _controller?.dispose();
      } catch (e) {
        debugPrint("QR DEBUG: ⚠️ Error disposing camera: $e");
      }
      _controller = null;
    }
  }

  void _toggleCamera() {
    debugPrint("QR DEBUG: Toggle camera button pressed");
    setState(() {
      _cameraActive = !_cameraActive;

      if (_cameraActive) {
        if (_controller == null) {
          _initializeCamera();
        } else {
          _controller?.start();
        }
      } else if (_controller != null) {
        _controller?.stop();
      }
    });
  }

  Future<void> _toggleTorch() async {
    debugPrint("QR DEBUG: Toggle torch button pressed");
    if (_controller != null) {
      await _controller!.toggleTorch();
      setState(() {
        _torchEnabled = !_torchEnabled;
      });
    }
  }

  Future<void> _switchCamera() async {
    debugPrint("QR DEBUG: Switch camera button pressed");
    if (_controller != null) {
      await _controller!.switchCamera();
    }
  }

  // Controlled snackbar display method to prevent duplicates
  void _showSnackbar(String message, {Color backgroundColor = Colors.blue}) {
    // Prevent rapid duplicate snackbars
    final now = DateTime.now();
    if (_lastSnackbarTime != null && 
        now.difference(_lastSnackbarTime!).inSeconds < 2 &&
        _lastSnackbarMessage == message) {
      return; // Skip duplicate messages within 2 seconds
    }

    _lastSnackbarTime = now;
    _lastSnackbarMessage = message;

    // Hide any existing snackbar first
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    // Show the new snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    debugPrint(
      "QR DEBUG: === Barcode detected: ${capture.barcodes.length} ===",
    );

    if (capture.barcodes.isEmpty) {
      debugPrint("QR DEBUG: No barcodes detected in this frame");
      return;
    }

    for (final barcode in capture.barcodes) {
      final rawValue = barcode.rawValue;
      final format = barcode.format;
      final corners = barcode.corners;

      debugPrint("QR DEBUG: ---------- BARCODE INFO ----------");
      debugPrint("QR DEBUG: Format: $format");
      debugPrint("QR DEBUG: RawValue: $rawValue");
      debugPrint("QR DEBUG: Has corners: ${corners != null}");
      if (corners != null) {
        debugPrint("QR DEBUG: Number of corners: ${corners.length}");
      }

      if (rawValue == null || rawValue.isEmpty) {
        debugPrint("QR DEBUG: ⚠️ Empty barcode value");
        continue;
      }

      // Print QR value in console
      debugPrint("QR DEBUG: ✅ QR value success: $rawValue");

      // Process barcode
      _processScannedData(rawValue);

      // Use controlled snackbar display
      _showSnackbar("Scanned QR: $rawValue");

      // Stop processing after finding the first valid barcode
      break;
    }
  }

  void _processScannedData(String data, {bool isFromHardwareScanner = false}) {
    debugPrint("QR DEBUG: Starting to process scanned data: $data (Hardware: $isFromHardwareScanner)");

    if (data.isEmpty) {
      debugPrint("QR DEBUG: ⚠️ Empty data, skipping");
      return;
    }

    // Implement debounce for rapid scans
    final now = DateTime.now();
    if (_lastScanTime != null && now.difference(_lastScanTime!).inMilliseconds < 500) {
      debugPrint("QR DEBUG: ⚠️ Scan too fast, ignoring");
      return;
    }
    _lastScanTime = now;

    // Skip if already processed this data
    if (_currentScannedValue == data) {
      debugPrint("QR DEBUG: ⚠️ Data already processed, skipping");
      
      // Still show feedback for hardware scanner, even if duplicate
      if (isFromHardwareScanner) {
        _showSnackbar("Already scanned: $data", backgroundColor: Colors.orange);
      }
      return;
    }

    debugPrint("QR DEBUG: Updating UI with new data");

    try {
      setState(() {
        _currentScannedValue = data;

        // Process data into material information
        if (data.contains('/')) {
          debugPrint("QR DEBUG: Format contains '/'");
          _materialData = {
            'Material Name':
                '本白1-400ITPG 荷布DJT-8543 GUSTI TEX EPM 100% 315G 44"',
            'ID Number': data,
            'Quantity': '50.5',
            'Receipt Date': DateTime.now().toString().substring(0, 19),
            'Supplier': 'DONGJIN-USD',
          };
        } else {
          debugPrint("QR DEBUG: Standard format");
          _materialData = {
            'Material Name': 'Material ${data.hashCode % 1000}',
            'ID Number': data,
            'Quantity': '${(data.hashCode % 100).abs() + 10}',
            'Receipt Date': DateTime.now().toString().substring(0, 19),
            'Supplier': 'Supplier ${data.hashCode % 5 + 1}',
          };
        }

        // Add to scanned items list if not already present
        if (!_scannedItems.any((item) => item[0] == data)) {
          _scannedItems.add([data, 'Scanned', '1']);
          debugPrint("QR DEBUG: Added to scanned items list");
        }
      });

      // Show appropriate feedback
      if (isFromHardwareScanner) {
        _showSnackbar("Hardware scan: $data", backgroundColor: Colors.green);
      }

      debugPrint("QR DEBUG: ✅ Data processing successful");
      // Print material data values for checking
      _materialData.forEach((key, value) {
        debugPrint("QR DEBUG: $key: $value");
      });
    } catch (e) {
      debugPrint("QR DEBUG: ⚠️ Error processing data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error processing data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveData() async {
    debugPrint("QR DEBUG: Save button pressed");

    if (_materialData['ID Number']?.isEmpty ?? true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No data to save')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Simulate data saving process
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully')));
    }
  }

  void _clearScannedItems() {
    debugPrint("QR DEBUG: Clear button pressed");

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Clear Scanned Items'),
            content: const Text(
              'Are you sure you want to clear all scanned items?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _scannedItems.clear();
                    _materialData = {
                      'Material Name': '',
                      'ID Number': '',
                      'Quantity': '',
                      'Receipt Date': '',
                      'Supplier': '',
                    };
                    _currentScannedValue = null;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Clear'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("QR DEBUG: Building QRScanPage");

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SCAN PAGE',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade700,
        centerTitle: true,
        actions: [
          // Control buttons moved to app bar
          IconButton(
            icon: Icon(
              _torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: _torchEnabled ? Colors.yellow : Colors.white,
            ),
            onPressed: _cameraActive ? _toggleTorch : null,
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
            onPressed: _cameraActive ? _switchCamera : null,
          ),
          IconButton(
            icon: Icon(
              _cameraActive ? Icons.stop : Icons.play_arrow,
              color: _cameraActive ? Colors.red : Colors.white,
            ),
            onPressed: _toggleCamera,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _clearScannedItems,
          ),
        ],
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (KeyEvent event) {
          // Handle key events from hardware scanner
          if (event is KeyDownEvent) {
            debugPrint("QR DEBUG: Key pressed: ${event.logicalKey.keyId}");
            if (KeycodeConstants.scannerKeyCodes.contains(
              event.logicalKey.keyId,
            )) {
              debugPrint("QR DEBUG: Scanner key pressed");
            }
          }
        },
        child: Column(
          children: [
            // QR Camera Section
            Container(
              margin: const EdgeInsets.all(5),
              child: QRScannerWidget(
                controller: _controller,
                onDetect: (capture) {
                  debugPrint(
                    "QR DEBUG: QRScannerWidget calls onDetect callback",
                  );
                  _onDetect(capture);
                },
                isActive: _cameraActive,
                onToggle: () {
                  debugPrint(
                    "QR DEBUG: QRScannerWidget calls onToggle callback",
                  );
                  _toggleCamera();
                },
              ),
            ),

            // Material Info Section (table layout)
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                child: Column(
                  children: [
                    // Table-like layout for info
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFFAF1E6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            // Each info row as table row
                            _buildTableRow('ID', _materialData['ID Number'] ?? ''),
                            _buildDivider(),
                            _buildTableRow('Material Name', _materialData['Material Name'] ?? ''),
                            _buildDivider(),
                            _buildTableRow('Quantity', _materialData['Quantity'] ?? ''),
                            _buildDivider(),
                            _buildTableRow('Receipt Date', _materialData['Receipt Date'] ?? ''),
                            _buildDivider(),
                            _buildTableRow('Supplier', _materialData['Supplier'] ?? ''),
                          ],
                        ),
                      ),
                    ),
                    
                    // Save button
                    Container(
                      width: 120,
                      height: 40,
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: ElevatedButton(
                        onPressed: _saveData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 1),
    );
  }

  // Helper methods for table layout
  Widget _buildTableRow(String label, String value) {
    return Expanded(
      child: Row(
        children: [
          // Label side (left)
          Container(
            width: 72,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), bottomLeft: Radius.circular(5)),
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ),
          // Value side (right)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                value.isEmpty ? 'No Scan data' : value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: value.isEmpty ? Colors.black : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return SizedBox(
      height: 2,
    );
  }
}