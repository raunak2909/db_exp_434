import 'package:db_exp_434/db_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  List<Map<String, dynamic>> allNotes = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper.getInstance();
    loadData();
  }

  loadData() async{
    allNotes = await dbHelper!.fetchAllNotes();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: allNotes.isNotEmpty ? ListView.builder(
        itemCount: allNotes.length,
          itemBuilder: (_, index){
        return Card(
          child: ListTile(
            title: Text(allNotes[index][dbHelper!.column_note_title]),
            subtitle: Text(allNotes[index][dbHelper!.column_note_desc]),
          ),
        );
      }) : Center(
        child: Text('No Notes Yet!!'),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async{

        bool isAdded = await dbHelper!.insertNote(title: "Life", desc: "Live Life KING size..");
        if(isAdded){
          loadData();
        }

      }, child: Icon(Icons.add),),
    );
  }
}
