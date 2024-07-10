import 'dart:async';

import 'package:floor/floor.dart';
import 'package:lab06/dao.dart';
import 'package:lab06/list_item.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part "database.g.dart";

@Database(version: 1, entities: [ListItem])
abstract class AppDatabase extends FloorDatabase {
  ListDAO get listDao;
}