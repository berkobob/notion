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

  //  final name = ;
  //     late final Tag tag;
  //     switch (project['properties']['Tags']['select']['id']) {
  //       case 'bf338f9a-c2b6-4275-9d00-3d83fadf5021':
  //         tag = Tag.catergory;
  //         break;
  //       case '3acaaf93-8453-47ea-8f66-6fc10e55f3b8':
  //         tag = Tag.project;
  //         break;
  //     }

  @override
  String toString() => 'Proj Name: $name\t$tag';
}

enum Tag { catergory, project, list }
