import 'package:flutter/material.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/screens/card_form.dart';

class CardRowOld extends StatefulWidget {
  late int cardId;

  CardRowOld(this.cardId, {super.key});

  @override
  State<StatefulWidget> createState() => CardRowOldState();
}

class CardRowOldState extends State<CardRowOld> {
  late final int currentCardId;
  late bool frontSide;

  @override
  void initState() {
    super.initState();
    frontSide = true;
    currentCardId = widget.cardId;
  }

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = AppDatabase.instance;

    return FutureBuilder<CardEntity>(
      future: db.getCard(currentCardId),
      builder: (context, snapshot) {
        print('build CardRowState');
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loader while fetching the card
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final card = snapshot.data!;

          return Card(
            child: InkWell(
              onTap: () {
                setState(() {
                  frontSide = !frontSide;
                });
              },
              onLongPress: () {
                // print('onLongPress');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CardForm(currentCardId, card.front!,
                        card.back!, card.example!)));
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        frontSide ? card.front! : card.back!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 24.0), // Enlarged font size
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Text(
                        frontSide ? '' : card.example!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20.0), // Enlarged font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          // return InkWell(
          // onTap: () {
          //   setState(() {
          //     frontSide = !frontSide;
          //   });
          // },
          // onLongPress: () {
          //   // print('onLongPress');
          //   Navigator.of(context).push(MaterialPageRoute(
          //       builder: (context) => CardForm(
          //           currentCardId, card.front!, card.back!, card.example!)));
          // },
          //   child: Card(
          //     child: Column(
          //       children: <Widget>[
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Container(
          //             width: double.infinity,
          //             child: Text(
          //               frontSide ? card.front! : card.back!,
          //               textAlign: TextAlign.center,
          //               style: const TextStyle(
          //                   fontSize: 24.0), // Enlarged font size
          //             ),
          //           ),
          //         ),
          //         Padding(
          //           padding: const EdgeInsets.all(8.0),
          //           child: Container(
          //             width: double.infinity,
          //             child: Text(
          //               frontSide ? '' : card.example!,
          //               textAlign: TextAlign.center,
          //               style: const TextStyle(
          //                   fontSize: 20.0), // Enlarged font size
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),

          // Ink(
          //   color: const Color.fromARGB(255, 187, 210, 230),
          // child: Column(
          //   children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     width: double.infinity,
          //     child: Text(
          //       frontSide ? card.front! : card.back!,
          //       textAlign: TextAlign.center,
          //       style: const TextStyle(
          //           fontSize: 24.0), // Enlarged font size
          //     ),
          //   ),
          // ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: Container(
          //         width: double.infinity,
          //         child: Text(
          //           frontSide ? '' : card.example!,
          //           textAlign: TextAlign.center,
          //           style: const TextStyle(
          //               fontSize: 20.0), // Enlarged font size
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: SizedBox(
          //       height: 100.0, // Set a fixed height for the text container
          //       width: double.infinity,
          //       child: Center(
          //         child: AnimatedSwitcher(
          //           duration: const Duration(milliseconds: 300),
          //           transitionBuilder:
          //               (Widget child, Animation<double> animation) {
          //             return FadeTransition(opacity: animation, child: child);
          //           },
          //           child: Text(
          //             frontSide ? card.front! : card.back!,
          //             key: ValueKey<bool>(frontSide),
          //             textAlign: TextAlign.center,
          //             style: const TextStyle(
          //                 fontSize: 24.0), // Enlarged font size
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // );
        } else {
          // Handle the case where snapshot.data is null
          return const Text('No data available');
        }
      },
    );
  }

  // Widget _oneText() {
  //   return Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: Container(
  //                 width: double.infinity,
  //                 child: Text(
  //                   frontSide ? card.front! : card.back!,
  //                   textAlign: TextAlign.center,
  //                   style: const TextStyle(
  //                       fontSize: 24.0), // Enlarged font size
  //                 ),
  //               ),
  //             ),
  // }
}
