import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:pinboard_notebook/main.dart';

import 'notelist_screen.dart';

class NoteWriteScreen extends StatefulWidget {
  const NoteWriteScreen({super.key});

  @override
  State<NoteWriteScreen> createState() => _NoteWriteScreenState();
}

class _NoteWriteScreenState extends State<NoteWriteScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _textEditingController;
  NoteStorage noteStorage = NoteStorage();

  String pin = "00";
  Color chosenPinColor = Colors.transparent;
  List<bool> pinButtonsArePressed = [false, false, false, false, false, false, false];
  late List<Color> pinButtonColors;

  //TODO implement animation here (later)
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();

    pinButtonColors = List<Color>.empty(growable: true);
    pinButtonColors.add(CustomColor.buttonRed.color);
    pinButtonColors.add(CustomColor.buttonOrange.color);
    pinButtonColors.add(CustomColor.buttonYellow.color);
    pinButtonColors.add(CustomColor.buttonGreen.color);
    pinButtonColors.add(CustomColor.buttonCyan.color);
    pinButtonColors.add(CustomColor.buttonBlue.color);
    pinButtonColors.add(CustomColor.buttonPurple.color);

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  //custom methods:
  void writeNote(String text) async {
    noteStorage.writeFile(await noteStorage.generateName(pin), text);
  }
  void togglePin(String newPin, Color newPinColor, int index) {
    setState(() {
      if (chosenPinColor == newPinColor) {
        chosenPinColor = Colors.transparent;
        pin = "00";
      } else {
        chosenPinColor = newPinColor;
        pin = newPin;
      }
      pressButton(index);
    });
  }
  void pressButton(int index) {
    for (int i = 0; i < pinButtonsArePressed.length; i++) {
      if (i != index) {
        pinButtonsArePressed[i] = false;
      }
    }
    pinButtonsArePressed[index] = !pinButtonsArePressed[index];
    changeButtonColor();
  }
  void changeButtonColor() {
    if (!pinButtonsArePressed[0]) {
      pinButtonColors[0] = CustomColor.buttonRed.color;
    } else {
      pinButtonColors[0] = CustomColor.buttonPressedRed.color;
    }
    if (!pinButtonsArePressed[1]) {
      pinButtonColors[1] = CustomColor.buttonOrange.color;
    } else {
      pinButtonColors[1] = CustomColor.buttonPressedOrange.color;
    }
    if (!pinButtonsArePressed[2]) {
      pinButtonColors[2] = CustomColor.buttonYellow.color;
    } else {
      pinButtonColors[2] = CustomColor.buttonPressedYellow.color;
    }
    if (!pinButtonsArePressed[3]) {
      pinButtonColors[3] = CustomColor.buttonGreen.color;
    } else {
      pinButtonColors[3] = CustomColor.buttonPressedGreen.color;
    }
    if (!pinButtonsArePressed[4]) {
      pinButtonColors[4] = CustomColor.buttonCyan.color;
    } else {
      pinButtonColors[4] = CustomColor.buttonPressedCyan.color;
    }
    if (!pinButtonsArePressed[5]) {
      pinButtonColors[5] = CustomColor.buttonBlue.color;
    } else {
      pinButtonColors[5] = CustomColor.buttonPressedBlue.color;
    }
    if (!pinButtonsArePressed[6]) {
      pinButtonColors[6] = CustomColor.buttonPurple.color;
    } else {
      pinButtonColors[6] = CustomColor.buttonPressedPurple.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            //Title
            Container(
                color: const Color.fromARGB(255, 201, 197, 188),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Stack(
                  children: <Widget>[
                    Center(
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: RichText(
                                text: const TextSpan(children: [
                              TextSpan(
                                  text: "Pinboard\n",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 52,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w200,
                                  )),
                              TextSpan(
                                  text: "Notebook",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 52,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w200,
                                  ))
                            ])))),
                    DragTarget<String>(
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                            //TODO when dragging show "Drag Note here" box
                            );
                      },
                      onAcceptWithDetails: (details) async {
                        writeNote(_textEditingController.text);
                        _textEditingController.clear();
                      },
                    ),
                  ],
                )),

            //Notearea
            Expanded(
              child: Container(
                color: const Color.fromARGB(255, 231, 226, 218),
                child: Stack(
                  children: [
                    Row(children: [
                      Container(
                        color: const Color.fromARGB(255, 135, 126, 115),
                        width: 52,
                      ),
                      Expanded(
                          child: Stack(
                        children: <Widget>[
                          Container(
                            color: const Color.fromARGB(255, 245, 244, 241),
                            margin: const EdgeInsets.only(left: 24, right: 24, top: 64, bottom: 32),
                            padding: const EdgeInsets.only(left: 5, right: 15),
                            child: TextField(
                              expands: true,
                              maxLines: null,
                              minLines: null,
                              style: const TextStyle(height: 1.5, fontSize: 16),
                              controller: _textEditingController,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            bottom: 0,
                            //TODO feedback-object is way above dragging cursor
                            child: Draggable<String>(
                                data: "",
                                feedback: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color.fromRGBO(231, 226, 218, 0.5),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Align(alignment: Alignment.topLeft, child: Icon(Icons.notes))),
                                child: Container(
                                    width: MediaQuery.of(context).size.width * 0.07,
                                    margin: const EdgeInsets.only(left: 24, right: 24, top: 64, bottom: 32),
                                    color: const Color.fromRGBO(190, 237, 239, 0.5019607843137255),
                                    child: const Text(""))),
                          )
                        ],
                      ))
                    ]),
                    Positioned(
                      top: 30,
                      right: 15,
                      child: GestureDetector(
                        onTap: () {
                          if (chosenPinColor.opacity != 0) {
                            setState(() {
                              chosenPinColor = Colors.transparent;
                              pin = "00";
                              for (int i = 0; i < pinButtonsArePressed.length; i++) {
                                pinButtonsArePressed[i] = false;
                              }
                              changeButtonColor();
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          margin: const EdgeInsets.only(top: 14),
                          decoration: BoxDecoration(
                            color: chosenPinColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.bookmark_border,
                            size: 36,
                            color: Color.fromRGBO(0, 0, 0, chosenPinColor.opacity),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 5,
                      left: 8,
                      child: Column(children: [
                        // all available pins
                        GestureDetector(
                          onTap: () {
                            togglePin("01", CustomColor.buttonRed.color, 0);
                          },
                          child: PinButton(buttonColor: pinButtonColors[0]),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePin("02", CustomColor.buttonOrange.color, 1);
                          },
                          child: PinButton(buttonColor: pinButtonColors[1]),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePin("03", CustomColor.buttonYellow.color, 2);
                          },
                          child: PinButton(buttonColor: pinButtonColors[2]),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePin("04", CustomColor.buttonGreen.color, 3);
                          },
                          child: PinButton(buttonColor: pinButtonColors[3]),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePin("05", CustomColor.buttonCyan.color, 4);
                          },
                          child: PinButton(buttonColor: pinButtonColors[4]),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePin("06", CustomColor.buttonBlue.color, 5);
                          },
                          child: PinButton(buttonColor: pinButtonColors[5]),
                        ),
                        GestureDetector(
                          onTap: () {
                            togglePin("07", CustomColor.buttonPurple.color, 6);
                          },
                          child: PinButton(buttonColor: pinButtonColors[6]),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.of(context).push(PageAnimationTransition(page: const NoteListScreen(), pageAnimationType: RightToLeftTransition()));
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

class PinButton extends StatelessWidget {
  final Color buttonColor;

  const PinButton({
    Key? key,
    required this.buttonColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 14),
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: const Icon(Icons.bookmark_border, size: 28),
    );
  }
}
