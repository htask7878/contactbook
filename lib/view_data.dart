import 'dart:convert';

import 'package:contactbook/update_data.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

class view_data extends StatefulWidget {
  Database? database;

  view_data(this.database);

  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {
  List<Map>? lm = [];

  // List name = [];
  // List contec = [];
  // List id = [];

  // Future view() async {
  //   String sql = "SELECT * FROM contact";
  //   List<Map> lmap = await widget.database!.rawQuery(sql);
  //
  //   return lmap;
  // }
  Future viewdata() async {
    String sql = "SELECT * FROM contact";
    List<Map> lm = await widget.database!.rawQuery(sql);
    return lm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: viewdata(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<Map> ml = snapshot.data as List<Map>;
            return ListView.separated(
              itemCount: ml.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.white60,
                thickness: 0.8,
              ),
              itemBuilder: (context, index) {
                Map m = ml[index];
                print(m);
                //base64Decode("${m['image']}"),
                return ListTile(
                  title: Text("${m['name']}"),
                  subtitle: Text("${m['contact']}"),
                  leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(
                                base64Decode("${m['image']}"),
                              ),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.all(Radius.circular(50)))),
                  trailing: PopupMenuButton(
                    color: Colors.orange,
                    elevation: 20,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          child: InkWell(
                        onTap: () async {
                          String d =
                              "delete from contact where id = ${m['id']}";
                          int de = await widget.database!.rawDelete(d);
                          if (de == 1) {
                            setState(() {});
                            print("delete row ");
                          } else {
                            print("not possible");
                          }
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            Text("Delete"),
                          ],
                        ),
                      )),
                      PopupMenuItem(
                        child: InkWell(
                          child: Row(
                            children: [
                              Icon(Icons.update),
                              Text(" Update"),
                            ],
                          ),
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                              builder: (context) {
                                return update_data(m['id'], m['name'],
                                    m['contact'], m['image'], widget.database!);
                              },
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return CircularProgressIndicator(
              color: Colors.grey,
              strokeWidth: 2,
            );
          }
        },
      ),
    );
  }
}
// if (snapshot.connectionState == ConnectionState.done) {
// if (snapshot.hasData) {
//   lm = snapshot.data as List<Map>?;
//   lm!.forEach((element) {
//     name.add(element['name']);
//     contec.add(element['contact']);
//     id.add(element['id']);
//   });
// }
// }
/*
async {
                      String d = "DELETE FROM contact WHERE  id= '${id[index]}'";
                      int t = await widget.database!.rawDelete(d);
                      print(t);

                      if (t == 1) {
                        setState(() {});
                      } else {
                        print("not possible.....");
                      }
                    },
 */
