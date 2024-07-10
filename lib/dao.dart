import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:lab06/list_item.dart';

@dao
abstract class ListDAO {
  @Query('SELECT * FROM ListItem')
  Future<List<ListItem>> findAllListItems();

  @Query('DELETE FROM ListItem where id = :id')
  Future<int?> delete(int id);

  @insert
  Future<int> insertList(ListItem listItem);
}