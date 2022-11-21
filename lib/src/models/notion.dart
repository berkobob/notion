import 'project.dart';

class Notion {
  String id = '';
  String? status;
  String task;
  String url = '';
  Project? project;

  Notion({required this.task, this.status, this.project});

  Notion.fromJson(Map<String, dynamic> json, {this.project})
      : id = json["id"],
        task = json["properties"]["Task"]['title'].first['text']['content'],
        url = json["url"] {
    // final pr4ddojectJson = json["properties"]["Project"];
    // if (projectJson["relation"].isNotEmpty) {
    //   project = Project.fromJson(projectJson);
    // }
    // final statusText = json["properties"]["status"];
    // if (statusText != null) status = statusText["select"];
  }

  @override
  String toString() => '$task\t$project\t$status\t$url';
}
