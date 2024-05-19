import 'package:flutter/material.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/screens/card_form.dart';
import 'package:tf_mobile/stream_manager.dart';
import 'package:tf_mobile/screens/card_row.dart';
import 'package:tf_mobile/screens/card_new.dart';
import 'dart:async';

class CardTab extends StatefulWidget {
  const CardTab({super.key});

  @override
  State<StatefulWidget> createState() => CardTabState();
}

class CardTabState extends State<CardTab> {
  int currentCardId = 10;
  bool frontSide = true;

  final AppDatabase db = AppDatabase.instance;

  StreamSubscription<int>? _cardIdSubscription;

  @override
  void initState() {
    super.initState();
    print('initState of CardTabState');

    _cardIdSubscription = StreamManager().cardIdStream.listen((cardId) {
      setState(() {
        currentCardId = cardId;
        print('CardTabState Received cardId: $cardId');
      });
    });

    // db.getCards().then((value) {
    //   for (var card in value) {
    //     print(card);
    //   }
    // });
  }

  @override
  void dispose() {
    _cardIdSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build CardTabState with currentCardId $currentCardId');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          // tooltip: 'Show Snackbar',
          onPressed: () {
            print('leading');
          },
        ),
        title: const Text('My space'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add card',
            onPressed: () {
              print('actions add');
              setState(() {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CardForm(0, '', '', '')));
              });
            },
          ),
        ],
      ),
      body: CardBody(
        currentCardId: currentCardId,
      ),
    );
  }
}

class CardBody extends StatelessWidget {
  final int currentCardId;

  const CardBody({super.key, required this.currentCardId});

  @override
  Widget build(context) {
    print('build CardBody');

    return Scaffold(
      backgroundColor:
          Colors.grey[200], // Light grey background for the whole screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: ColoredBox(
                color: Color.fromARGB(255, 154, 243, 157),
                child: Center(
                  child: SearchRow(),
                ),
              ),
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ColoredBox(
                  color: const Color.fromARGB(255, 187, 210, 230),
                  child: CardRowNew(), //CardRow(currentCardId),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                left: 10.0,
                top: 0.0,
                right: 10.0,
                bottom: 0.0,
              ),
              child: ButtomsRow(),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchRow extends StatelessWidget {
  const SearchRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('search row');
  }
}

class ButtomsRow extends StatelessWidget {
  const ButtomsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () {
                  print('111');
                },
                child: const Icon(Icons.navigate_next)),
          ),
          Expanded(
            child: TextButton(
                onPressed: () {
                  print('222');
                },
                child: const Icon(Icons.done)),
          ),
        ],
      ),
    );
  }
}
