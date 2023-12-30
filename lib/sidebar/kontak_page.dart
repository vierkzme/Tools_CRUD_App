import 'package:kontak_app/form/kontak_form_page.dart';
import 'package:flutter/material.dart';

class Kontak {
  String nama;
  String nomor;
  String email;

  Kontak({
    required this.nama,
    required this.nomor,
    required this.email,
  });
}

class KontakPage extends StatefulWidget {
  const KontakPage({Key? key}) : super(key: key);

  @override
  State<KontakPage> createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  final List<Kontak> _listKontak = [];

  @override
  void initState() {
    super.initState();
  }

  _showPopupMenuItem(BuildContext context, int index) {
    final kontakClicked = _listKontak[index];

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateEditScreen(
                        mode: FormMode.edit,
                        kontak: kontakClicked,
                      ),
                    ),
                  );
                  if (result is Kontak) {
                    setState(() {
                      _listKontak[index] = result;
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Hapus'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Apakah anda yakin?'),
                      content:
                          Text('Kontak ${kontakClicked.nama} akan dihapus'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _listKontak.removeAt(index);
                            });
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text('Iya'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1212EF),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text('Kontak', style: TextStyle(color: Colors.white)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const CreateEditScreen(mode: FormMode.create)),
          );
          if (result is Kontak) {
            setState(() {
              _listKontak.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
      body: _listKontak.isEmpty
          ? const Center(
              child: Text(
                'Daftar Kontak Kosong',
                style: TextStyle(fontSize: 24),
              ),
            )
          : ListView.separated(
              itemCount: _listKontak.length,
              itemBuilder: (context, index) {
                const SizedBox(height: 20);
                final item = _listKontak[index];
                return ListTile(
                  leading:
                      CircleAvatar(child: Text(_listKontak[index].nama[0])),
                  onTap: () => _showPopupMenuItem(context, index),
                  title: Text('${item.nama}'),
                  subtitle: Text(
                    '${item.nomor} / ${item.email}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
    );
  }
}