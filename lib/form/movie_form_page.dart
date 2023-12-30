import 'package:flutter/material.dart';

class MovieFormPage extends StatefulWidget {
  final Map<String, String> movieData;

  const MovieFormPage({super.key, required this.movieData});

  @override
  _MovieFormPageState createState() => _MovieFormPageState();
}

class _MovieFormPageState extends State<MovieFormPage> {
  final TextEditingController judulController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    judulController.text = widget.movieData['judul'] ?? '';
    linkController.text = widget.movieData['link'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1212EF),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Movie Form', style: TextStyle(color: Colors.white)),
        actions: [
          GestureDetector(
            onTap: () {
              _saveMovie();
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Simpan',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: judulController,
                decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul dibutuhkan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: linkController,
                decoration: const InputDecoration(
                    labelText: 'Link',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Link dibutuhkan';
                  } else if (!value.startsWith('https://')) {
                    return 'Link harus berawalan "https://"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _saveMovie() {
    if (_formKey.currentState?.validate() ?? false) {
      final newMovie = {
        'judul': judulController.text,
        'link': linkController.text,
      };
      Navigator.pop(context, newMovie);
    }
  }
}