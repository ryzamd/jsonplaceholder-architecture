import 'package:flutter/material.dart';
import '../models/processing_item.dart';

class ProcessingDataTable extends StatefulWidget {
  const ProcessingDataTable({super.key});

  @override
  State<ProcessingDataTable> createState() => _ProcessingDataTableState();
}

class _ProcessingDataTableState extends State<ProcessingDataTable> {
  late List<ProcessingItem> _items;
  late List<ProcessingItem> _filteredItems;
  String _sortColumn = "status"; // Default sort by status
  bool _ascending = true;

  @override
  void initState() {
    super.initState();
    _items = [
      ProcessingItem(
        itemName: 'Purple Lilac 13-4-11',
        orderNumber: 'P-452049',
        quantity: 50,
        exception: 0,
        timestamp: '2024-03-04 10:36:48.210479',
        status: SignalStatus.success,
      ),
      ProcessingItem(
        itemName: 'Purple Lilac 13-4-11',
        orderNumber: 'P-452049',
        quantity: 50,
        exception: 0,
        timestamp: '2024-03-04 10:36:48.210479',
        status: SignalStatus.success,
      ),
      ProcessingItem(
        itemName: 'Purple Lilac 13-4-11',
        orderNumber: 'P-452049',
        quantity: 50,
        exception: 0,
        timestamp: '2024-03-04 10:36:48.210479',
        status: SignalStatus.success,
      ),
      ProcessingItem(
        itemName: 'Purple Lilac 13-4-11',
        orderNumber: 'P-452049',
        quantity: 50,
        exception: 0,
        timestamp: '2024-03-04 10:36:48.210479',
        status: SignalStatus.success,
      ),
      ProcessingItem(
        itemName: 'Basic White 11-401TPG',
        orderNumber: '2015/P-452017/P-452018/P-452019/P-452027/P-452028',
        quantity: 49,
        exception: 1,
        timestamp: '2024-03-04 10:36:48.210479',
        status: SignalStatus.failed,
      ),
      ProcessingItem(
        itemName: 'Basic White 11-401TPG',
        orderNumber: '2015/P-452017/P-452018/P-452019/P-452027/P-452028',
        quantity: 49,
        exception: 1,
        timestamp: '2024-03-04 10:36:48.210479',
        status: SignalStatus.failed,
      ),
      ProcessingItem(
        itemName: 'Cyan Blue M-201',
        orderNumber: 'P-452050',
        quantity: 25,
        exception: 0,
        timestamp: '2024-03-04 11:42:18.321654',
        status: SignalStatus.pending,
      ),
      ProcessingItem(
        itemName: 'Cyan Blue M-201',
        orderNumber: 'P-452050',
        quantity: 25,
        exception: 0,
        timestamp: '2024-03-04 11:42:18.321654',
        status: SignalStatus.pending,
      ),
      ProcessingItem(
        itemName: 'Cyan Blue M-201',
        orderNumber: 'P-452050',
        quantity: 25,
        exception: 0,
        timestamp: '2024-03-04 11:42:18.321654',
        status: SignalStatus.pending,
      ),
    ];
    _filteredItems = List.from(_items);
    _sortItems();
  }

  void _sortItems() {
    setState(() {
      if (_sortColumn == "status") {
        _filteredItems.sort((a, b) {
          final aValue = a.status.index;
          final bValue = b.status.index;
          return _ascending
              ? aValue.compareTo(bValue)
              : bValue.compareTo(aValue);
        });
      } else if (_sortColumn == "timestamp") {
        _filteredItems.sort((a, b) {
          return _ascending
              ? a.timestamp.compareTo(b.timestamp)
              : b.timestamp.compareTo(a.timestamp);
        });
      }
    });
  }

  void _onSortColumn(String column) {
    setState(() {
      if (_sortColumn == column) {
        _ascending = !_ascending;
      } else {
        _sortColumn = column;
        _ascending = true;
      }
      _sortItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(),
        Expanded(child: _buildTableBody(context)),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 58,
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
          _buildSignalHeader(),
          _buildHeaderCell('Name', flex: 2),
          _buildHeaderCell('Order\nNumber', flex: 2),
          _buildHeaderCell('Quantity', flex: 2),
          _buildHeaderCell('Minus', flex: 2),
          _buildTimestampHeader(),
        ],
      ),
    );
  }

  Widget _buildSignalHeader() {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () => _onSortColumn("status"),
        child: SizedBox(
          child: Icon(
                _sortColumn == "status"
                    ? (_ascending ? Icons.arrow_upward : Icons.arrow_downward) : Icons.unfold_more,
                color: Colors.white,
                size: 20,
              ),
        ),
      ),
    );
  }

  Widget _buildTimestampHeader() {
    return Expanded(
      flex: 2,
      child: GestureDetector(
        onTap: () => _onSortColumn("timestamp"),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: const Text(
                  'Times',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Icon(
                _sortColumn == "timestamp"
                    ? (_ascending ? Icons.arrow_upward : Icons.arrow_downward)
                    : Icons.unfold_more,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildTableBody(BuildContext context) {
    return ListView.builder(
      itemCount: _items.length, // Show some empty rows to fill the table
      itemBuilder: (context, index) {
        return Container(
          height: 50,
          color: Color(0xFFFAF1E6),
          child: Padding(
            padding: EdgeInsets.all(0),
            child:_buildDataRow(_filteredItems[index])
          ),
        );
      },
    );
  }

  Widget _buildDataRow(ProcessingItem item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: _buildSignalIndicator(item.status),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Text(
              item.itemName,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Text(
              item.orderNumber,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.left,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        Expanded(
          flex: 2,
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
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              item.exception.toString(),
              style: TextStyle(
                fontSize: 13,
                color: item.exception > 0 ? Colors.red : Colors.black,
                fontWeight:
                    item.exception > 0 ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
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

  Widget _buildSignalIndicator(SignalStatus status) {
    Color color;
    IconData icon;

    switch (status) {
      case SignalStatus.success:
        color = Colors.green;
        icon = Icons.circle_rounded;
        break;
      case SignalStatus.pending:
        color = Colors.orange;
        icon = Icons.circle_rounded;
        break;
      case SignalStatus.failed:
        color = Colors.red;
        icon = Icons.circle_rounded;
        break;
    }

    return Container(
      alignment: Alignment.center,
      child: Icon(icon, color: color, size: 10),
    );
  }
}

String _formatTimestamp(String timestamp) {
  // Format timestamp for display if needed
  return timestamp.substring(
    0,
    16,
  ); // Just show date and time without milliseconds
}
