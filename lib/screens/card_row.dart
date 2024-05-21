import 'package:flutter/material.dart';
import 'package:tf_mobile/design/colors.dart';
import 'package:tf_mobile/screens/card_form.dart';

class CardRow extends StatefulWidget {
  final int cardId;
  final String front;
  final String back;
  final String example;

  CardRow(
      {required this.cardId,
      required this.front,
      required this.back,
      required this.example,
      super.key});

  @override
  State<StatefulWidget> createState() => CardRowState();
}

class CardRowState extends State<CardRow> {
  late bool frontSide;

  @override
  void initState() {
    super.initState();
    frontSide = true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          frontSide = !frontSide;
        });
      },
      onLongPress: () {
        // print('onLongPress');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CardForm(
                widget.cardId, widget.front, widget.back, widget.example)));
      },
      child: Card(
        child: frontSide
            ? _oneText(widget.front)
            : _twoTexts(widget.back, widget.example),
      ),
    );
  }

  Widget _oneText(String text) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: cardContentBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget _twoTexts(String text1, String text2) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: cardContentBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 0.0,
            ),
            child: Text(
              text1,
              style: const TextStyle(color: cardContentFontColor, fontSize: 18),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: cardContentBackgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 0.0,
              bottom: 16.0,
            ),
            child: Text(
              text2,
              style: const TextStyle(color: cardContentFontColor, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
