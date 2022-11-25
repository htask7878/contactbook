import 'dart:convert';
import 'dart:io';

import 'package:contactbook/view_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class one extends StatefulWidget {
  const one({Key? key}) : super(key: key);

  @override
  State<one> createState() => _oneState();
}

class _oneState extends State<one> {
  Database? database;
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  ImagePicker imagePicker = ImagePicker();
  XFile? img;
  bool t = false;

  @override
  void initState() {
    super.initState();
    ht_db();
  }

  ht_db() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'ht.db');

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE contact (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, contact TEXT, image TEXT)');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ht_database"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(hintText: "Enter Name :-"),
              controller: t1,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: "Enter Contact :-"),
                controller: t2),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      img = await imagePicker.pickImage(
                                          source: ImageSource.gallery);
                                      setState(() {
                                        t = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Galary")),
                                ElevatedButton(
                                    onPressed: () async {
                                      img = await imagePicker.pickImage(
                                          source: ImageSource.camera);
                                      setState(() {
                                        t = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("camera")),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Upload image",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(150, 50),
                    primary: Colors.grey,
                    onPrimary: Colors.purpleAccent,
                    elevation: 10,
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  child: (t == true)
                      ? Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              image: DecorationImage(
                                  image: FileImage(File(img!.path)),
                                  fit: BoxFit.fill)),
                        )
                      : ColoredBox(
                          color: Colors.orange,
                        ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 50),
                  primary: Colors.grey,
                  onPrimary: Colors.purpleAccent,
                  elevation: 10,
                ),
                onPressed: () async {
                  {
                    if (t1.text == "" || t2.text == "") {
                      print("This is not possible...");
                    } else {
                      String s1, s2, s3;
                      s1 = t1.text;
                      s2 = t2.text;
                      s3 = base64Encode(await img!.readAsBytes());

                      String qry =
                          "insert into contact values (null,'$s1','$s2','$s3')";
                      // print("qry = $qry");
                      int rowid = await database!.rawInsert(qry);
                      print("r = $rowid");
                      t1.text = "";
                      t2.text = "";
                      setState(() {
                        t = false;
                      });
                    }
                  }
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(150, 50),
                  primary: Colors.grey,
                  onPrimary: Colors.purpleAccent,
                  elevation: 10,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return view_data(database);
                    },
                  ));
                },
                child: Text(
                  "View Data",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
