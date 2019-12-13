import '../src.dart';

class Login extends Serializable {
  Login({this.mail, this.password});
  Login.copy(Login l): mail = l.mail, password = l.password;

  String mail;
  String password;

  @override
  String toString() {
    return 'Login{mail: $mail, password: $password}';
  }

  @override
  Map<String, dynamic> asMap() => {
        "mail": mail,
        "password": password,
      };

  @override
  void readFromMap(Map<String, dynamic> object) {
    mail = ifListFirst(object["mail"]);
    password = ifListFirst(object["password"]);
  }
}
