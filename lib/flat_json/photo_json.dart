// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PhotoJson extends StatelessWidget {
  PhotoJson({super.key});
  final List<Photos> photoList = [];
  Future<List<Photos>> getPhotoApi() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (Map photo in data) {
        Photos photos = Photos(title: photo['title'], url: photo['url']);
        photoList.add(photos);
      }
    } else {
      return photoList;
    }
    return photoList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPhotoApi(),
        builder: (BuildContext context, AsyncSnapshot<List<Photos>> snapshot) {
          return ListView.builder(
            itemCount: 100,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  height: 100,
                  width: 100,
                  child: Row(
                    children: [
                      Expanded(child: Text(snapshot.data![index].title.toString())),
                      Image.network(snapshot.data![index].url.toString()),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class Photos {
  String title, url;
  Photos({required this.url, required this.title});
}
