import 'package:floor/floor.dart';

@Entity()
class User {
  @primaryKey
  final int id;

  final String name;

  User(this.id, this.name);
}
