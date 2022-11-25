import 'dart:convert';
import 'dart:io';

import 'package:contactbook/view_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';

class update_data extends StatefulWidget {
  int id;
  String name, contact, image;
  Database database;

  update_data(this.id, this.name, this.contact, this.image, this.database);

  @override
  State<update_data> createState() => _update_dataState();
}

class _update_dataState extends State<update_data> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  XFile? photo;
  bool t = false;

  @override
  void initState() {
    super.initState();
    t1.text = widget.name;
    t2.text = widget.contact;
  }

  @override
  Widget build(BuildContext context) {
    double status = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: status),
        child: Column(
          children: [
            TextField(
              // decoration: InputDecoration(hintText: "Enter Name :-"),
              controller: t1,
            ),
            SizedBox(
              height: 20,
            ),
            TextField(keyboardType: TextInputType.number, controller: t2),
            SizedBox(height: 20,),
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
                                      photo = (await imagePicker.pickImage(
                                          source: ImageSource.gallery));
                                      setState(() {
                                        t = true;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Galary")),
                                ElevatedButton(
                                    onPressed: () async {
                                      photo = (await imagePicker.pickImage(
                                          source: ImageSource.camera));
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
                    // child: Image.file(File(photo!.path))
                    child: (t == true)
                        ? Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image: FileImage(File(photo!.path)),
                                    fit: BoxFit.fill)),
                          )
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                    image:
                                        MemoryImage(base64Decode(widget.image)),
                                    fit: BoxFit.fill)),
                          )),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(140, 25),
                  primary: Colors.blueAccent,
                  onPrimary: Colors.black12,
                  elevation: 10,
                ),
                onPressed: () async {
                  {
                    String s1 = t1.text;
                    String s2 = t2.text;
                    if (t == true) {
                      widget.image = base64Encode(await photo!.readAsBytes());
                    }
                    // int c;
                    // c = int.parse(s2);

                    String u =
                        "update contact set name='$s1', contact = '$s2',image = '${widget.image}' where id = ${widget.id}";
                    int up = await widget.database.rawUpdate(u);
                    if (up == 1) {
                      print("This data is Update");
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return view_data(widget.database);
                        },
                      ));
                    } else {
                      print("This is not Update");
                    }
                  }
                },
                child: Text(
                  "Update",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ],
        ),
      ),
    );
  }
}
