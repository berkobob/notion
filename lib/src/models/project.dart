class Project {
  String id;
  String name;
  Tag tag;

  Project({required this.id, required this.name, required this.tag});

  @override
  String toString() => '$name\t$tag';
}

enum Tag { catergory, project }
