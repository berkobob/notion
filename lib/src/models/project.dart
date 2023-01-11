class Project {
  String id;
  String name;
  Tag tag;

  Project({required this.id, required this.name, this.tag = Tag.list});

  Project.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['properties']['Name']['title'][0]['text']['content'],
        tag = json['properties']['Tags']['select']['id'] ==
                'bf338f9a-c2b6-4275-9d00-3d83fadf5021'
            ? Tag.catergory
            : Tag.project;

  @override
  String toString() => 'Proj Name: $name\t$tag\tID: $id';
}

enum Tag { catergory, project, list }
