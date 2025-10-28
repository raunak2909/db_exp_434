import 'package:db_exp_434/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

///1.complete this note app
///2.build complete note app with note ui
///3.create a todo app(id, title, desc, createdAt, isCompleted(1/0))

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> allNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();
  DateFormat df = DateFormat.yMMMd();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    loadData();
  }

  loadData() async {
    allNotes = await dbHelper!.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return Card(
                  child: ListTile(
                    title: Text(allNotes[index][dbHelper!.column_note_title]),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(allNotes[index][dbHelper!.column_note_desc]),
                        Text(
                          df.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                allNotes[index][dbHelper!
                                    .column_note_created_at],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            titleController.text =
                                allNotes[index][dbHelper!.column_note_title];
                            descController.text =
                                allNotes[index][dbHelper!.column_note_desc];
                            showModalBottomSheet(
                              context: context,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (_) {
                                return myBottomSheetUI(
                                  isUpdate: true,
                                  id: allNotes[index][dbHelper!.column_note_id],
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () async {
                            bool isDeleted = await dbHelper!.deleteNote(
                              id: allNotes[index][dbHelper!.column_note_id],
                            );
                            if (isDeleted) {
                              loadData();
                            }
                          },
                          icon: Icon(Icons.delete, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(child: Text('No Notes Yet!!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          titleController.text = "";
          descController.clear();
          showModalBottomSheet(
            context: context,
            isDismissible: false,
            enableDrag: false,
            builder: (_) {
              return myBottomSheetUI();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget myBottomSheetUI({bool isUpdate = false, int id = 0}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(21),
      child: Column(
        children: [
          Text(
            isUpdate ? 'Update Note' : 'Add Note',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 11),
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              hintText: 'Enter your Title here..',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Title",
            ),
          ),
          SizedBox(height: 11),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              hintText: 'Enter your Desc here..',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Desc",
            ),
          ),
          SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () async {
                  if (titleController.text.isNotEmpty &&
                      descController.text.isNotEmpty) {
                    bool isTaskDone = false;

                    if (isUpdate) {
                      isTaskDone = await dbHelper!.updateNote(
                        id: id,
                        title: titleController.text,
                        desc: descController.text,
                      );
                    } else {
                      isTaskDone = await dbHelper!.insertNote(
                        title: titleController.text,
                        desc: descController.text,
                      );
                    }

                    if (isTaskDone) {
                      loadData();
                      Navigator.pop(context);
                    }
                  }
                },
                child: Text('Save'),
              ),
              SizedBox(width: 11),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
