import 'project.dart';

class Notion {
  String? id = '';
  String? status;
  String task;
  String url = '';
  Project? project;

  Notion({this.id, required this.task, this.status, this.project});

  Notion.fromJson(Map<String, dynamic> json, {this.project})
      : id = json["id"],
        task = json["properties"]["Task"]['title'].first['text']['content'],
        url = json["url"];

  @override
  String toString() => '$task\t$project\t$status\t$url';
}
