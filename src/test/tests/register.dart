import 'package:src/model/user.dart';

import '../test_runner.dart';

class RegisterTest extends TestRunner {
  @override
  void run() {
    final Map<String, dynamic> defaultHeaders = {
      HttpHeaders.contentTypeHeader: contentType.toString(),
    };

    final Map<String, dynamic> acceptHeaders = {
      ...defaultHeaders,
      HttpHeaders.acceptHeader: accept.contentType.toString(),
    };

    test("POST /register $name already exists 301", () async {
      final resp = await harness.agent
          .post("/register", body: goodUser.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/alreadyExists.html'}));
    });

    User u =
        User(mail: 'test@$name', password: 't', name: 'test account $name');

    test("POST /register $name not exitst 301", () async {
      final resp = await harness.agent
          .post("/register", body: u.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({'content-type': accept.contentType.toString()}));

      // Solution to strange due to strange bug that the hasBody(contains(...)) checker does not work on json responses
      expect(resp, hasBody(anything));
      final body = resp.body.toString();
      expect(body, contains(u.name));
      expect(body, contains(u.mail));
    });

    test("POST /register $name fresh register already exitst 301", () async {
      final resp = await harness.agent
          .post("/register", body: u.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/alreadyExists.html'}));
    });

    test("POST /login $name, good credentials returns 200 HTML", () async {
      final resp = await harness.agent
          .post("/login", body: u.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, 200);
    });
  }
}
