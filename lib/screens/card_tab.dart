import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/model/entity/card.dart';
import 'package:tf_mobile/screens/card_form.dart';
import 'package:tf_mobile/main.dart';
import 'package:tf_mobile/screens/card_row.dart';
import 'package:tf_mobile/design/colors.dart';
import 'dart:async';
import 'package:tf_mobile/assets/constants.dart' as constants;
import 'package:tf_mobile/services/http_service.dart';

class CardTab extends StatefulWidget {
  const CardTab({super.key});

  @override
  State<StatefulWidget> createState() => CardTabState();
}

class CardTabState extends State<CardTab> {
  late AppDatabase db;
  late Future<CardEntity> cardFuture;
  final HttpService httpService = HttpService();

  @override
  void initState() {
    print('initState of CardTabState');
    super.initState();
    db = AppDatabase.instance;
    _fetchCard();
  }

  Future<void> _fetchCard() async {
    print('_fetchCard');
    try {
      setState(() {
        cardFuture = db.getCardToLearn();
      });
    } catch (e) {
      cardFuture = Future.error('No unlearned cards available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PopupMenuButton<int>(
          icon: const Icon(Icons.menu),
          onSelected: (value) {
            // Handle menu item selection here
            if (value == 1) {
              print('one');
            } else if (value == 2) {
              // Exit the app
              SystemNavigator.pop();
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 1,
              child: Text('Cards'),
            ),
            PopupMenuItem(
              value: 2,
              child: Text('Exit'),
            ),
          ],
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
              example: card.example!,
              onNextCard: () => _fetchCard(), // Function to fetch next card
            );
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
  final VoidCallback onNextCard;

  const CardBody({
    super.key,
    required this.cardId,
    required this.front,
    required this.back,
    required this.example,
    required this.onNextCard,
  });

  @override
  Widget build(context) {
    print('build CardBody');

    return Scaffold(
      backgroundColor: cardBodyBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: SearchRow(),
              ),
            ),
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ColoredBox(
                  color: cardBodyBackgroundColor,
                  child: CardRow(
                      cardId: cardId,
                      front: front,
                      back: back,
                      example: example),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 0.0,
                right: 10.0,
                bottom: 0.0,
              ),
              child: ButtomsRow(
                cardId: cardId,
                onNextCard: onNextCard,
              ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: searchBackgroundColor,
              ),
              onChanged: (query) {
                // Handle the search logic here
                print('Search query: $query');
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ButtomsRow extends StatelessWidget {
  final int cardId;
  final VoidCallback onNextCard;

  const ButtomsRow({
    super.key,
    required this.cardId,
    required this.onNextCard,
  });

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = AppDatabase.instance;

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: TextButton(
                onPressed: () async {
                  var updatedCard = await db.getCard(cardId);
                  updatedCard.editDateTime = DateTime.now();
                  db.updateCardFromForm(updatedCard);

                  onNextCard(); // Call the callback to fetch the next card
                },
                child: const Icon(Icons.navigate_next)),
          ),
          Expanded(
            child: TextButton(
                onPressed: () async {
                  var updatedCard = await db.getCard(cardId);
                  updatedCard.editDateTime = DateTime.now();
                  updatedCard.status = constants.cardIsLearned;
                  db.updateCardFromForm(updatedCard);

                  onNextCard(); // Call the callback to fetch the next card
                },
                child: const Icon(Icons.done)),
          ),
        ],
      ),
    );
  }
}
