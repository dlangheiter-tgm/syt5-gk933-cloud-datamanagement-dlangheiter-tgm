import 'package:src/model/login.dart';
import 'package:src/model/user.dart';

import 'harness/harness.dart';

export 'harness/harness.dart';

abstract class TestRunner {
  TestRunner({this.harness, this.name, this.contentType});

  Harness harness;
  String name;
  ContentType contentType;

  final goodLogin = Login(mail: "t@t", password: "t");
  final goodUser = User(name: "Test account", mail: "t@t", password: "t");
  final badLogin = Login(mail: "wrong@wrong", password: "wrong");

  void initVars(Harness harness, String name, ContentType contentType) {
    this.harness = harness;
    this.name = name;
    this.contentType = contentType;
  }

  void run();
}