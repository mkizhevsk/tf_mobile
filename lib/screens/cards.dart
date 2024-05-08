import 'package:flutter/material.dart';

class CardTab extends StatefulWidget {
  const CardTab({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CardTabState();
}

class CardTabState extends State<CardTab> {
  int cardsNumber = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          // tooltip: 'Show Snackbar',
          onPressed: () {
            print('leading');
          },
        ),
        title: Text('My space'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add card',
            onPressed: () {
              print('actions add');
              setState(() {
                cardsNumber++;
                print(cardsNumber);
              });
            },
          ),
        ],
      ),
      body: CardBody(),
    );
  }
}

class CardBody extends StatelessWidget {
  @override
  Widget build(context) {
    return Column(
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
            child: CardRow(),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: ColoredBox(
            color: Color.fromARGB(255, 241, 232, 145),
            child: Center(
              child: ButtomsRow(),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text('Search bar');
  }
}

class CardRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede'),
    );
  }
}

class ButtomsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () {
              print('111');
            },
            child: Icon(Icons.navigate_next)),
        TextButton(
            onPressed: () {
              print('111');
            },
            child: Icon(Icons.done)),
      ],
    );
  }
}
