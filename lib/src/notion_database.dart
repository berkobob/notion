import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:notion/src/notion_exception.dart';

import 'models/notion.dart';

class NotionDB {
  final _token = Platform.environment['TOKEN'];
  final _database = Platform.environment['DATABASE'];
  final _url = 'https://api.notion.com/v1';

  String? get token => _token;
  String? get database => _database;

  Map<String, String> get headers => {
        "Authorization": "Bearer $_token",
        "Content-Type": "application/json",
        "Notion-Version": "2022-06-28"
      };

  /// Whether access is available to the Notion API
  Future<bool> hasAccess() async {
    if (_token == null) throw 'Missing Notion Bearer token';
    if (_database == null) throw 'Missing Notion database ID';

    final response = await http.get(Uri.parse('$_url/databases/$_database'),
        headers: headers);

    if (response.statusCode == 200) return true;

    print('Response code: ${response.statusCode}');
    print('${response.reasonPhrase}');
    print(jsonDecode(response.body));
    return false;
  }

  /// Return a list of [Notion]s from the todo database
  Future<List<Notion>> getNotions() async {
    final uri = Uri.parse('$_url/databases/$_database/query');
    final response = await http.post(uri, headers: headers);

    if (response.statusCode != 200) throw NotionException(response);

    final results = jsonDecode(response.body)['results'];
    final notions =
        results.map<Notion>((result) => Notion.fromJson(result)).toList();
    return notions;
  }

  /// Patch changes to [Notion] to notion database
  Future saveNotion(Notion notion) async {
    final uri = Uri.parse('$_url/pages/${notion.id}');
    final body = jsonEncode(_properties(notion));
    final response = await http.patch(uri, headers: headers, body: body);
    if (response.statusCode != 200) throw NotionException(response);
  }

  /// Delete a [Notion]
  Future deleteNotion(Notion notion) async {
    final uri = Uri.parse('$_url/blocks/${notion.id}');
    final response = await http.delete(uri, headers: headers);
    if (response.statusCode != 200) throw NotionException(response);
  }

  /// Create a new [Notion]
  Future<Notion> createNotion(Notion notion) async {
    final uri = Uri.parse('$_url/pages');
    final payload = _properties(notion);
    payload['parent'] = {"database_id": "4fd84ba6b7944e58b902bfd6afd13b18"};
    final body = jsonEncode(payload);
    final response = await http.post(uri, headers: headers, body: body);
    if (response.statusCode != 200) throw NotionException(response);
    return Notion.fromJson(jsonDecode(response.body));
  }

  Map<String, dynamic> _properties(Notion notion) => {
        "properties": {
          "Task": {
            "title": [
              {
                "text": {"content": notion.task}
              }
            ]
          },
          if (notion.status != null)
            "Status": {
              "select": {"name": notion.status}
            }
        }
      };
}
