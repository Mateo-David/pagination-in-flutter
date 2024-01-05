import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PaginationController extends GetxController {
  final baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  int page = 0;

  final int limit = 20;

  bool isFirstLoadRunning = false;
  bool hasNextPage = true;

  bool isLoadMoreRunning = false;

  List posts = [];

  void _loadMore() async {
    if (hasNextPage == true &&
        isFirstLoadRunning == false &&
        isLoadMoreRunning == false &&
        scrollController.position.extentAfter < 300) {
      // setState(() {
      isLoadMoreRunning = true; // Display a progress indicator at the bottom
      // });
      update();

      page += 1; // Increase _page by 1

      try {
        final res =
            await http.get(Uri.parse("$baseUrl?_page=$page&_limit=$limit"));

        final List fetchedPosts = json.decode(res.body);
        if (fetchedPosts.isNotEmpty) {
          // setState(() {
          posts.addAll(fetchedPosts);
          // });
          update();
        } else {
          // setState(() {
          hasNextPage = false;
          // });
          update();
        }
      } catch (err) {
        if (kDebugMode) {
          print('Something went wrong!');
        }
      }

      // setState(() {
      isLoadMoreRunning = false;
      // });
      update();
    }
  }

  void firstLoad() async {
    // setState(() {
    isFirstLoadRunning = true;
    // });
    update();
    try {
      final res =
          await http.get(Uri.parse("$baseUrl?_page=$page&_limit=$limit"));
      // setState(() {
      posts = json.decode(res.body);
      // });
      update();
    } catch (err) {
      if (kDebugMode) {
        print('Something went wrong');
      }
    }

    // setState(() {
    isFirstLoadRunning = false;
    // });
    update();
  }

  late ScrollController scrollController;
  @override
  void onInit() {
    super.onInit();
    firstLoad();
    scrollController = ScrollController()..addListener(_loadMore);
  }
}
