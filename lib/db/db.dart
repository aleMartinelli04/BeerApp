import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Database {
  static final Database _instance = Database._internal();

  factory Database() => _instance;

  Database._internal();

  late final _database;
  late final _lastUserDatabase;

  User? _currentUser;

  get currentUser => _currentUser;

  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();

    _database = openDatabase(
      join(await getDatabasesPath(), "beer_app.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE users(email TEXT PRIMARY KEY, password TEXT, favorites TEXT, shopList TEXT)",
        );
      },
      version: 2,
    );

    _lastUserDatabase = openDatabase(
      join(await getDatabasesPath(), "last_user.db"),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE last_user(access TEXT PRIMARY KEY, email TEXT)",
        );
      },
      version: 1,
    );

    _currentUser = await getLastUser();
  }

  Future<User?> getLastUser() async {
    final db = await _lastUserDatabase;

    final List<Map<String, dynamic>> maps = await db.query('last_user');

    if (maps.isEmpty) {
      return null;
    }

    String mail = maps[0]['email'];

    return await getUser(mail);
  }

  Future<void> addUser(String email, String password) async {
    final db = await _database;

    checkIfUserExists(email);

    await db.insert(
      'users',
      User(email, password).toMap(),
    );
  }

  Future<void> checkIfUserExists(String email) async {
    final db = await _database;

    final List<Map<String, dynamic>> maps =
        await db.query('users', where: "email = ?", whereArgs: [email]);

    if (maps.isEmpty) {
      throw Exception("User does not exist");
    }
  }

  Future<void> checkIfUserDoesNotExist(String email) async {
    final db = await _database;

    final List<Map<String, dynamic>> maps =
        await db.query('users', where: "email = ?", whereArgs: [email]);

    if (maps.isNotEmpty) {
      throw Exception("User already exists");
    }
  }

  Future<void> checkUser(String email, String password) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('users', where: "email = ?", whereArgs: [email]);

    if (maps.isEmpty) {
      throw Exception("User does not exist");
    }

    if (maps[0]['password'] != password) {
      throw Exception("Wrong password");
    }
  }

  Future<User> getUser(String email) async {
    final db = await _database;
    final List<Map<String, dynamic>> maps =
        await db.query('users', where: "email = ?", whereArgs: [email]);

    if (maps.isEmpty) {
      throw Exception("User does not exist");
    }

    return User.fromMap(maps[0]);
  }

  Future<void> login(String email) async {
    _currentUser = await getUser(email);

    final db = await _lastUserDatabase;

    await db.insert(
      'last_user',
      {
        'access': 'last_user',
        'email': email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> logout() async {
    _currentUser = null;

    final db = await _lastUserDatabase;

    await db.delete('last_user', where: "access = ?", whereArgs: ['last_user']);
  }

  Future<void> updateUser(User user) async {
    final db = await _database;

    await db.update(
      'users',
      user.toMap(),
      where: "email = ?",
      whereArgs: [user.email],
    );
  }
}

class User {
  final String email;
  final String password;
  final List<int> favorites;
  final List<int> shopList;

  User(this.email, this.password,
      {this.favorites = const [], this.shopList = const []});

  List<int> getFavorites() {
    return favorites;
  }

  List<int> getShopList() {
    return shopList;
  }

  void addFavorite(int id) {
    favorites.add(id);
    Database().updateUser(this);
  }

  void removeFavorite(int id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
      Database().updateUser(this);
    }
  }

  void addShopList(int id) {
    shopList.add(id);
    Database().updateUser(this);
  }

  void removeShopList(int id) {
    if (shopList.contains(id)) {
      shopList.remove(id);
      Database().updateUser(this);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
      "favorites": favorites.join('-'),
      "shopList": shopList.join('-'),
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    List<int> favorites = [];
    for (var id in map['favorites'].split('-')) {
      if (id == "") {
        break;
      }

      favorites.add(int.parse(id));
    }

    List<int> shopList = [];
    for (var id in map['shopList'].split('-')) {
      if (id == "") {
        break;
      }

      shopList.add(int.parse(id));
    }

    return User(map['email'], map['password'],
        favorites: favorites, shopList: shopList);
  }
}
