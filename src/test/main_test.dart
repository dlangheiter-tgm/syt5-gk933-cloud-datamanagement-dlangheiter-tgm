import 'contentTypeWithName.dart';
import 'harness/harness.dart';
import 'test_runner.dart';
import 'tests/login.dart';
import 'tests/register.dart';

Future main() async {
  final harness = Harness()..install();

  final contentTypes = [
    ContentTypeWithName('json', ContentType.json),
    ContentTypeWithName(
        'urlencoded', ContentType('application', 'x-www-form-urlencoded')),
  ];

  final accepts = [
    ContentTypeWithName('html', ContentType.html),
    ContentTypeWithName('json', ContentType.json),
  ];

  for (var ct in contentTypes) {
    for(var ac in accepts) {
      LoginTest()
        ..initVars(harness, ct, ac)
        ..run();
      RegisterTest()
        ..initVars(harness, ct, ac)
        ..run();
    }
  }
}
