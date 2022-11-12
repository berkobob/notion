class Notion {
  String id = '';
  String? status;
  String task;
  String url = '';

  Notion({required this.task, this.status});

  Notion.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        task = json["properties"]["Task"]['title'].first['text']['content'],
        url = json["url"];

  @override
  String toString() => '$task\t$status\t$url';
}
