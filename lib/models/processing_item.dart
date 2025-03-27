class ProcessingItem {
  final String itemName;
  final String orderNumber;
  final int quantity;
  final int exception;
  final String timestamp;

  ProcessingItem({
    required this.itemName,
    required this.orderNumber,
    required this.quantity,
    required this.exception,
    required this.timestamp,
  });

  factory ProcessingItem.fromJson(Map<String, dynamic> json) {
    return ProcessingItem(
      itemName: json['itemName'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      quantity: json['quantity'] ?? 0,
      exception: json['exception'] ?? 0,
      timestamp: json['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'orderNumber': orderNumber,
      'quantity': quantity,
      'exception': exception,
      'timestamp': timestamp,
    };
  }
}