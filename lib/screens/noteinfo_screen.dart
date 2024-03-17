import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/left_to_right_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:pinboard_notebook/main.dart';
import 'package:path/path.dart' as path;

import 'notelist_screen.dart';

class NoteInfoScreen extends StatefulWidget {
  final File note;
  const NoteInfoScreen({super.key, required this.note});

  @override
  State<NoteInfoScreen> createState() => _NoteInfoScreenState();
}

class _NoteInfoScreenState extends State<NoteInfoScreen> {
  late TextEditingController _textEditingController;
  NoteStorage noteStorage = NoteStorage();
  late File note;
  late String oldText;
  late String pin;

  @override
  void initState() {
    note = widget.note;
    oldText = note.readAsStringSync();
    pin = path.basenameWithoutExtension(note.path).split('_').first;
    _textEditingController = TextEditingController(text: note.readAsStringSync());
    super.initState();
  }

  //custom methods:
  void deleteNote(String text) async {
    noteStorage.deleteFile(note.path);
    setState(() {
      Navigator.of(context).push(PageAnimationTransition(page: const NoteListScreen(), pageAnimationType: LeftToRightTransition()));
    });
  }

  void saveNote(String text) async {
    if (pin == path.basenameWithoutExtension(note.path).split('_').first) {
      noteStorage.writeFile(path.basenameWithoutExtension(note.path), text);
    } else {
      noteStorage.deleteFile(note.path);
      noteStorage.writeFile(await noteStorage.generateName(pin), text);
    }
  }

  Future<bool> _confirmYesNoDialog(BuildContext context, void Function(String) method, String text, String message) async {
    bool proceed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Yes button clicked
                },
                child: const Text('Yes', style: TextStyle(color: Colors.black)),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // No button clicked
                },
                child: const Text('No', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        );
      },
    );

    if (proceed) {
      // method is executed
      method(text);
    }
    return proceed;
  }

  Future<bool> _confirmYesNoCancelDialog(BuildContext context, void Function(String) method, String text, String message) async {
    bool executeMethod = false;
    bool proceed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  executeMethod = true;
                  Navigator.of(context).pop(true); // Yes button clicked
                },
                child: const Text('Yes', style: TextStyle(color: Colors.black)),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // No button clicked
                },
                child: const Text('No', style: TextStyle(color: Colors.black)),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 2, bottom: 2, left: 5, right: 5),
              margin: const EdgeInsets.only(right: 32),
              decoration: BoxDecoration(
                border: Border.all(width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Yes button clicked
                },
                child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        );
      },
    );

    if (executeMethod) {
      // method is executed
      method(text);
    }
    return proceed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        color: const Color.fromARGB(255, 224, 220, 211),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              height: MediaQuery.of(context).size.height * 0.15,
              color: const Color.fromARGB(255, 245, 244, 241),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    margin: const EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _confirmYesNoDialog(context, saveNote, _textEditingController.text, "Do you want to save your edit?");
                      },
                      child: const Text("Save Note", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 5, left: 20, right: 20),
                    margin: const EdgeInsets.only(top: 25),
                    decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () {
                        _confirmYesNoDialog(context, deleteNote, _textEditingController.text, "Do you really want to delete this note?");
                      },
                      child: const Text("Delete Note", style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 245, 244, 241),
                margin: const EdgeInsets.only(left: 24, right: 24, top: 54, bottom: 32),
                padding: const EdgeInsets.only(left: 5, right: 15),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  minLines: null,
                  style: const TextStyle(height: 1.5, fontSize: 16),
                  controller: _textEditingController,
                ),
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () async {
                if (await _confirmYesNoCancelDialog(context, saveNote, _textEditingController.text, "Do you want to save your edit before you leave?")) {
                  Navigator.of(context).push(PageAnimationTransition(page: const NoteListScreen(), pageAnimationType: LeftToRightTransition()));
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.format_list_bulleted),
                    SizedBox(width: 8),
                    Text('List of Notes'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
