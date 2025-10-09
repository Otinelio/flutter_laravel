import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/todo.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> todos = [];

  Future<void> getTodoList() async {
    // Utilisez l'adresse IP de votre serveur Laravel
    Uri url = Uri.parse("http://192.168.1.78:8000/api/todo");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> resultat = json.decode(response.body);

        todos = List<Todo>.from(
          resultat['data'].map((value) => Todo.fromjson(value)),
        );
      } else {
        throw Exception(
          'Erreur HTTP: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint("ERREUR: ${e.toString()}");
    }

    notifyListeners();
  }

  Future<void> createTodoList({
    required String title,
    required String createdBy,
    required String description,
    required XFile imageFile,
  }) async {
    Uri url = Uri.parse("http://192.168.1.78:8000/api/todo");

    try {
      File file = File(imageFile.path);
      Uint8List byte = await file.readAsBytes();

      http.MultipartRequest request = http.MultipartRequest('POST', url)
        ..fields['title'] = title
        ..fields['created_by'] = createdBy
        ..fields['description'] = description
        ..files.add(
          http.MultipartFile.fromBytes(
            'imageFile',
            byte,
            filename: imageFile.name,
          ),
        );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();

        todos.insert(0, Todo.fromjson(json.decode(responseStream)['data']));
      } else {
        throw Exception('Erreur');
      }
    } catch (e) {
      debugPrint("ERREUR: ${e.toString()}");
    }

    notifyListeners();
  }

  Future<void> updateTodoList({
    required int id,
    required String title,
    required String createdBy,
    required String description,
    XFile? imageFile,
  }) async {
    Uri url = Uri.parse("http://192.168.1.78:8000/api/todo/$id");

    try {
      http.MultipartRequest request = http.MultipartRequest('POST', url)
        ..fields['title'] = title
        ..fields['created_by'] = createdBy
        ..fields['description'] = description;

      if (imageFile != null) {
        File file = File(imageFile.path);
        Uint8List byte = await file.readAsBytes();

        request.files.add(
          http.MultipartFile.fromBytes(
            'imageFile',
            byte,
            filename: imageFile.name,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseStream = await response.stream.bytesToString();

        int indexOfTodo = todos.indexWhere((todo) => todo.id == id);
        todos[indexOfTodo] = Todo.fromjson(json.decode(responseStream)['data']);
      } else {
        throw Exception('Erreur');
      }
    } catch (e) {
      debugPrint("ERREUR: ${e.toString()}");
    }

    notifyListeners();
  }

  Future<void> deleteTodoList(int id) async {
    // Utilisez l'adresse IP de votre serveur Laravel
    Uri url = Uri.parse("http://192.168.1.78:8000/api/todo/$id");

    try {
      http.Response response = await http.delete(url);

      if (response.statusCode == 200) {
        int indexOfTodo = todos.indexWhere((todo) => todo.id == id);
        todos.removeAt(indexOfTodo);
      } else {
        throw Exception(
          'Erreur HTTP: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint("ERREUR: ${e.toString()}");
    }

    notifyListeners();
  }
}
