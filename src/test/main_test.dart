import 'harness/harness.dart';
import 'test_runner.dart';
import 'tests/login.dart';
import 'tests/register.dart';

Future main() async {
  final harness = Harness()..install();

  final contentTypes = [
    ['json', ContentType.json],
    ['urlencoded', ContentType('application', 'x-www-form-urlencoded')],
  ];

  for(var ct in contentTypes) {

    final String name = ct[0] as String;
    final ContentType c = ct[1] as ContentType;

    LoginTest()..initVars(harness, name, c)..run();
    RegisterTest()..initVars(harness, name, c)..run();
  }



}
