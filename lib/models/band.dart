

class Band {

  late String id;
  late String name;
  late int votes;


  Band({
    required this.id,
    required this.name,
    required this.votes,
  });


  factory Band.fromMap( Map<String, dynamic> obj )
    => Band(
      id    : obj.containsKey('id') ? obj['id'] : 'no-id',
      name  : obj.containsKey('name') ? obj['name'] : 'name',
      votes : obj.containsKey('votes') ? obj['votes'] : 'votes',
    );

}