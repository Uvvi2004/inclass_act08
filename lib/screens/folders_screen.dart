import 'package:flutter/material.dart';
import '../repositories/folder_repository.dart';
import '../models/folder.dart';
import 'cards_screen.dart';

class FoldersScreen extends StatefulWidget {
  @override
  _FoldersScreenState createState() => _FoldersScreenState();
}

class _FoldersScreenState extends State<FoldersScreen> {

  final FolderRepository repository = FolderRepository();
  List<Folder> folders = [];

  void showDeleteDialog(Folder folder) {

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Folder"),
        content: Text(
          "Deleting this folder will also delete all cards inside it.",
        ),
        actions: [

          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          TextButton(
            child: Text("Delete"),
            onPressed: () {

              deleteFolder(folder.id!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadFolders();
  }

  void loadFolders() async {
    final data = await repository.getFolders();
    setState(() {
      folders = data;
    });
  }

  void addFolder(String name) async {
    final folder = Folder(
      folderName: name,
      timestamp: DateTime.now().toString(),
    );

    await repository.insertFolder(folder);
    loadFolders();
  }

  void deleteFolder(int id) async {
    await repository.deleteFolder(id);
    loadFolders();
  }

  void showAddDialog() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Add Folder"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Folder Name"),
        ),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Add"),
            onPressed: () {
              addFolder(controller.text);
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
        title: Text("Card Organizer"),
      ),

      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {

          final folder = folders[index];

          return ListTile(
            title: Text(folder.folderName),

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CardsScreen(folder: folder),
                ),
              );
            },

            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDeleteDialog(folder);
              },
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}