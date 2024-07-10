import 'package:floor/floor.dart';
import 'package:lab06/main.dart';

@entity
class ListItem {
    @primaryKey
    final int id;
    String listItem;

    ListItem(this.id, this.listItem) {
        if(id >= MyHomePage.ID) {
          MyHomePage.ID = id + 1;
        }
    }

    int getID() {
        return this.id;
    }
}