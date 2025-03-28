import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Improved QR Scanner Widget
class QRScannerWidget extends StatelessWidget {
  final MobileScannerController? controller;
  final Function(BarcodeCapture)? onDetect;
  final bool isActive;
  final VoidCallback onToggle;
  
  const QRScannerWidget({
    super.key,
    required this.controller,
    required this.onDetect,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint("QR DEBUG: Building QRScannerWidget, camera active: $isActive");
    
    return Stack(
      children: [
        Container(
          height: 150, // Taller height to see the camera image
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade700, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: isActive && controller != null
              ? MobileScanner(
                  controller: controller!,
                  onDetect: (barcodes) {
                    debugPrint("QR DEBUG: onDetect called from MobileScanner");
                    if (onDetect != null) {
                      onDetect!(barcodes);
                    }
                  },
                  // Remove scanWindow to scan the entire frame
                  placeholderBuilder: (context, child) {
                    debugPrint("QR DEBUG: Showing placeholder");
                    return Container(
                      color: Colors.black,
                      child: const Center(
                        child: Text(
                          "Initializing camera...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, child) {
                    debugPrint("QR DEBUG: ⚠️ Camera error: ${error.errorCode}");
                    return Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red, size: 50),
                            const SizedBox(height: 16),
                            Text(
                              "Camera error: ${error.errorCode}",
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                controller!.stop();
                                controller!.start();
                              },
                              child: const Text("Try Again"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      "Camera is off",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
          ),
        ),
        
        // QR frame overlay
        if (isActive)
          Positioned.fill(
            child: Center(
              child: Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.all(5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(true, true),
                        _buildCorner(true, false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildCorner(false, true),
                        _buildCorner(false, false),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
  
  // Function to build a corner for the scanning frame
  Widget _buildCorner(bool isTop, bool isLeft) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Colors.redAccent, width: 4) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Colors.redAccent, width: 4) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Colors.redAccent, width: 4) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Colors.redAccent, width: 4) : BorderSide.none,
        ),
      ),
    );
  }
}

// The rest of the file remains the same as in the previous implementation
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelBgColor;
  final Color valueBgColor;
  
  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.labelBgColor = Colors.blue,
    this.valueBgColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label with gradient background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [labelBgColor, labelBgColor.withOpacity(0.8)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          // Value with better styling
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Text(
              value.isEmpty ? 'No data available' : value,
              style: TextStyle(
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Save Button Widget
class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  
  const SaveButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade600,
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 3,
        ),
        child: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text(
              'SAVE DATA',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
      ),
    );
  }
}

/// Scanner Controls
class ScannerControls extends StatelessWidget {
  final bool torchEnabled;
  final bool cameraActive;
  final VoidCallback onToggleCamera;
  final VoidCallback onToggleTorch;
  final VoidCallback onSwitchCamera;
  
  const ScannerControls({
    super.key,
    required this.torchEnabled,
    required this.cameraActive,
    required this.onToggleCamera,
    required this.onToggleTorch,
    required this.onSwitchCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            torchEnabled ? Icons.flash_on : Icons.flash_off,
            color: torchEnabled ? Colors.yellow : Colors.grey,
          ),
          onPressed: cameraActive ? onToggleTorch : null,
        ),
        IconButton(
          icon: const Icon(Icons.flip_camera_ios),
          onPressed: cameraActive ? onSwitchCamera : null,
        ),
        IconButton(
          icon: Icon(
            cameraActive ? Icons.stop : Icons.play_arrow,
            color: cameraActive ? Colors.red : Colors.green,
          ),
          onPressed: onToggleCamera,
        ),
      ],
    );
  }
}

/// Scanned Items Table
class ScannedItemsTable extends StatelessWidget {
  final List<List<String>> scannedItems;
  
  const ScannedItemsTable({
    super.key,
    required this.scannedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Fixed height for the scanned items table
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          Expanded(
            child: scannedItems.isEmpty
              ? const Center(child: Text("No scanned items"))
              : ListView.builder(
                  itemCount: scannedItems.length,
                  itemBuilder: (context, index) {
                    return _buildTableRow(scannedItems[index]);
                  },
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      child: Row(
        children: const [
          Expanded(
            flex: 2,
            child: Text(
              "Code",
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "Status",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              "Quantity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(List<String> rowData) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              rowData[0],
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Text(
              rowData.length > 1 ? rowData[1] : "Processing",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: rowData.length > 1 && rowData[1] == 'Scanned'
                    ? Colors.green
                    : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              rowData.length > 2 ? rowData[2] : "1",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Material Info Section Widget
class MaterialInfoSection extends StatelessWidget {
  final Map<String, String> materialData;
  final bool isSaving;
  final VoidCallback onSave;

  const MaterialInfoSection({
    super.key,
    required this.materialData,
    required this.isSaving,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Material info title with card-like appearance
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Colors.blue.shade800,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Text(
            'Material Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // Material info cards
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: materialData.entries.map((entry) {
              return InfoRow(
                label: entry.key,
                value: entry.value,
                labelBgColor: Colors.blue.shade700,
                valueBgColor: Colors.grey.shade600,
              );
            }).toList(),
          ),
        ),
        
        // Save button
        SaveButton(
          onPressed: onSave,
          isLoading: isSaving,
        ),
      ],
    );
  }
}

/// Scanned Items Section Widget
class ScannedItemsSection extends StatelessWidget {
  final List<List<String>> scannedItems;

  const ScannedItemsSection({
    super.key,
    required this.scannedItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Scanned Items',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Total: ${scannedItems.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ScannedItemsTable(scannedItems: scannedItems),
      ],
    );
  }
}

/// Widget khu vực quét QR
class QRScanSection extends StatelessWidget {
  final MobileScannerController? controller;
  final Function(BarcodeCapture)? onDetect;
  final bool isActive;
  final VoidCallback onToggle;

  const QRScanSection({
    super.key,
    required this.controller,
    required this.onDetect,
    required this.isActive,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: 360,
      margin: const EdgeInsets.all(5),
      child: QRScannerWidget(
        controller: controller,
        onDetect: onDetect,
        isActive: isActive,
        onToggle: onToggle,
      ),
    );
  }
}
