// ONLINE

// OFFLINE

import 'package:mobile/back/services.dart';

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

List<Area> automatisations = [
  Area(user: "user", actions: [], name: "area 1 a afficher", favorite: true),
  Area(user: "user", actions: [], name: "area 2 a pas afficher"),
  Area(user: "user", actions: [], name: "area 3 a pas afficher"),
  Area(user: "user", actions: [], name: "area 4 a afficher", favorite: true),
];

List login(String user, String password) {
  String token = "abc123";
  if (user == "user" && password == "password") {
    return [true, token];
  }
  return [false, ""];
}

List<Area> getAreas() {
  return automatisations;
}

void addArea(Area area, String user) {
  area.user = user;
  automatisations.add(area);
}

void editArea(Area area, Area savedArea) {
  for (var automatisation in automatisations) {
    if (automatisation == savedArea) {
      automatisation = area;
    }
  }
}

void sendResetPassword() {}
