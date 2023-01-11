import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'notion_exception.dart';
import 'models/notion.dart';
import 'models/project.dart';
import '../secrets.dart';

class NotionDB {
  final _token = Platform.environment['TOKEN'] ?? env['TOKEN'];
  final _database = Platform.environment['DATABASE'] ?? env['DATABASE'];
  final _projectsdb = Platform.environment['PROJECTS'] ?? env['PROJECTS'];
  final _url = 'https://api.notion.com/v1';
  final _log = Logger();

  List<Project> _projects = [];

  Project? getProject(String id) => _projects.firstWhere((p) => p.id == id);

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

    _log.d('Response code: ${response.statusCode}');
    _log.d('${response.reasonPhrase}');
    _log.d(jsonDecode(response.body));
    return false;
  }

  /// Return a list of [Notion]s from the todo database
  Future<List<Notion>> getNotions() async {
    final uri = Uri.parse('$_url/databases/$_database/query');
    final response = await http.post(uri, headers: headers);

    if (response.statusCode != 200) throw NotionException(response);

    final results = jsonDecode(response.body)['results'];
    if (_projects.isEmpty) await getProjects();
    assert(_projects.isNotEmpty);
    return results.map<Notion>((result) {
      Project? project;
      final relations = result["properties"]["Project"]["relation"];
      if (relations.isNotEmpty) {
        project = getProject(relations[0]["id"] as String);
      }
      return Notion.fromJson(result, project: project);
    }).toList();
  }

  /// Patch changes to [Notion] to notion database
  Future saveNotion(Notion notion) async {
    final uri = Uri.parse('$_url/pages/${notion.id}');
    final body = jsonEncode(_properties(notion));
    final response = await http.patch(uri, headers: headers, body: body);
    if (response.statusCode != 200) throw NotionException(response);
  }

  /// Delete a [Notion] given its ID
  Future deleteNotion(String id) async {
    final uri = Uri.parse('$_url/blocks/$id');
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

  /// Return a list of COIs & Projects as [Project]s
  Future<List<Project>> getProjects() async {
    final uri = Uri.parse('$_url/databases/$_projectsdb/query');
    final response = await http.post(uri, headers: headers);
    if (response.statusCode != 200) throw NotionException(response);
    _projects = jsonDecode(response.body)["results"]
        .map<Project>((project) => Project.fromJson(project))
        .toList();
    return _projects;
  }

  /// Add [String] note to [Notion]
  Future<void> addNote(Notion notion, String note) async {
    _log.d(notion.id.toString());
    final uri = Uri.parse('$_url/blocks/${notion.id}/children');
    _log.d(uri.toString());
    final body = jsonEncode({
      "children": [
        {
          "paragraph": {
            "rich_text": [
              {
                "type": "text",
                "text": {"content": note}
              }
            ]
          }
        }
      ]
    });
    final response = await http.patch(uri, headers: headers, body: body);
    if (response.statusCode != 200) throw NotionException(response);
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
            },
          if (notion.project != null)
            "Project": {
              "relation": [
                {"id": notion.project!.id}
              ]
            }
        }
      };
}
