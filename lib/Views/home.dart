import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/theme/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: background,
        // foregroundColor: black,
        centerTitle: true,
        title: const Text(
          "Todoee ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: const UserInformation(),
    );
  }
}

class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptController = TextEditingController();

  addTodo() async {
    if (titleController.text != "" && descriptController.text != "") {
      var time = DateTime.now();

      await FirebaseFirestore.instance
          .collection('todos')
          .doc(uid)
          .collection("mytasks")
          .doc(time.toString())
          .set({
        'title': titleController.text,
        'description': descriptController.text,
        'time': time.toString(),
        'timestamp': time,
        'ischecked': false,
      });
      titleController.clear();
      descriptController.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Task Added "),
        duration: Duration(seconds: 3),
      ));
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No title or description added"),
        ),
      );
    }
  }

  String uid = '';
  @override
  void initState() {
    super.initState();
    getuid();
  }

  getuid() async {
    User? user = FirebaseAuth.instance.currentUser;
    // uid = user!.uid;
    setState(() {
      uid = user!.uid;
    });
  }

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: background,
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('todos')
              .doc(uid)
              .collection('mytasks')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            if (!snapshot.hasData) {
              return const ScaffoldMessenger(child: Text("Cancelled"));
            } else {
              final docs = snapshot.data!.docs;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "My Tasks",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          var isChecked = (docs[index]['ischecked']);
                          var time =
                              (docs[index]['timestamp'] as Timestamp).toDate();
                          return ListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(top: 8),
                                  margin: const EdgeInsets.only(top: 14),
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  decoration: BoxDecoration(
                                      // color: white,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 6,
                                        ),
                                      ]),
                                  child: ListTile(
                                    leading: Checkbox(
                                        checkColor: white,
                                        fillColor:
                                            MaterialStateProperty.resolveWith(
                                                getColor),
                                        value: isChecked,
                                        onChanged: (bool? value) async {
                                          isChecked = value!;
                                          await FirebaseFirestore.instance
                                              .collection('todos')
                                              .doc(uid)
                                              .collection("mytasks")
                                              .doc(docs[index]['time'])
                                              .update({
                                            'ischecked': isChecked,
                                          });
                                        }),
                                    title: Text(
                                      docs[index]['title'],
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      docs[index]['description'] +
                                          "\n" +
                                          DateFormat.yMd()
                                              .add_jm()
                                              .format(time),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        // color: ,
                                      ),
                                    ),
                                    // isThreeLine: true,
                                    trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          // color: black,
                                        ),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection('todos')
                                              .doc(uid)
                                              .collection('mytasks')
                                              .doc(docs[index]['time'])
                                              .delete();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(" Task Deleted! "),
                                            ),
                                          );
                                        }),
                                  ),
                                )
                              ]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          // backgroundColor: primary,
          // foregroundColor: Colors.white,4
          splashColor: Colors.white,
          onPressed: () {
            setState(() {
              addTodosBox();
            });
          },
          child: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  addTodosBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text("Add Todo"),
            // contentPadding: EdgeInsets.all(10),
            content: Container(
              // color: Colors.white70,
              height: MediaQuery.of(context).size.height * 0.28,
              width: 400,
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: "Title",
                    ),
                  ),
                  TextField(
                    controller: descriptController,
                    decoration: const InputDecoration(
                      hintText: "Description",
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      ElevatedButton(
                        onPressed: addTodo,
                        child: const Text("Add"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  description(text) {
    return Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }
}
