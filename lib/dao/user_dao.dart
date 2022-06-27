import 'package:floor/floor.dart';

import '../model/user.dart';

@dao
abstract class UserDao {
  @Query('select * from User where id =:id')
  Future<User?> findUserById(int id);

  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUser(User user);
}
