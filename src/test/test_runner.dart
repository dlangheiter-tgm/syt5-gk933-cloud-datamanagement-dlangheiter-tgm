import 'package:src/model/login.dart';
import 'package:src/model/user.dart';

import 'contentTypeWithName.dart';
import 'harness/harness.dart';

export 'harness/harness.dart';

abstract class TestRunner {
  Harness harness;
  ContentTypeWithName contentType;
  ContentTypeWithName accept;

  final goodLogin = Login(mail: "setup@setup", password: "setup");
  final goodUser = User(name: "Setup User", mail: "setup@setup", password: "setup");
  final badLogin = Login(mail: "wrong@wrong", password: "wrong");

  void initVars(Harness harness, ContentTypeWithName contentType, ContentTypeWithName accept) {
    this.harness = harness;
    this.contentType = contentType;
    this.accept = accept;
  }

  get name {
    return "${contentType.name} ${accept.name}";
  }

  void run();
}