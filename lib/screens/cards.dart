import 'package:flutter/material.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/card.dart';
import 'package:tf_mobile/screens/card_form.dart';
// import 'package:tf_mobile/stream_manager.dart';
// import 'package:tf_mobile/screens/card_row.dart';
import 'package:tf_mobile/screens/card_new.dart';
import 'package:tf_mobile/design/colors.dart';
import 'dart:async';

class CardTab extends StatefulWidget {
  const CardTab({super.key});

  @override
  State<StatefulWidget> createState() => CardTabState();
}

class CardTabState extends State<CardTab> {
  late AppDatabase db;
  late Future<CardEntity> cardFuture;

  @override
  void initState() {
    print('initState of CardTabState');
    super.initState();
    db = AppDatabase.instance;
    _fetchCard();
  }

  Future<void> _fetchCard() async {
    cardFuture = db.getCard(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CardForm(0, '', '', ''),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<CardEntity>(
        future: cardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(''); //Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            final card = snapshot.data!;

            return CardBody(
                cardId: card.id!,
                front: card.front!,
                back: card.back!,
                example: card.example!);
          }
        },
      ),
    );
  }
}

class CardBody extends StatelessWidget {
  final int cardId;
  final String front;
  final String back;
  final String example;

  const CardBody({
    super.key,
    required this.cardId,
    required this.front,
    required this.back,
    required this.example,
  });

  @override
  Widget build(context) {
    print('build CardBody');

    return Scaffold(
      backgroundColor: greyCardBodyBackground,
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
                  color: greyCardBodyBackground,
                  child: CardRowNew(
                      cardId: cardId,
                      front: front,
                      back: back,
                      example: example),
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
