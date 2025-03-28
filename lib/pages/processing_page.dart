// lib/pages/processing_page.dart
import 'package:flutter/material.dart';
import '../common/widgets/custom_scaffold.dart';
import '../widgets/data_table_widget.dart';

class ProcessingPage extends StatelessWidget {
  const ProcessingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: 'PROCESSING',
      currentIndex: 0, // Assuming this is the home tab
      body: Card(
        margin: const EdgeInsets.all(8.0),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: const ProcessingDataTable(),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            // Refresh data
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Refreshing data...'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Open search
            showSearch(context: context, delegate: ProcessingSearchDelegate());
          },
        ),
      ],
    );
  }
}

class ProcessingSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(child: Text('Search results for: $query'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Enter search criteria'));
  }
}
