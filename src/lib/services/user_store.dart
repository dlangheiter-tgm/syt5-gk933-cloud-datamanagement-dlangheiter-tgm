import 'package:src/model/user.dart';
import 'package:src/src.dart';

class UserStore {
  UserStore(this.db, this.users);

  final Database db;
  final StoreRef users;

  Future<User> authenticate(String mail, String password) async {
    final result = await users.findFirst(db,
        finder: Finder(filter: Filter.equals("mail", mail)));
    if (result == null) {
      return null;
    }
    User user = User.from(result);
    if(!Password.verify(password, user.password)) {
      return null;
    }
    return user;
  }

  Future<bool> hasUser(String mail) async {
    return await users.findFirst(db,
            finder: Finder(filter: Filter.equals("mail", mail))) !=
        null;
  }

  Future<void> addUser(User user) async {
    user.password = Password.hash(user.password, PBKDF2());
    await users.add(db, user.asMap());
  }
}
