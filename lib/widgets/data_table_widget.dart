// lib/widgets/data_table_widget.dart
import 'package:flutter/material.dart';
import '../common/constants/app_colors.dart';
import '../models/processing_item.dart';

class ProcessingDataTable extends StatelessWidget {
  ProcessingDataTable({super.key});

  final List<ProcessingItem> demoData = [
    ProcessingItem(
      itemName: 'Purple Lilac 13-4-11',
      orderNumber: 'P-452049',
      quantity: 50,
      exception: 0,
      timestamp: '2024-03-04 10:36:48.210479',
    ),
    ProcessingItem(
      itemName: 'Basic White 11-401TPG',
      orderNumber: '2015/P-452017/P-452018/P-452019/P-452027/P-452028',
      quantity: 49,
      exception: 1,
      timestamp: '2024-03-04 10:36:48.210479',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(),
        Expanded(
          child: _buildTableBody(context),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1d3557),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildHeaderCell('Material Name', flex: 2),
          _buildHeaderCell('Order Number', flex: 2),
          _buildHeaderCell('Quantity', flex: 1),
          _buildHeaderCell('Rejected', flex: 1),
          _buildHeaderCell('Timestamp', flex: 2),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.tableHeaderText,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTableBody(BuildContext context) {
    return ListView.builder(
      itemCount: 20, // Show some empty rows to fill the table
      itemBuilder: (context, index) {
        final bool hasData = index < demoData.length;
        final bool isEven = index % 2 == 0;
        
        // Row height based on content
        final double rowHeight = hasData ? (demoData[index].orderNumber.length > 30 ? 70.0 : 50.0) : 50.0;
        
        return Container(
          height: rowHeight,
          decoration: BoxDecoration(
            color: isEven
                ? Colors.white.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.75),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
          ),
          child: hasData
              ? _buildDataRow(demoData[index])
              : _buildEmptyRow(),
        );
      },
    );
  }

  Widget _buildDataRow(ProcessingItem item) {
    // Determine if order number is long and needs special handling
    final bool isLongOrderNumber = item.orderNumber.length > 30;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              item.itemName,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              item.orderNumber,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.left,
              maxLines: isLongOrderNumber ? 3 : 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              item.quantity.toString(),
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              item.exception.toString(),
              style: TextStyle(
                fontSize: 13,
                color: item.exception > 0 ? Colors.red : Colors.black,
                fontWeight: item.exception > 0 ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              _formatTimestamp(item.timestamp),
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyRow() {
    return Row(
      children: List.generate(
        5,
        (index) => Expanded(
          flex: index == 0 || index == 1 || index == 4 ? 2 : 1,
          child: const SizedBox(),
        ),
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    // Format timestamp for display if needed
    return timestamp.substring(0, 16); // Just show date and time without milliseconds
  }
}