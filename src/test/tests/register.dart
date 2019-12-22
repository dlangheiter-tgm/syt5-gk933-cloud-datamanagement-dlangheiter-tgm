import 'package:src/model/user.dart';

import '../test_runner.dart';

class RegisterTest extends TestRunner {
  @override
  void run() {
    final Map<String, dynamic> defaultHeaders = {
      HttpHeaders.contentTypeHeader: contentType.toString(),
    };

    test("POST /register $name already exists 301", () async {
      final resp = await harness.agent
          .post("/register", body: goodUser.asMap(), headers: defaultHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/alreadyExists.html'}));
    });

    User u =
        User(mail: 'test@$name', password: 't', name: 'test account $name');

    test("POST /register $name not exitst 301", () async {
      final resp = await harness.agent.post("/register",
          body: u.asMap(),
          headers: defaultHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({'content-type': ContentType.html}));
      expect(resp, hasBody(contains("registered")));
      expect(resp, hasBody(contains(u.name)));
    });

    test("POST /register $name fresh register already exitst 301", () async {
      final resp = await harness.agent.post("/register",
          body: u.asMap(),
          headers: defaultHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/alreadyExists.html'}));
    });

    test("POST /login $name, good credentials returns 200 HTML", () async {
      final resp = await harness.agent
          .post("/login", body: u.asMap(), headers: defaultHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({'content-type': ContentType.html}));
      expect(resp, hasBody(contains("Logged In")));
      expect(resp, hasBody(contains(u.name)));
    });
  }
}
