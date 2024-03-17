import 'dart:io';
import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/left_to_right_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:pinboard_notebook/main.dart';
import 'package:path/path.dart' as path;
import 'noteinfo_screen.dart';
import 'notewrite_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  NoteStorage noteStorage = NoteStorage();
  late List<File> notes;
  late List<File> sortedNotes;
  List<bool> sortButtonsArePressed = [false, false, false, false, false, false, false];
  late List<Color> sortButtonColors;

  @override
  void initState() {
    //set notes
    notes = List.empty(growable: true);
    sortedNotes = List.empty(growable: true);
    noteStorage.readAllFiles().then(
      (List<File> files) {
        setState(() {
          notes = files;
          sortedNotes = List.from(notes);
          sortNotes("00");
        });
      },
    );

    sortButtonColors = List<Color>.empty(growable: true);
    sortButtonColors.add(CustomColor.buttonRed.color);
    sortButtonColors.add(CustomColor.buttonOrange.color);
    sortButtonColors.add(CustomColor.buttonYellow.color);
    sortButtonColors.add(CustomColor.buttonGreen.color);
    sortButtonColors.add(CustomColor.buttonCyan.color);
    sortButtonColors.add(CustomColor.buttonBlue.color);
    sortButtonColors.add(CustomColor.buttonPurple.color);
    //prepare sortedNotes
    super.initState();
  }

  //custom methods:
  void sortNotes(String pin) {
    sortedNotes = List.from(notes);
    sortedNotes.sort((a, b) {
      int A = int.parse(path.basenameWithoutExtension(a.path).split('_').first, radix: 16);
      int B = int.parse(path.basenameWithoutExtension(b.path).split('_').first, radix: 16);
      return A.compareTo(B);
    });
    if (pin != "00") {
      sortByPin(pin);
      sortedNotes.sort((a, b) {
        int A = int.parse(path.basenameWithoutExtension(a.path).split('_').last, radix: 16);
        int B = int.parse(path.basenameWithoutExtension(b.path).split('_').last, radix: 16);
        return A.compareTo(B);
      });
    }
    setState(() {});
  }
  void sortByPin(String pin) {
    sortedNotes = notes.where((note) => path.basenameWithoutExtension(note.path).substring(0, 2) == pin).toList();
  }
  Color setNoteColor(String pin) {
    switch (pin) {
      case "01":
        return CustomColor.noteRed.color;
      case "02":
        return CustomColor.noteOrange.color;
      case "03":
        return CustomColor.noteYellow.color;
      case "04":
        return CustomColor.noteGreen.color;
      case "05":
        return CustomColor.noteCyan.color;
      case "06":
        return CustomColor.noteBlue.color;
      case "07":
        return CustomColor.notePurple.color;
      default:
        return const Color.fromRGBO(245, 244, 241, 1.0);
    }
  }

  void togglePin(String newPin, int index) {
    setState(() {
      pressButton(index);
      if (sortButtonsArePressed[index]) {
        // activate button
        sortNotes(newPin);
      } else {
        // deactivate button
        sortNotes("00");
      }
    });
  }
  void pressButton(int index) {
    for (int i = 0; i < sortButtonsArePressed.length; i++) {
      if (i != index) {
        sortButtonsArePressed[i] = false;
      }
    }
    sortButtonsArePressed[index] = !sortButtonsArePressed[index];
    changeButtonColor();
  }
  void changeButtonColor() {
    if (!sortButtonsArePressed[0]) {
      sortButtonColors[0] = CustomColor.buttonRed.color;
    } else {
      sortButtonColors[0] = CustomColor.buttonPressedRed.color;
    }
    if (!sortButtonsArePressed[1]) {
      sortButtonColors[1] = CustomColor.buttonOrange.color;
    } else {
      sortButtonColors[1] = CustomColor.buttonPressedOrange.color;
    }
    if (!sortButtonsArePressed[2]) {
      sortButtonColors[2] = CustomColor.buttonYellow.color;
    } else {
      sortButtonColors[2] = CustomColor.buttonPressedYellow.color;
    }
    if (!sortButtonsArePressed[3]) {
      sortButtonColors[3] = CustomColor.buttonGreen.color;
    } else {
      sortButtonColors[3] = CustomColor.buttonPressedGreen.color;
    }
    if (!sortButtonsArePressed[4]) {
      sortButtonColors[4] = CustomColor.buttonCyan.color;
    } else {
      sortButtonColors[4] = CustomColor.buttonPressedCyan.color;
    }
    if (!sortButtonsArePressed[5]) {
      sortButtonColors[5] = CustomColor.buttonBlue.color;
    } else {
      sortButtonColors[5] = CustomColor.buttonPressedBlue.color;
    }
    if (!sortButtonsArePressed[6]) {
      sortButtonColors[6] = CustomColor.buttonPurple.color;
    } else {
      sortButtonColors[6] = CustomColor.buttonPressedPurple.color;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 224, 220, 211),
          child: Column(
            children: [
              //upper menu bar (to sort sortedNotes) here:
              Container(
                  padding: const EdgeInsets.only(top: 30, left: 10, bottom: 10),
                  color: const Color.fromARGB(255, 245, 244, 241),
                  child: Row(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 14, right: 10),
                          child: const Text(style: TextStyle(fontSize: 16, color: Colors.black), "sort by:")),

                      GestureDetector(
                        onTap: () {
                          togglePin("01", 0);
                        },
                        child: SortButton(buttonColor: sortButtonColors[0]),
                      ),
                      GestureDetector(
                        onTap: () {
                          togglePin("02", 1);
                        },
                        child: SortButton(buttonColor: sortButtonColors[1]),
                      ),
                      GestureDetector(
                        onTap: () {
                          togglePin("03", 2);
                        },
                        child: SortButton(buttonColor: sortButtonColors[2]),
                      ),
                      GestureDetector(
                        onTap: () {
                          togglePin("04", 3);
                        },
                        child: SortButton(buttonColor: sortButtonColors[3]),
                      ),
                      GestureDetector(
                        onTap: () {
                          togglePin("05", 4);
                        },
                        child: SortButton(buttonColor: sortButtonColors[4]),
                      ),
                      GestureDetector(
                        onTap: () {
                          togglePin("06", 5);
                        },
                        child: SortButton(buttonColor: sortButtonColors[5]),
                      ),
                      GestureDetector(
                        onTap: () {
                          togglePin("07", 6);
                        },
                        child: SortButton(buttonColor: sortButtonColors[6]),
                      ),
                    ],
                  )),
              // List of Notes
              Expanded(
                child: ListView.builder(
                  itemCount: sortedNotes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .push(PageAnimationTransition(page: NoteInfoScreen(note: sortedNotes[index]), pageAnimationType: RightToLeftTransition()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        color: setNoteColor(path.basenameWithoutExtension(sortedNotes[index].path).split('_').first),
                        margin: const EdgeInsets.only(top: 10, left: 10, right: 20),
                        child: Text(
                          maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            sortedNotes[index].readAsStringSync()),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(PageAnimationTransition(page: const NoteWriteScreen(), pageAnimationType: LeftToRightTransition()));
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.playlist_add),
                    SizedBox(width: 8),
                    Text('Write Notes'),
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

class SortButton extends StatelessWidget {
  final Color buttonColor;

  const SortButton({
    Key? key,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 14, right: 8),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(Icons.bookmark_border, size: 24),
    );
  }
}