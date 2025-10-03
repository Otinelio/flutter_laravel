import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoProvider extends ChangeNotifier {
  List<Todo> todos = [];

  Future<void> getTodoList() async {
    Uri url = Uri.parse("http://10.0.2.1:8000/api/api/todo");

    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> resultat = json.decode(response.body);

        todos = List<Todo>.from(
          resultat['data'].map((value) => Todo.fromjson(value)),
        );
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    notifyListeners();
  }
}
