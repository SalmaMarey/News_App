import 'package:cached_network_image/cached_network_image.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({super.key});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(builder: (context, homeProvider, _) {
      return Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8, left: 15, right: 15),
        child: SizedBox(
          height: 340,
          child: PageView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                homeProvider.news.length >= 3 ? 3 : homeProvider.news.length,
            itemBuilder: (BuildContext context, int index) {
              final article = homeProvider.news.elementAt(index);

              if (article.title == "[Removed]") {
                return Container();
              } else {
                return Builder(
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (article.urlToImage != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl: article.urlToImage!,

                                    // width: 200,
                                    height: 340,
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              if (article.urlToImage == null)
                                const Column(
                                  children: [
                                    SizedBox(
                                      height: 80,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error),
                                        SizedBox(width: 5),
                                        Text('Image not available')
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          left: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 44),
                            color: Colors.black54,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  (article.title?.length ?? 0) > 30
                                      ? '${article.title!.substring(0, 30)}...'
                                      : article.title ?? 'unknown',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  article.author ?? '',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  homeProvider.formatDateTime(
                                          article.publishedAt) ??
                                      'Unknown',
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 3,
                                ),
                                Center(
                                  child: DotsIndicator(
                                    dotsCount: 3,
                                    position: index,
                                    decorator: const DotsDecorator(
                                      color: Colors.white,
                                      activeColor:
                                          Color.fromARGB(255, 77, 77, 77),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
      );
    });
  }
}
