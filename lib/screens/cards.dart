import 'package:flutter/material.dart';
import 'package:tf_mobile/database/app_database.dart';
// import 'package:tf_mobile/model/task.dart';
import 'package:tf_mobile/screens/card_form.dart';

class CardTab extends StatefulWidget {
  const CardTab({super.key});

  @override
  State<StatefulWidget> createState() => CardTabState();
}

class CardTabState extends State<CardTab> {
  int currentCardId = 0;
  int cardsNumber = 0;
  final AppDatabase db = AppDatabase.instance;

  //set currentCardId(int val) => currentCardId = val;

  @override
  void initState() {
    super.initState();

    var cards = db
        .getCards()
        .then((value) => {print('initState cards ' + value.length.toString())});
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
        title: const Text('My space'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add card',
            onPressed: () {
              print('actions add');
              setState(() {
                cardsNumber++;
                print(cardsNumber);

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CardForm(0)));

                // var task = Task(
                //   title: 'title $cardsNumber',
                //   description: 'description $cardsNumber',
                //   dueDate: DateTime.now(),
                //   isDone: false,
                // );
                // db.createTask(task);

                // db.getTasks().then((tasks) => {print(tasks.length)});
              });
            },
          ),
        ],
      ),
      body: const CardBody(),
    );
  }
}

class CardBody extends StatelessWidget {
  const CardBody({super.key});

  @override
  Widget build(context) {
    return const Column(
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
          padding: EdgeInsets.only(
            left: 10.0,
            top: 0.0,
            right: 10.0,
            bottom: 0.0,
          ),
          child: ButtomsRow(),
        ),
      ],
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
  const CardRow({super.key});

  @override
  Widget build(BuildContext context) {
    final AppDatabase db = AppDatabase.instance;

    db.getCards().then((value) => print('cards ${value.length}'));

    return InkWell(
      onLongPress: () {
        print('onLongPress');

        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CardForm(1)));

        // db.getTasks().then((tasks) {
        //   var task = tasks[1];
        //   print(task);
        //   task.title = 'ssss2';
        //   db.updateTask(task);
        //   db.getTasks().then((newTasks) => print(newTasks[1]));
        //   db.getTask(15).then((value) => print(value));
        // });
      },
      child: Ink(
        color: const Color.fromARGB(255, 187, 210, 230),
        // child: const Center(
        //   child: Text(
        //       'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede'),
        // ),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  'Lorem ipsum dolor sit amet, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede'),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                  'Lorem ipsum dolor sit sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede'),
            ),
          ],
        ),
      ),
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
