// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:zeepalmtodo/color.dart';
import 'package:zeepalmtodo/helper/authenticate.dart';
import 'package:zeepalmtodo/model/task_model.dart';
import 'package:zeepalmtodo/screens/task.dart';
import 'package:zeepalmtodo/services/auth.dart';
import 'package:zeepalmtodo/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseMethods service = DatabaseMethods();
  Future<List<Task>>? contacts;
  List<Task>? reterivedcontacts;
  bool changeColor = false;

  @override
  void initState() {
    super.initState();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    _initRetrieval(user.email);
  }

  Future<void> _initRetrieval(userID) async {
    contacts = service.retrieveTask(userID);
    reterivedcontacts = await service.retrieveTask(userID);
  }

  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Task');
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser!;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text("All Tasks",
              style: GoogleFonts.comicNeue(
                color: Colors.black,
                fontSize: 48,
                fontWeight: FontWeight.w500,
              )),
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 36, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () async {
                    await AuthService().signOut();
                    Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => Authenticate()));
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        changeColor = !changeColor;
                      });
                    },
                    onExit: (event) {
                      setState(() {
                        changeColor = !changeColor;
                      });
                    },
                    child: Tooltip(
                      message: "Logout",
                      child: Container(
                        decoration: BoxDecoration(
                            color: changeColor
                                ? Colors.red.withOpacity(0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.black, width: 1),
                            shape: BoxShape.rectangle),
                        child: const Icon(
                          Icons.logout_outlined,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: ResponsiveBreakpoints.of(context).isMobile
                ? const EdgeInsets.all(8)
                : const EdgeInsets.all(16),
            child: Stack(children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Task')
                        .where('user_id', isEqualTo: user.email)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        final contacts = snapshot.data!.docs;

                        return ListView.separated(
                            itemBuilder: (context, index) {
                              return Stack(children: [
                                TaskCard(
                                  name: contacts[index]['name'],
                                  label: contacts[index]['label'],
                                  deadline: contacts[index]['deadline'],
                                  isCompleted: contacts[index]['isCompleted'],
                                  description: contacts[index]['description'],
                                  date: contacts[index]['date'],
                                  time: contacts[index]['time'],
                                  userID:
                                      snapshot.data.docs[index].reference.id,
                                ),
                              ]);
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: snapshot.data!.docs.length);
                      } else {
                        return const Center(
                          child: Text("Add some new Tasks"),
                          //CircularProgressIndicator()
                        );
                      }
                    }),
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const AddTasks()));
                      },
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Tooltip(
                          message: "Add Task",
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.button),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 48,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ));
  }
}

class TaskCard extends StatefulWidget {
  String userID;
  String name;
  String label;
  String description;
  String deadline;
  bool isCompleted;
  Timestamp date;
  Timestamp time;
  TaskCard(
      {super.key,
      required this.userID,
      required this.name,
      required this.label,
      required this.deadline,
      required this.isCompleted,
      required this.description,
      required this.date,
      required this.time});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool changeColor = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      margin: ResponsiveBreakpoints.of(context).isMobile
          ? const EdgeInsets.symmetric(horizontal: 8, vertical: 8)
          : const EdgeInsets.symmetric(horizontal: 48, vertical: 8),
      decoration: BoxDecoration(
          color: widget.isCompleted
              ? AppColors.containerInside
              //const Color.fromARGB(154, 119, 144, 229)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(.1),
                offset: const Offset(0, 4),
                blurRadius: 10)
          ]),
      child: ListTile(
        /// Check icon
        leading: GestureDetector(
          onTap: () async {
            widget.isCompleted = !widget.isCompleted;
            Task task = Task(
                user_id: widget.userID,
                name: widget.name,
                label: widget.label,
                deadline: widget.deadline,
                description: widget.description,
                isCompleted: widget.isCompleted,
                date: widget.date.toDate(),
                time: widget.time.toDate());
            await DatabaseMethods().updateTask(widget.userID, task);
            setState(() {});
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
                color: widget.isCompleted ? AppColors.button : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: .8)),
            child: const Icon(
              Icons.check,
              color: Colors.white,
            ),
          ),
        ),

        /// title of Task
        title: Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 3),
          child: Row(
            children: [
              Text(
                widget.name,
                style: TextStyle(
                    color: widget.isCompleted
                        ? AppColors.containerInside
                        : Colors.black,
                    fontWeight: FontWeight.w500,
                    decoration:
                        widget.isCompleted ? TextDecoration.lineThrough : null),
              ),
              const SizedBox(
                width: 8,
              ),
              Container(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: widget.label == "High"
                      ? Colors.red.withOpacity(0.2)
                      : widget.label == "Medium"
                          ? Colors.yellow.withOpacity(0.2)
                          : Colors.lightGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: widget.label == "High"
                          ? Colors.red
                          : widget.label == "Medium"
                              ? Colors.orange
                              : Colors.green,
                      width: 0.5),
                ),
                child: Text(
                  widget.label,
                  style: TextStyle(
                      color: widget.label == "High"
                          ? Colors.red
                          : widget.label == "Medium"
                              ? Colors.orange
                              : Colors.green,
                      fontSize: 12),
                ),
              )
            ],
          ),
        ),

        /// Description of task
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.description,
              style: TextStyle(
                color: widget.isCompleted
                    ? AppColors.button
                    : const Color.fromARGB(255, 164, 164, 164),
                fontWeight: FontWeight.w300,
                decoration:
                    widget.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),

            /// Date & Time of Task
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                  top: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('hh:mm a').format(widget.time.toDate()),
                      style: TextStyle(
                          fontSize: 14,
                          color:
                              widget.isCompleted ? Colors.white : Colors.grey),
                    ),
                    Text(
                      DateFormat.yMMMEd().format(widget.date.toDate()),
                      style: TextStyle(
                          fontSize: 12,
                          color:
                              widget.isCompleted ? Colors.white : Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MouseRegion(
              onEnter: (event) {
                setState(() {
                  changeColor = !changeColor;
                });
              },
              onExit: (event) {
                setState(() {
                  changeColor = !changeColor;
                });
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    DatabaseMethods service = DatabaseMethods();
                    await service.deleteTask(widget.userID);
                    setState(() {});
                  },
                  child: Tooltip(
                    message: "Delete",
                    child: Icon(
                      Icons.delete_forever_outlined,
                      size: 36,
                      color: changeColor ? Colors.red : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => UpdateTasks(
                            userId: widget.userID,
                            name: widget.name,
                            label: widget.label,
                            deadline: widget.deadline,
                            description: widget.description,
                            isCompleted: widget.isCompleted,
                            date: widget.date,
                            time: widget.time)),
                  );
                },
                child: const Tooltip(
                  message: "Update",
                  child: Icon(
                    Icons.edit_outlined,
                    color: Colors.black,
                    size: 36,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
