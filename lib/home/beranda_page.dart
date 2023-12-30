import 'package:flutter/material.dart';
import 'package:kontak_app/main.dart';
import 'package:kontak_app/sidebar/kontak_page.dart';
import 'package:kontak_app/sidebar/bookmark_page.dart';
import 'package:kontak_app/sidebar/movie_page.dart';
import 'package:kontak_app/sidebar/todo_page.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1212EF),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Selamat Datang',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Center(
        child: Text(
          'Selamat Datang Di Tools Crud APP',
          style: TextStyle(fontSize: 24),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text(
                'Admin',
                style: TextStyle(fontSize: 18),
              ),
              accountEmail: Text(
                'admin@gmail.com',
                style: TextStyle(fontSize: 16),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 50, color: Color(0xFF1212EF)),
              ),
              decoration: BoxDecoration(color: Color(0xFF1212EF)),
            ),
            ListTile(
              title: const Text('Kontak'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const KontakPage()),
                );
              },
            ),
            ListTile(
              title: const Text('To-Do List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ToDoPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Bookmark'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookmarkPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Movie List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoviePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Log-out'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}