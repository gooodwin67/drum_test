// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
        a['data']['records']['80'].compareTo(b['data']['records']['80']));
    List listUsers80 = listUsers
        .where((element) => element['data']['records']['80'] > 0)
        .toList()
        .reversed
        .toList();
    listUsers.sort((a, b) =>
        a['data']['records']['100'].compareTo(b['data']['records']['100']));
    //List listUsers100 = listUsers.reversed.toList();
    List listUsers100 = listUsers
        .where((element) => element['data']['records']['100'] > 0)
        .toList()
        .reversed
        .toList();
    listUsers.sort((a, b) =>
        a['data']['records']['120'].compareTo(b['data']['records']['120']));
    List listUsers120 = listUsers
        .where((element) => element['data']['records']['120'] > 0)
        .toList()
        .reversed
        .toList();
    //List listUsersSort = listUsers.reversed.toList();
    return DefaultTabController(
      length: 3,
      child: Container(
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
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, kToolbarHeight * 1.5),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  TabBar(
                    labelPadding: EdgeInsets.zero,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    tabs: [
                      Container(
                        width: double.infinity,
                        color: Color.fromARGB(255, 249, 255, 214),
                        child: Tab(text: '80bpm'),
                      ),
                      Container(
                        width: double.infinity,
                        color: Color.fromARGB(255, 249, 255, 214),
                        child: Tab(text: '100bpm'),
                      ),
                      Container(
                        width: double.infinity,
                        color: Color.fromARGB(255, 249, 255, 214),
                        child: Tab(text: '120bpm'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Text(
                          'Место',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Text(
                          'Никнейм',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width / 3.2,
                        child: Text(
                          'Счет',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 10),
            child: TabBarView(
              children: [
                RecordTap(list: listUsers80, bpm: '80', id: id),
                RecordTap(list: listUsers100, bpm: '100', id: id),
                RecordTap(list: listUsers120, bpm: '120', id: id),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecordTap extends StatelessWidget {
  const RecordTap({
    super.key,
    required this.list,
    required this.bpm,
    required this.id,
  });

  final List list;
  final String bpm;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimationLimiter(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 100,
                child: FadeInAnimation(
                  duration: Duration(milliseconds: 500),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: list[index]['data']['id'] == id
                                ? Color.fromARGB(255, 245, 255, 157)
                                : Color.fromARGB(255, 255, 240, 239),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3.2,
                                child: Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3.2,
                                child: list[index]['data']['id'] == id
                                    ? Column(
                                        children: [
                                          SizedBox(height: 10),
                                          Text(
                                            'Мой рекорд',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(
                                                    255, 72, 115, 255)),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          Text(
                                            list[index]['data']['name'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            list[index]['data']['city'],
                                            style: TextStyle(fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width / 3.2,
                                child: Text(
                                  list[index]['data']['records'][bpm]
                                      .toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
