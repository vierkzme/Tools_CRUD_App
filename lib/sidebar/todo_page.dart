import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Todo {
  String title;
  int id;

  Todo({
    required this.title,
    required this.id,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      id: int.parse(json['id'].toString()),
    );
  }
}

class TodoService {
  final String apiUrl;

  TodoService({required this.apiUrl});

  Future<List<Todo>> getTodos() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      Iterable data = jsonDecode(response.body);
      return data.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  }

  Future<void> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": todo.title}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add todo');
    }
  }

  Future<void> removeTodo(int id) async {
    try {
      final response = await http.delete(Uri.parse('$apiUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
      } else {
        print('Failed to remove todo. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Gagal meng-delete todo');
      }
    } catch (e) {
      print('Error removing todo: $e');
      throw Exception('Gagal meng-delete todo');
    }
  }

  Future<void> updateTodo(int id, Todo updatedTodo) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": updatedTodo.title}),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal meng-update todo');
    }
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  _ToDoPageState createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TodoService todoService =
      TodoService(apiUrl: 'https://659498171493b011606aaa91.mockapi.io/todolist');
  List<Todo> todoList = [];
  TextEditingController todoController = TextEditingController();
  TextEditingController editTodoController = TextEditingController();
  int editingIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _addTodo() async {
    if (todoController.text.isNotEmpty) {
      try {
        Todo newTodo = Todo(id: 0, title: todoController.text);
        await todoService.addTodo(newTodo);
        await _loadTodos();
        todoController.clear();
      } catch (e) {
        print('Error pada saat meng-add todo: $e');
      }
    }
  }

  Future<void> _loadTodos() async {
    try {
      List<Todo> todos = await todoService.getTodos();
      setState(() {
        todoList = todos;
      });
    } catch (e) {
      print('Error pada saat meng-load todos: $e');
    }
  }

  Future<void> _removeTodo(int index) async {
    try {
      await todoService.removeTodo(todoList[index].id);
      await _loadTodos();
    } catch (e) {
      print('Error pada saat meng-delete todo: $e');
      if (e is http.Response) {
        print('Response status code: ${e.statusCode}');
        print('Response body: ${e.body}');
      }
    }
  }

  Future<void> _startEditing(int index) async {
    setState(() {
      editingIndex = index;
      editTodoController.text = todoList[index].title;
    });
  }

  Future<void> _finishEditing() async {
    try {
      await todoService.updateTodo(
        todoList[editingIndex].id,
        Todo(id: todoList[editingIndex].id, title: editTodoController.text),
      );
      await _loadTodos();
      setState(() {
        editingIndex = -1;
        editTodoController.clear();
      });
    } catch (e) {
      print('Error pada saat meng-update todo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1212EF),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('To-Do List', style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: todoController,
              decoration: const InputDecoration(
                hintText: 'Tambahkan To-Do',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addTodo();
              },
              child: const Text('Simpan'),
            ),
            const SizedBox(height: 20),
            _buildTodoList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodoList() {
    return Expanded(
      child: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (context, index) {
          return _buildTodoItem(index);
        },
      ),
    );
  }

  Widget _buildTodoItem(int index) {
    return ListTile(
      title: GestureDetector(
        onTap: () {
          _startEditing(index);
        },
        child: editingIndex == index
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: editTodoController,
                      onEditingComplete: () {
                        _finishEditing();
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _finishEditing();
                    },
                    child: const Text('Simpan'),
                  ),
                ],
              )
            : Text(todoList[index].title),
      ),
      trailing: ElevatedButton(
        onPressed: () {
          _removeTodo(index);
        },
        child: const Text('Hapus'),
      ),
    );
  }
}