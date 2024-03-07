import 'package:flutter/material.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/widgets/breaking_news.dart';
import 'package:news_app/widgets/page_view.dart';
import 'package:news_app/widgets/sources.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<HomeProvider>(context, listen: false).fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(
              Icons.menu,
              size: 30,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
              icon: const Icon(Icons.search_outlined),
            ),
            const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 20,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Consumer<HomeProvider>(
        builder: (context, homeProvider, _) {
          if (homeProvider.result.hasError) {
            return Center(
              child: Text(
                homeProvider.result.error,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            );
          }
          return ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SourcesWidget(),
                ),
              ),
              PageViewWidget(),
              BreakingNewsWidget(),
            ],
          );
        },
      ),
    );
  }
}
