import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'package:tf_mobile/design/colors.dart';
import 'package:tf_mobile/screens/card_form.dart';

class CardRowNew extends StatefulWidget {
  final int cardId;
  final String front;
  final String back;
  final String example;

  CardRowNew(
      {required this.cardId,
      required this.front,
      required this.back,
      required this.example,
      super.key});

  @override
  State<StatefulWidget> createState() => CardRowNewState();
}

class CardRowNewState extends State<CardRowNew> {
  late bool frontSide;

  @override
  void initState() {
    super.initState();
    frontSide = true;
  }

  @override
  Widget build(BuildContext context) {
    // final String _front = widget.front;
    // final String _back = 'kjkjadjjk kjjj vtyt 0909 jknj';
    // final String _example =
    //     'kjklj 98900 oijljlkjl jkljl ljlk ljljk xdxese sfsf 9090 9cb9 oi o i0 090 9 ipiopi i pi ends';

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
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontSize: 18),
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
              color: whiteCardTextBackground,
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
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: whiteCardTextBackground,
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
              style: TextStyle(
                  color: Color.fromARGB(255, 75, 75, 75), fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
