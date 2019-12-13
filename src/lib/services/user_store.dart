import 'package:src/model/user.dart';
import 'package:src/src.dart';
import 'package:meta/meta.dart';

class UserStore {
  UserStore(this.db, this.users);

  final Database db;
  final StoreRef users;

  Future<User> authenticate(String mail, String password) async {
    final result = await users.findFirst(db,
        finder: Finder(
            filter: Filter.and([
          Filter.equals("mail", mail),
          Filter.equals("password", password),
        ])));
    if (result == null) {
      return null;
    }
    return User.from(result);
  }

  Future<bool> hasUser(String mail) async {
    return await users.findFirst(db,
            finder: Finder(filter: Filter.equals("mail", mail))) !=
        null;
  }

  Future<void> addUser(User user) async {
    await users.add(db, user.asMap());
  }
}
