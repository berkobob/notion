import 'package:notion/notion.dart';

void main() async {
  var notion = NotionDB();
  // print(await notion.hasAccess());
  // final notions = await notion.getNotions();
  // Notion todo = notions.first;
  // print(todo);
  // todo.status = 'This is new';
  // todo.task = 'Let us hope this works';
  // notion.saveNotion(todo);
  // print(todo);
  // todo = notions.last;
  // print('Delete $todo');
  // notion.deleteNotion(todo);
  // final todo = Notion(task: "I am creating this task");
  // final result = await notion.createNotion(todo);
  // print(todo);
  // print(result);
  final results = await notion.getProjects();
  results.forEach(print);
}
