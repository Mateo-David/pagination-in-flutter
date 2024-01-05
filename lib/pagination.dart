import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pagination/pagination_controller.dart';

class PaginationView extends StatelessWidget {
  const PaginationView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaginationController>(
      init: PaginationController(),
      builder: (controller) {
        return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Your news',
                style: TextStyle(color: Colors.black),
              ),
            ),
            body: controller.isFirstLoadRunning
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: controller.posts.length,
                          controller: controller.scrollController,
                          itemBuilder: (_, index) => Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            child: ListTile(
                              title: Text(controller.posts[index]['title']),
                              subtitle: Text(
                                controller.posts[index]['body'],
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (controller.isLoadMoreRunning == true)
                        const Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 40),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      if (controller.hasNextPage == false)
                        Container(
                          padding: const EdgeInsets.only(top: 30, bottom: 40),
                          color: Colors.amber,
                          child: const Center(
                            child: Text('You have fetched all of the content'),
                          ),
                        ),
                    ],
                  ));
      },
    );
  }
}
