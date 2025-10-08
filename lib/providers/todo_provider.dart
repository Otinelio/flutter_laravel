import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_laravel/models/todo.dart';
import 'package:http/http.dart' as http;

class TodoProvider extends ChangeNotifier {
  List<Todo> todos = [];

  Future<void> getTodoList() async {
    // Utilisez l'adresse IP de votre serveur Laravel
    Uri url = Uri.parse("http://192.168.1.78:8000/api/todo");
    
    debugPrint("Tentative de connexion à l'API: $url");
    
    try {
      // Ajout d'en-têtes pour éviter les problèmes CORS
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json', 
      };
      
      http.Response response = await http.get(url, headers: headers);
      debugPrint("Statut de la réponse: ${response.statusCode}");
      debugPrint("Corps de la réponse: ${response.body}");

      if (response.statusCode == 200) {
        Map<String, dynamic> resultat = json.decode(response.body);
        debugPrint("Structure JSON: ${resultat.keys}");

        todos = List<Todo>.from(
          resultat['data'].map((value) => Todo.fromjson(value)),
        );
        debugPrint("Nombre d'éléments récupérés: ${todos.length}");
      } else {
        throw Exception('Erreur HTTP: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      debugPrint("ERREUR: ${e.toString()}");
    }

    notifyListeners();
  }
}
