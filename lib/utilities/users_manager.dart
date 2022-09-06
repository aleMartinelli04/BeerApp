import 'package:localstorage/localstorage.dart';

class UsersManager {
  static final UsersManager _instance = UsersManager._internal();
  factory UsersManager() => _instance;
  UsersManager._internal();

  final LocalStorage _storage = LocalStorage("users_json.json");

  late User _currentUser;

  void addUser(String email, String password) {
    dynamic userJson = _storage.getItem(email);

    if (userJson != null) {
      throw Exception("User already exists");
    }

    _storage.setItem(email, {"password": password, "favorites": []});
  }

  User getCurrentUser() => _currentUser;

  void checkUser(String email, String password) {
    dynamic userJson = _storage.getItem(email);

    if (userJson == null) {
      throw Exception("User does not exist");
    }

    if (userJson['password'] != password) {
      throw Exception("Wrong password");
    }
  }

  void login(String email, String password) {
    _currentUser = User(email, password);
  }

  dynamic all() {
    return [_storage.getItem("a"), _storage.getItem("b"), _storage.getItem("c")];
  }
}


class User {
  final String email;
  final String password;

  User(this.email, this.password);

  List<int> getFavoritesBeersIds() {
    List<int> ids = [];
    for (int id in UsersManager._instance._storage.getItem(email)['favorites']) {
      ids.add(id);
    }

    return ids;
  }

  void addFavorite(int id) {
    List<int> favorites = getFavoritesBeersIds();
    favorites.add(id);
    UsersManager._instance._storage.setItem(email, toJson(ids: favorites));
  }

  void removeFavorite(int id) {
    List<int> favorites = getFavoritesBeersIds();

    if (favorites.contains(id)) {
      favorites.remove(id);
      UsersManager._instance._storage.setItem(email, toJson(ids: favorites));
    }
  }

  Map<String, dynamic> toJson({List<int>? ids}) {
    return {
      "password": password,
      "favorites": ids ?? getFavoritesBeersIds(),
    };
  }

  @override
  String toString() {
    return "User: $email, password: $password, favorites: ${getFavoritesBeersIds().join(", ")}";
  }
}
