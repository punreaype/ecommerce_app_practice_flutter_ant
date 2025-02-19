import 'package:practice_7/model/product_model.dart';

class Invoice {
  final String invoiceID;
  final String address;
  final String contactNumber;
  final String paymentMethod;
  final List<ProductModel> products;
  final double subtotal;
  final double discount;
  final double total;
  final DateTime timestamp;
  final String status;

  Invoice({
    required this.invoiceID,
    required this.address,
    required this.contactNumber,
    required this.paymentMethod,
    required this.products,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.timestamp,
    this.status = 'Processing',
  });

  Map<String, dynamic> toMap() {
    return {
      'invoiceID': invoiceID,
      'address': address,
      'contactNumber': contactNumber,
      'paymentMethod': paymentMethod,
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
