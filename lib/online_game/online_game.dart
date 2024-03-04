import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drum_test/online_game/player_widget_online.dart';
import 'package:drum_test/online_game/tables.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnlineGameWidget extends StatefulWidget {
  const OnlineGameWidget({super.key});

  @override
  State<OnlineGameWidget> createState() => _OnlineGameWidgetState();
}

class _OnlineGameWidgetState extends State<OnlineGameWidget> {
  bool dataLoaded = false;
  String name = '';
  String city = '';
  String id = '';
  bool haveName = false;
  var prefs;

  List<Map> listUsers = [];

  var db = FirebaseFirestore.instance;

  saveName(valueName, valueCity) async {
    if (valueName != '' && valueName.replaceAll(' ', '') != '') {
      id = DateTime.now().millisecondsSinceEpoch.toString();
      prefs.setString('name', name.trim());
      prefs.setString('city', city.trim());
      prefs.setString('id', id);
      prefs.setInt('80', 0);
      prefs.setInt('100', 0);
      prefs.setInt('120', 0);
      haveName = true;
      setState(() {});
      FocusScope.of(context).unfocus();

      var user = {
        'id': id,
        'name': name.trim(),
        'city': city.trim(),
        'records': {
          '80': 0,
          '100': 0,
          '120': 0,
        },
      };
      String nameDoc = '$name$id';

      await db.collection("users").doc(nameDoc).set(user).onError(
            (e, _) => print("Error writing document: $e"),
          );
      listUsers = [];
      getData();
    }
  }

  sharedInit() async {
    prefs = await SharedPreferences.getInstance();
    // prefs.remove('name');
    // prefs.remove('city');
    // prefs.remove('id');
    // prefs.remove('80');
    // prefs.remove('100');
    // prefs.remove('120');
    if (prefs.getString('name') == null) {
      haveName = false;
    } else {
      haveName = true;
      name = prefs.getString('name');
      id = prefs.getString('id');
      city = prefs.getString('city') ?? '';
    }
    setState(() {});
  }

  getData() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
    await db.collection("users").get().then((event) {
      for (var doc in event.docs) {
        //print("${doc.id} => ${doc.data()}");
        Map user = {
          'nameId': doc.id,
          'data': doc.data(),
        };
        listUsers.add(user);
      }
    });
    // listUsers.forEach((element) {
    //   print(element['data']['records']['100']);
    // });
    dataLoaded = true;
    setState(() {});
  }

  void saveNewRec(score, bpm) async {
    listUsers = listUsers.map((e) {
      if (e['data']['id'] == id) {
        e['data']['records'][bpm.toString()] = score;
      }
      return e;
    }).toList();
    setState(() {});
    await db.collection('users').doc('$name$id').set({
      'records': {bpm.toString(): score}
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    sharedInit();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          title: Text('Online соревнование'),
        ),
        body: !dataLoaded
            ? Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(top: 50),
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    haveName
                        ? Column(
                            children: [
                              Text(
                                'Привет $name',
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                              // Text(
                              //   'id: $id',
                              //   style: TextStyle(fontSize: 15),
                              //   textAlign: TextAlign.center,
                              // ),
                              SizedBox(height: 20),
                            ],
                          )
                        : Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    onChanged: (value) {
                                      name = value.trim();
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      isDense: true, // Added this
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      fillColor: Colors.red,
                                      label: Text(
                                        'Ваш никнейм',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 50,
                                  child: TextFormField(
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(20)
                                    ],
                                    onChanged: (value) {
                                      city = value.trim();
                                    },
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      isDense: true, // Added this
                                      contentPadding: EdgeInsets.all(8),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      fillColor: Colors.red,
                                      label: Text(
                                        'Ваш город (не обязательно)',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: const Color.fromARGB(
                                                255, 71, 71, 71)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.green),
                                        iconColor: MaterialStatePropertyAll(
                                            Colors.white),
                                      ),
                                      onPressed: () {
                                        saveName(name, city);
                                      },
                                      icon: Icon(Icons.save),
                                      label: Text(
                                        'Сохранить',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                    !haveName
                        ? SizedBox()
                        : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayerWidgetOnline(
                                                      listUsers: listUsers,
                                                      name: name,
                                                      id: id,
                                                      saveNewRec)));
                                    },
                                    child: Text('Играть')),
                                SizedBox(height: 20),
                                ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OnlineTables(
                                                      listUsers: listUsers,
                                                      name: name,
                                                      id: id)));
                                    },
                                    child: Text('Таблицы рекордов')),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
