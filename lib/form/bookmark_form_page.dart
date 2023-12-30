import 'package:flutter/material.dart';

class EditBookmarkPage extends StatefulWidget {
  final String title;
  final String link;
  final Function(String, String) onEdit;

  const EditBookmarkPage({
    super.key,
    required this.title,
    required this.link,
    required this.onEdit,
  });

  @override
  _EditBookmarkPageState createState() => _EditBookmarkPageState();
}

class _EditBookmarkPageState extends State<EditBookmarkPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    linkController.text = widget.link;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1212EF),
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text('Edit Bookmark', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveChanges();
        },
        child: const Icon(Icons.save),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                  labelText: 'Judul',
                  hintText: 'Masukkan Judul',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(
                  labelText: 'Link Bookmark',
                  hintText: 'Masukkan Link',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    String newTitle = titleController.text;
    String newLink = linkController.text;
    if (newTitle.isNotEmpty &&
        newLink.isNotEmpty &&
        newLink.startsWith('https://')) {
      widget.onEdit(newTitle, newLink);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Validasi Error'),
            content: const Text(
                'Link harus berawalan "https://" dan tidak boleh kosong'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}