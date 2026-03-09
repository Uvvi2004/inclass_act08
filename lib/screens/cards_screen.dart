import 'package:flutter/material.dart';
import '../repositories/card_repository.dart';
import '../models/card_model.dart';
import '../models/folder.dart';

class CardsScreen extends StatefulWidget {

  final Folder folder;

  CardsScreen({required this.folder});

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {

  final CardRepository repository = CardRepository();
  List<CardModel> cards = [];

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  void loadCards() async {
    final data = await repository.getCardsByFolder(widget.folder.id!);

    setState(() {
      cards = data;
    });
  }

  void addCard(String name, String suit) async {

    final card = CardModel(
      cardName: name,
      suit: suit,
      imageUrl: "https://deckofcardsapi.com/static/img/AS.png",      
      folderId: widget.folder.id!,
    );

    await repository.insertCard(card);
    loadCards();
  }

  void deleteCard(int id) async {
    await repository.deleteCard(id);
    loadCards();
  }

  void showAddCardDialog() {

    TextEditingController nameController = TextEditingController();
    TextEditingController suitController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Card"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Card Name"),
            ),

            TextField(
              controller: suitController,
              decoration: InputDecoration(hintText: "Suit"),
            ),
          ],
        ),
        actions: [

          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),

          TextButton(
            child: Text("Add"),
            onPressed: () {

              addCard(
                nameController.text,
                suitController.text,
              );

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.folder.folderName),
      ),

      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {

          final card = cards[index];

          return ListTile(

            leading: Image.network(
              card.imageUrl.isEmpty
                  ? "https://deckofcardsapi.com/static/img/AS.png"
                  : card.imageUrl,
              width: 50,
            ),

            title: Text(card.cardName),
            subtitle: Text(card.suit),

            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                deleteCard(card.id!);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddCardDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}