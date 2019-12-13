import '../src.dart';

class Login extends Serializable {
  Login({this.mail, this.password});

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
