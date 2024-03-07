import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/source_model.dart';
import '../providers/source_provider.dart';

class SourceArticlesPage extends StatelessWidget {
  final String category;

  const SourceArticlesPage({Key? key, required this.category})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Articles: ${StringUtils.capitalizeFirstLetter(category)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<SourceProvider>(
        builder: (context, sourceProvider, _) {
          List<Sources> filteredSources = sourceProvider.sources
              .where((source) => source.category == category)
              .toList();
          if (sourceProvider.result.hasError) {
            return Center(
              child: Text(
                sourceProvider.result.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return ListView.builder(
            itemCount: filteredSources.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  filteredSources[index].name ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  filteredSources[index].description ?? '',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
