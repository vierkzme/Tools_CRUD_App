import 'package:kontak_app/sidebar/kontak_page.dart';
import 'package:flutter/material.dart';

enum FormMode { create, edit }

class CreateEditScreen extends StatefulWidget {
  const CreateEditScreen({super.key, required this.mode, this.kontak});

  final FormMode mode;
  final Kontak? kontak;

  @override
  State<CreateEditScreen> createState() => _CreateEditScreenState();
}

class _CreateEditScreenState extends State<CreateEditScreen> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.edit) {
      _namaController.text = widget.kontak!.nama;
      _nomorController.text = widget.kontak!.nomor;
      _emailController.text = widget.kontak!.email;
    }
  }

  Kontak getKontak() {
    return Kontak(
      nama: _namaController.text,
      nomor: _nomorController.text,
      email: _emailController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1212EF),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Kontak',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context, getKontak());
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.mode == FormMode.create ? 'Tambah' : 'Simpan',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SizedBox(height: 20),
            Text(
                widget.mode == FormMode.create
                    ? 'Tambah Kontak'
                    : 'Edit Kontak',
                style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 30),
            TextFormField(
              controller: _namaController,
              decoration: const InputDecoration(
                  labelText: 'Nama',
                  hintText: 'Masukkan Nama',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nomorController,
              maxLength: 13,
              decoration: const InputDecoration(
                  labelText: 'Nomor',
                  hintText: 'Masukkan Nomor',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
          ],
        ),
      ),
    );
  }
}