import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinboard_notebook/screens/notewrite_screen.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(
    const MaterialApp(
      title: 'Pinboard Notebook',
      home: NoteWriteScreen(),
    ),
  );
}
enum CustomColor {
  noteRed,
  noteOrange,
  noteYellow,
  noteGreen,
  noteCyan,
  noteBlue,
  notePurple,
  buttonRed,
  buttonOrange,
  buttonYellow,
  buttonGreen,
  buttonCyan,
  buttonBlue,
  buttonPurple,
  buttonPressedRed,
  buttonPressedYellow,
  buttonPressedOrange,
  buttonPressedGreen,
  buttonPressedCyan,
  buttonPressedBlue,
  buttonPressedPurple,
}
extension CustomColorExtension on CustomColor {
  Color get color {
    switch (this) {
      case CustomColor.noteRed:
        return const Color.fromRGBO(238, 202, 199, 1.0);
      case CustomColor.buttonRed:
        return const Color.fromRGBO(215, 74, 74, 1.0);
      case CustomColor.buttonPressedRed:
        return const Color.fromRGBO(152, 49, 49, 1.0);
      case CustomColor.noteOrange:
        return const Color.fromRGBO(240, 216, 188, 1.0);
      case CustomColor.buttonOrange:
        return const Color.fromRGBO(223, 132, 24, 1.0);
      case CustomColor.buttonPressedOrange:
        return const Color.fromRGBO(176, 104, 16, 1.0);
      case CustomColor.noteYellow:
        return const Color.fromRGBO(241, 236, 195, 1.0);
      case CustomColor.buttonYellow:
        return const Color.fromRGBO(228, 210, 55, 1.0);
      case CustomColor.buttonPressedYellow:
        return const Color.fromRGBO(176, 162, 40, 1.0);
      case CustomColor.noteGreen:
        return const Color.fromRGBO(209, 236, 194, 1.0);
      case CustomColor.buttonGreen:
        return const Color.fromRGBO(102, 211, 52, 1.0);
      case CustomColor.buttonPressedGreen:
        return const Color.fromRGBO(70, 148, 35, 1.0);
      case CustomColor.noteCyan:
        return const Color.fromRGBO(203, 239, 239, 1.0);
      case CustomColor.buttonCyan:
        return const Color.fromRGBO(76, 224, 233, 1.0);
      case CustomColor.buttonPressedCyan:
        return const Color.fromRGBO(50, 158, 164, 1.0);
      case CustomColor.noteBlue:
        return const Color.fromRGBO(202, 196, 231, 1.0);
      case CustomColor.buttonBlue:
        return const Color.fromRGBO(72, 52, 201, 1.0);
      case CustomColor.buttonPressedBlue:
        return const Color.fromRGBO(40, 28, 117, 1.0);
      case CustomColor.notePurple:
        return const Color.fromRGBO(229, 201, 238, 1.0);
      case CustomColor.buttonPurple:
        return const Color.fromRGBO(180, 71, 230, 1.0);
      case CustomColor.buttonPressedPurple:
        return const Color.fromRGBO(117, 45, 150, 1.0);
    }
  }
}

  class NoteStorage {

    Future<String> get _localPath async {
      Directory directory = await getApplicationDocumentsDirectory();
      String newPath = "${directory.path}/notes";
      Directory(newPath).createSync();
      return newPath;
    }

    Future<String> generateName(String pin) async {
      final notes = await readAllFiles();
      List<File> pinnedNotes = List.empty(growable: true);

      if(pin != "00") {
        for (File note in notes) {
          if (path.basenameWithoutExtension(note.path).substring(0, 2) == pin) {
            pinnedNotes.add(note);
          }
        }
      }
      else {
        pinnedNotes = List.from(notes);
      }

      // get all IDs of pinnedNotes
      List<int> noteIDs = pinnedNotes.map((note) {
        return int.parse(path.basenameWithoutExtension(note.path).split('_').last, radix: 16);
      }).toList();
      noteIDs.sort();

      // look for any gaps in noteIDs and set new name upon first gap
      for(int i = 0; i < noteIDs.length-1; i++) {
        if (noteIDs[i + 1] - noteIDs[i] > 1) {
          return "${pin}_${noteIDs[i]+1}";
        }
      }

      // if no gaps are present, add new name
      return "${pin}_${(notes.length + 1).toRadixString(16).padLeft(3,'0')}";
    }

    Future<File> readFile(String fileName) async {
      final path = await _localPath;
      return File('$path/$fileName.txt');
    }
    Future<List<File>> readAllFiles() async {
      final path = await _localPath;
      final notes = Directory("$path/").listSync();

      return  notes.whereType<File>().toList();
    }
    Future<File> writeFile(String fileName, String text) async{
      final note = await readFile(fileName);
      return note.writeAsString(text);
    }
    void deleteFile(String filePath) async {
      File file = File(filePath);
      if(await file.exists()) {
        file.delete();
      }
    }
  }

