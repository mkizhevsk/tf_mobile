import 'package:flutter/material.dart';
// import 'package:tf_mobile/screens/cards.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/stream_manager.dart';
import 'package:tf_mobile/utils/string_random_generator.dart';
import 'package:tf_mobile/main.dart';

class CardForm extends StatefulWidget {
  final int cardId;
  final String front;
  final String back;
  final String example;

  const CardForm(this.cardId, this.front, this.back, this.example, {super.key});

  @override
  State<StatefulWidget> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  final AppDatabase db = AppDatabase.instance;
  final TextEditingController _front = TextEditingController();
  final TextEditingController _back = TextEditingController();
  final TextEditingController _example = TextEditingController();

  late final CardEntity card;

  static const double paddingValue = 8.0;

  @override
  void dispose() {
    _front.dispose();
    _back.dispose();
    _example.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _front.text = widget.front;
    _back.text = widget.back;
    _example.text = widget.example;
  }

  @override
  Widget build(BuildContext context) {
    // print('cardId ${widget.cardId}');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(paddingValue),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(paddingValue),
              child: TextField(
                controller: _front,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Front',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingValue),
              child: TextField(
                controller: _back,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Back',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(paddingValue),
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
              onPressed: () async {
                // print('widget.cardId ' + widget.cardId.toString());
                int cardId;
                if (widget.cardId == 0) {
                  var card = CardEntity(
                    internalCode: StringRandomGenerator.instance.getValue(),
                    editDateTime: DateTime.now(),
                    front: _front.text,
                    back: _back.text,
                    example: _example.text,
                    status: 0,
                  );
                  var newCard = await db.createCard(card);
                  cardId = newCard.id!;
                } else {
                  var updatedCard = await db.getCard(widget.cardId);
                  updatedCard.editDateTime = DateTime.now();
                  updatedCard.front = _front.text;
                  updatedCard.back = _back.text;
                  updatedCard.example = _example.text;
                  cardId = await db.updateCardFromForm(updatedCard);
                  print(updatedCard);
                }

                if (mounted) {
                  StreamManager().cardIdSink.add(cardId);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyHome()),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
