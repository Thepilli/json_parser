import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_parser/nested_json/user_model.dart';
import 'package:http/http.dart' as http;

class UsersJson extends StatelessWidget {
  UsersJson({super.key});

  final List<UserModel> userList = [];
  Future<List<UserModel>> getUserApi() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      userList.clear();
      for (var user in data) {
        userList.add(UserModel.fromJson(user));
      }
    } else {
      return userList;
    }
    return userList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder(
        future: getUserApi(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            return ListView.builder(
              itemCount: userList.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(userList[index].id.toString()),
                  ),
                  title: Text(userList[index].name.toString()),
                  subtitle: Text('${userList[index].address!.city.toString()},  ${userList[index].address!.street.toString()}'),
                  trailing: SizedBox(
                    height: 100,
                    width: 100,
                    child: Column(
                      children: [
                        Text(userList[index].address!.geo!.lat.toString()),
                        Text((userList[index].address!.geo!.lng).toString()),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      )),
    );
  }
}
