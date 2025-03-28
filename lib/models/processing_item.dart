enum SignalStatus {
  pending,
  success,
  failed
}

class ProcessingItem {
  final String itemName;
  final String orderNumber;
  final int quantity;
  final int exception;
  final String timestamp;
  final SignalStatus status;

  ProcessingItem({
    required this.itemName,
    required this.orderNumber,
    required this.quantity,
    required this.exception,
    required this.timestamp,
    required this.status,
  });

  factory ProcessingItem.fromJson(Map<String, dynamic> json) {
    return ProcessingItem(
      itemName: json['itemName'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      quantity: json['quantity'] ?? 0,
      exception: json['exception'] ?? 0,
      timestamp: json['timestamp'] ?? '',
      status: _parseStatus(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'orderNumber': orderNumber,
      'quantity': quantity,
      'exception': exception,
      'timestamp': timestamp,
      'status': status.toString().split('.').last,
    };
  }

  static SignalStatus _parseStatus(String? status) {
    if (status == 'success') return SignalStatus.success;
    if (status == 'failed') return SignalStatus.failed;
    return SignalStatus.pending;
  }
}