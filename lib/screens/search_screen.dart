import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:news_app/providers/search_provider.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, _) {
          if (searchProvider.result.hasError) {
            return Center(
              child: Text(
                searchProvider.result.error,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: TextField(
                controller: searchProvider.searchController,
                onChanged: (query) {
                  searchProvider.filterSearch(query);
                },
                decoration: const InputDecoration(
                  hintText: 'Search articles...',
                  border: InputBorder.none,
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: searchProvider.displayedArticles.length,
              itemBuilder: (context, index) {
                final article = searchProvider.displayedArticles[index];
                String truncatedDescription = article.description != null &&
                        article.description!.length >= 35
                    ? article.description!.substring(0, 30)
                    : article.description ?? '';
                String truncatedTitle =
                    article.title != null && article.title!.length >= 30
                        ? article.title!.substring(0, 25)
                        : article.title ?? '';
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              if (article.urlToImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl: article.urlToImage!,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$truncatedTitle..',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  Text('$truncatedDescription..'),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        thickness: 1,
                        color: Colors.grey,
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
