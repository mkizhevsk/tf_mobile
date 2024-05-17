import 'package:flutter/material.dart';
import 'package:tf_mobile/database/app_database.dart';
import 'package:tf_mobile/screens/card_form.dart';
import 'package:tf_mobile/stream_manager.dart';
import 'package:tf_mobile/model/card.dart';
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

  StreamSubscription<int>? _subscription;

  @override
  void initState() {
    super.initState();
    print('initState of CardTabState');
    // Subscribe to the cardId stream
    _subscription = StreamManager().cardIdStream.listen((cardId) {
      setState(() {
        currentCardId = cardId;
        // Handle any additional logic here, e.g., fetch card details, etc.
        print('CardTabState Received cardId: $cardId');
      });
    });
    db.getCards().then((value) {
      for (var card in value) {
        print(card);
      }
    });
    // db.getCards().then((value) => print(value.length));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('here1 ' + currentCardId.toString());
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
                    builder: (context) => CardForm(0, '', '', '')));
              });
            },
          ),
        ],
      ),
      body: CardBody(currentCardId: currentCardId, frontSide: frontSide),
    );
  }
}

class CardBody extends StatelessWidget {
  final int currentCardId;
  final bool frontSide;

  const CardBody(
      {Key? key, required this.currentCardId, required this.frontSide})
      : super(key: key);

  @override
  Widget build(context) {
    print('build CardBody');
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ColoredBox(
              color: Color.fromARGB(255, 154, 243, 157),
              child: Center(
                child: SearchRow(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ColoredBox(
              color: Color.fromARGB(255, 187, 210, 230),
              child: CardRow(
                currentCardId: currentCardId,
                frontSide: frontSide,
              ),
            ),
          ),
          Padding(
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

class CardRow extends StatelessWidget {
  final int currentCardId;
  final bool frontSide;

  const CardRow(
      {Key? key, required this.currentCardId, required this.frontSide})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('build CardRow ' + currentCardId.toString());
    final AppDatabase db = AppDatabase.instance;

    return FutureBuilder<CardEntity>(
      future: db.getCard(currentCardId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Show a loader while fetching the card
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final card = snapshot.data!;

          return InkWell(
            onTap: () {
              // Add your onPressed logic here
            },
            onLongPress: () {
              print('onLongPress');
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CardForm(
                      currentCardId, card.front!, card.back!, card.example!)));
            },
            child: Ink(
              color: const Color.fromARGB(255, 187, 210, 230),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(frontSide ? card.front! : card.back!),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(frontSide ? '' : card.example!),
                  ),
                ],
              ),
            ),
          );
        } else {
          // Handle the case where snapshot.data is null
          return Text('No data available');
        }
      },
    );
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
