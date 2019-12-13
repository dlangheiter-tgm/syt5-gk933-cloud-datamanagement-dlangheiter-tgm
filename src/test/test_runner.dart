import 'harness/harness.dart';

export 'harness/harness.dart';

abstract class TestRunner {
  TestRunner({this.harness, this.name, this.contentType});

  Harness harness;
  String name;
  ContentType contentType;

  void initVars(Harness harness, String name, ContentType contentType) {
    this.harness = harness;
    this.name = name;
    this.contentType = contentType;
  }

  void run();
}