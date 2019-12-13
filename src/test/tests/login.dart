import 'package:src/model/login.dart';

import '../test_runner.dart';

class LoginTest extends TestRunner {

  @override
  void run() {
    final Map<String, dynamic> defaultHeaders = {
      HttpHeaders.contentTypeHeader: contentType.toString(),
    };

    test("GET /login $name returns 200 HTML", () async {
      final resp = await harness.agent.get("/login", headers: defaultHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({'content-type': ContentType.html}));
      expect(resp, hasBody(isNotNull));
    });

    test("POST /login $name no body returns 400", () async {
      final resp = await harness.agent.post("/login", headers: defaultHeaders);

      expect(resp.statusCode, 400);
    });

    test("POST /login $name body, wrong credentials returns 301", () async {
      final resp = await harness.agent.post("/login",
          body: {'mail': 'd@d.d', 'password': 'd'}, headers: defaultHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/wrong.html'}));
    });

    test("POST /login $name, good credentials returns 200 HTML", () async {
      final resp = await harness.agent
          .post("/login", body: goodLogin.asMap(), headers: defaultHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({'content-type': ContentType.html}));
      expect(resp, hasBody(contains("Logged In")));
      expect(resp, hasBody(contains(goodUser.name)));
    });

    test("POST /login $name, wrong mail returns 301 /wrong.html", () async {
      final Login l = Login.copy(goodLogin)..mail = badLogin.mail;

      final resp = await harness.agent
          .post("/login", body: l.asMap(), headers: defaultHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/wrong.html'}));
    });

    test("POST /login $name, wrong password returns 301 /wrong.html", () async {
      final Login l = Login.copy(goodLogin)..password = badLogin.password;

      final resp = await harness.agent
          .post("/login", body: l.asMap(), headers: defaultHeaders);

      expect(resp.statusCode, 301);
      expect(resp, hasHeaders({'location': '/wrong.html'}));
    });
  }
}
