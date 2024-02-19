// ignore_for_file: use_build_context_synchronously, await_only_futures, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:zeepalmtodo/color.dart';
import 'package:zeepalmtodo/model/task_model.dart';
import 'package:zeepalmtodo/screens/home.dart';
import 'package:zeepalmtodo/services/database.dart';
import 'package:zeepalmtodo/typography.dart';

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _AddTasksState();
}

class _AddTasksState extends State<AddTasks> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  String? _priority;
  final _formKey = GlobalKey<FormState>();
  DateTime? time = DateTime.now();
  DateTime? date = DateTime.now();
  DateTime showTimeAsDateTime(DateTime? time) {
    if (time == null) {
      return DateTime.now();
    } else {
      return time;
    }
  }

  String showTime(DateTime? time) {
    if (time == null) {
      return DateFormat('hh:mm a').format(DateTime.now()).toString();
    } else {
      return DateFormat('hh:mm a').format(time).toString();
    }
  }

  String showDate(DateTime? date) {
    if (date == null) {
      return DateFormat.yMMMEd().format(DateTime.now()).toString();
    } else {
      return DateFormat.yMMMEd().format(date).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (date == null) {
      return DateTime.now();
    } else {
      return date;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios)),
                ),
                Text(
                  "Create New Task",
                  style: AppTypography.textMd
                      .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Please fill up all inputs to create a new task account.",
                  textAlign: TextAlign.center,
                  style: AppTypography.textSm.copyWith(fontSize: 14),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Container(
                        width: ResponsiveBreakpoints.of(context).isMobile
                            ? MediaQuery.sizeOf(context).width
                            : MediaQuery.sizeOf(context).width * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 0, color: AppColors.button),
                            color: const Color.fromARGB(255, 211, 236, 247)),
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: Column(
                          children: [
                            FieldsFormat(
                              text: _nameController,
                              title: "Name*",
                              maxlines: 1,
                            ),
                            FieldsFormat(
                              text: _descriptionController,
                              title: "Description*",
                              maxlines: 1,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: DropdownButtonFormField(
                                isDense: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle_outlined,
                                  color: Colors.black,
                                ),
                                iconSize: 22.0,
                                iconEnabledColor:
                                    Theme.of(context).primaryColor,
                                items: _priorities.map((String priority) {
                                  return DropdownMenuItem(
                                    value: priority,
                                    child: Text(
                                      priority,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                style: const TextStyle(fontSize: 18.0),
                                decoration: InputDecoration(
                                  labelText: 'Priority',
                                  labelStyle: const TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                                validator: (input) => _priority == null
                                    ? 'Please select a priority level'
                                    : null,
                                onChanged: (value) {
                                  setState(() {
                                    _priority = value;
                                  });
                                },
                                value: _priority,
                              ),
                            ),

                            /// Time Picker
                            GestureDetector(
                              onTap: () {
                                DatePicker.showTimePicker(context,
                                    showTitleActions: true,
                                    showSecondsColumn: false,
                                    onChanged: (_) {},
                                    onConfirm: (selectedTime) {
                                  setState(() {
                                    time = selectedTime;
                                  });

                                  FocusManager.instance.primaryFocus?.unfocus();
                                }, currentTime: showTimeAsDateTime(time));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("Time"),
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: 80,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade100),
                                      child: Center(
                                        child: Text(
                                          showTime(time),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            /// Date Picker
                            GestureDetector(
                              onTap: () {
                                DatePicker.showDatePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    maxTime: DateTime(2030, 3, 5),
                                    onChanged: (_) {},
                                    onConfirm: (selectedDate) {
                                  setState(() {
                                    date = selectedDate;
                                  });
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }, currentTime: showDateAsDateTime(date));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 20),
                                width: double.infinity,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.grey.shade300, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text("Date"),
                                    ),
                                    Expanded(child: Container()),
                                    Container(
                                      margin: const EdgeInsets.only(right: 10),
                                      width: 140,
                                      height: 35,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey.shade100),
                                      child: Center(
                                        child: Text(
                                          showDate(date),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      DatabaseMethods service = DatabaseMethods();
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      final User user = await _auth.currentUser!;
                      Task task = Task(
                          user_id: user.email!,
                          name: _nameController.text,
                          label: _priority!,
                          deadline: _deadlineController.text,
                          description: _descriptionController.text,
                          isCompleted: false,
                          date: date!,
                          time: time!);

                      await service.addTask(task);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: ResponsiveBreakpoints.of(context).isMobile
                              ? MediaQuery.sizeOf(context).width * 0.8
                              : MediaQuery.sizeOf(context).width * 0.5,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.button),
                          child: Center(
                            child: Text("Add",
                                style: AppTypography.textMd.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

class FieldsFormat extends StatefulWidget {
  final String title;
  final TextEditingController text;
  final int maxlines;
  const FieldsFormat(
      {Key? key,
      required this.title,
      required this.text,
      required this.maxlines})
      : super(key: key);

  @override
  _FieldsFormatState createState() => _FieldsFormatState();
}

class _FieldsFormatState extends State<FieldsFormat> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        widget.title,
        style: AppTypography.textSm.copyWith(fontSize: 14),
      ),
      const SizedBox(
        height: 4,
      ),
      SizedBox(
        height: 55,
        child: TextFormField(
            enabled: true,
            textAlign: TextAlign.start,
            maxLines: widget.maxlines,
            decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(width: 0, color: Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(width: 0, color: Colors.white))),
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter ${widget.title}';
              }
              return null;
            },
            controller: widget.text),
      ),
      const SizedBox(
        height: 10,
      )
    ]);
  }
}

class UpdateTasks extends StatefulWidget {
  final String userId;
  final String name;
  final String label;
  final String description;
  final String deadline;
  final bool isCompleted;
  final Timestamp date;
  final Timestamp time;
  const UpdateTasks(
      {super.key,
      required this.userId,
      required this.name,
      required this.label,
      required this.description,
      required this.deadline,
      required this.isCompleted,
      required this.date,
      required this.time});

  @override
  State<UpdateTasks> createState() => _UpdateTasksState();
}

class _UpdateTasksState extends State<UpdateTasks> {
  late TextEditingController _nameController;
  late TextEditingController _deadlineController;
  late TextEditingController _descriptionController;
  final List<String> _priorities = ['Low', 'Medium', 'High'];
  late String? _priority;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _deadlineController = TextEditingController(text: widget.deadline);
    _descriptionController = TextEditingController(text: widget.description);
    _priority = widget.label;
  }

  late DateTime? time = widget.time.toDate();
  late DateTime? date = widget.date.toDate();
  final _formKey = GlobalKey<FormState>();

  DateTime showTimeAsDateTime(DateTime? time) {
    if (time == null) {
      return DateTime.now();
    } else {
      return time;
    }
  }

  String showTime(DateTime? time) {
    if (time == null) {
      return DateFormat('hh:mm a').format(DateTime.now()).toString();
    } else {
      return DateFormat('hh:mm a').format(time).toString();
    }
  }

  String showDate(DateTime? date) {
    if (date == null) {
      return DateFormat.yMMMEd().format(DateTime.now()).toString();
    } else {
      return DateFormat.yMMMEd().format(date).toString();
    }
  }

  DateTime showDateAsDateTime(DateTime? date) {
    if (date == null) {
      return DateTime.now();
    } else {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          Text(
            "Update Task",
            style: AppTypography.textMd
                .copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            "Please fill up all inputs to update task.",
            textAlign: TextAlign.center,
            style: AppTypography.textSm.copyWith(fontSize: 14),
          ),
          const SizedBox(
            height: 40,
          ),
          Form(
            key: _formKey,
            child: Container(
                width: ResponsiveBreakpoints.of(context).isMobile
                    ? MediaQuery.sizeOf(context).width
                    : MediaQuery.sizeOf(context).width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0, color: AppColors.button),
                    color: const Color.fromARGB(255, 211, 236, 247)),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  children: [
                    FieldsFormat(
                      text: _nameController,
                      title: "Name*",
                      maxlines: 1,
                    ),
                    FieldsFormat(
                      text: _descriptionController,
                      title: "Description*",
                      maxlines: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: DropdownButtonFormField(
                        isDense: true,
                        icon: const Icon(Icons.arrow_drop_down_circle_outlined,
                            color: Colors.black),
                        iconSize: 22.0,
                        iconEnabledColor: Theme.of(context).primaryColor,
                        items: _priorities.map((String priority) {
                          return DropdownMenuItem(
                            value: priority,
                            child: Text(
                              priority,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                              ),
                            ),
                          );
                        }).toList(),
                        style: const TextStyle(fontSize: 18.0),
                        decoration: InputDecoration(
                          labelText: 'Priority',
                          labelStyle: const TextStyle(fontSize: 18.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (input) => _priority == null
                            ? 'Please select a priority level'
                            : null,
                        onChanged: (value) {
                          setState(() {
                            _priority = value;
                          });
                        },
                        value: _priority,
                      ),
                    ),

                    /// Time Picker
                    GestureDetector(
                      onTap: () {
                        DatePicker.showTimePicker(context,
                            showTitleActions: true,
                            showSecondsColumn: false,
                            onChanged: (_) {}, onConfirm: (selectedTime) {
                          setState(() {
                            time = selectedTime;
                          });

                          FocusManager.instance.primaryFocus?.unfocus();
                        }, currentTime: showTimeAsDateTime(time));
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Time"),
                            ),
                            Expanded(child: Container()),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: Center(
                                child: Text(
                                  showTime(time),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    /// Date Picker
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2030, 3, 5),
                            onChanged: (_) {}, onConfirm: (selectedDate) {
                          setState(() {
                            date = selectedDate;
                          });
                          FocusManager.instance.primaryFocus?.unfocus();
                        }, currentTime: showDateAsDateTime(date));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text("Date"),
                            ),
                            Expanded(child: Container()),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 140,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade100),
                              child: Center(
                                child: Text(
                                  showDate(date),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                DatabaseMethods service = DatabaseMethods();
                final FirebaseAuth _auth = FirebaseAuth.instance;
                final User user = await _auth.currentUser!;
                Task task = Task(
                  user_id: user.email!,
                  name: _nameController.text,
                  label: _priority!,
                  deadline: _deadlineController.text,
                  description: _descriptionController.text,
                  isCompleted: false,
                  time: time!,
                  date: date!,
                );

                await service.updateTask(widget.userId, task);
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: ResponsiveBreakpoints.of(context).isMobile
                        ? MediaQuery.sizeOf(context).width * 0.8
                        : MediaQuery.sizeOf(context).width * 0.5,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.button),
                    child: Center(
                      child: Text("Update",
                          style: AppTypography.textMd.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
