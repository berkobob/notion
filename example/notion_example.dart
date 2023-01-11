import 'package:logger/logger.dart';
import 'package:notion/notion.dart';

void main() async {
  final log = Logger()..registerPrinter(printer);
  var notiondb = NotionDB();
  // print(await notion.hasAccess());
  final notions = await notiondb.getNotions();
  for (var n in notions) {
    log.i(n.toString());
  }

  final projects = await notiondb.getProjects();
  for (var p in projects) {
    print('$p');
  }
  // final notion = notions[0];
  // print(notion);
  // notiondb.addNote(notion, "Testing time");

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
  // final results = notion.getProjects.listen(print);
  // print(await notion.getProjects());
}
