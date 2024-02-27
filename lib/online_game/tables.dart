// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class OnlineTables extends StatelessWidget {
  const OnlineTables({
    required this.listUsers,
    required this.name,
    required this.id,
    super.key,
  });
  final List listUsers;
  final String name;
  final String id;

  @override
  Widget build(BuildContext context) {
    listUsers.sort((a, b) =>
        a['data']['records']['100'].compareTo(b['data']['records']['100']));
    List listUsersSort = listUsers.reversed.toList();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/info-back.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: false,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text('Таблицы рекордов'),
        ),
        body: Container(
          child: ListView.builder(
              itemCount: listUsersSort.length,
              itemBuilder: (context, index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text((index + 1).toString()),
                    Text(listUsersSort[index]['data']['name']),
                    Text(listUsersSort[index]['data']['records']['100']
                        .toString()),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
