import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardRowNew extends StatefulWidget {
  CardRowNew({super.key});

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
    final String _front = 'kfsaf jkjj kkjkkjkj kjkj';
    final String _back = 'kjkjadjjk kjjj vtyt 0909 jknj';
    final String _example =
        'kjklj 98900 oijljlkjl jkljl ljlk ljljk xdxese sfsf 9090 9cb9 oi o i0 090 9 ipiopi i pi ends';

    return GestureDetector(
      onTap: () {
        setState(() {
          frontSide = !frontSide;
        });
      },
      child: Card(
        child: frontSide ? _oneText(_front) : _twoTexts(_back, _example),
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
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 8.0, bottom: 0.0),
            child: Text(
              text1,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        SizedBox(height: 8), // Added spacing between containers
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, top: 0.0, bottom: 8.0),
            child: Text(
              text2,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}
