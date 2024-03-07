import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/source_model.dart';
import '../providers/source_provider.dart';
import '../screens/source_article_screen.dart';

class SourcesWidget extends StatefulWidget {
  const SourcesWidget({Key? key}) : super(key: key);

  @override
  State<SourcesWidget> createState() => _SourcesWidgetState();
}

class _SourcesWidgetState extends State<SourcesWidget> {
  final Set<String> _uniqueCategories = <String>{};

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final sourceProvider =
          Provider.of<SourceProvider>(context, listen: false);
      sourceProvider.fetchSources();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SourceProvider>(
      builder: (context, sourceProvider, _) {
        if (sourceProvider.result.hasError) {
          return Center(
            child: Text(
              sourceProvider.result.error,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return SizedBox(
          height: 50,
          child: Row(
            children: sourceProvider.sources.map((source) {
              if (!_uniqueCategories.contains(source.category)) {
                _uniqueCategories.add(source.category ?? 'no');
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SourceArticlesPage(
                            category: source.category ?? 'no'),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 40,
                    margin: const EdgeInsets.only(right: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Center(
                      child: Text(
                        StringUtils.capitalizeFirstLetter(
                            source.category ?? 'no'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            }).toList(),
          ),
        );
      },
    );
  }
}
