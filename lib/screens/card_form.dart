import 'package:flutter/material.dart';
import 'package:tf_mobile/screens/cards.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/card.dart';

class CardForm extends StatefulWidget {
  int cardId;

  CardForm(this.cardId);

  @override
  State<StatefulWidget> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final AppDatabase db = AppDatabase.instance;
  TextEditingController _front = new TextEditingController();
  TextEditingController _back = new TextEditingController();
  TextEditingController _example = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('cardId ${widget.cardId}');

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _front,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Front',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _back,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Back',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _example,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Example',
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                if (widget.cardId == 0) {
                  var card = CardEntity(
                    internalCode: '123456',
                    editDateTime: DateTime.now(),
                    front: _front.text,
                    back: _back.text,
                    example: _example.text,
                    status: 0,
                  );
                  db.createCard(card);
                } else {}

                //_front.text, _back.value, _example.text

                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CardTab()),
                );
                //CardTab();
              },
              child: Text('Submit')),
        ],
      ),
    );
  }
}
