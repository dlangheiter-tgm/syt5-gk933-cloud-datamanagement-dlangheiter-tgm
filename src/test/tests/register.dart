import '../test_runner.dart';

class RegisterTest extends TestRunner {

  @override
  void run() {
    test("POST /register $name already exists 301", () async {
      final resp = await harness.agent
          .post("/register", body: {'mail': 't@t', 'password': 't', 'name': 'Tests'});

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/alreadyExists.html'}));
    });

    test("POST /register $name", () async {
      final resp = await harness.agent
          .post("/register", body: {'mail': 'test@$name', 'password': 't', 'name': 'test account $name'});

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/registered.html'}));
    });
  }

}