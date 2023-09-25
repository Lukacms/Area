// ONLINE

// OFFLINE

class Automatisation {
  int id;
  String user;
  int actionId;
  String reaction;

  Automatisation({
    required this.id,
    required this.user,
    required this.actionId,
    required this.reaction,
  });
}

List automatisations = [
  {
    "id": 0,
    "user": "user",
    "actionId": 0,
    "reaction": "reaction",
    "name": "action 1 a afficher (fav)",
    "favorite": true
  },
  {
    "id": 2,
    "user": "user",
    "actionId": 3,
    "reaction": "prout",
    "name": "action 2 a afficher(pas fav)",
    "favorite": false
  },
  {
    "id": 1,
    "user": "user",
    "actionId": 2,
    "reaction": "prout",
    "name": "action 3 a afficher(fav)",
    "favorite": true
  }
];

List login(String user, String password) {
  String token = "abc123";
  if (user == "user" && password == "password") {
    return [true, token];
  }
  return [false, ""];
}

List getAreas() {
  return automatisations;
}
