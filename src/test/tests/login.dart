import 'package:src/model/login.dart';

import '../test_runner.dart';

class LoginTest extends TestRunner {

  @override
  void run() {
    final Map<String, dynamic> defaultHeaders = {
      HttpHeaders.contentTypeHeader: contentType.toString(),
    };

    final Map<String, dynamic> acceptHeaders = {
      ...defaultHeaders,
      HttpHeaders.acceptHeader: accept.contentType.toString(),
    };

    final json = accept.contentType == ContentType.json;

    test("GET /login $name returns 200 HTML", () async {
      final resp = await harness.agent.get("/login", headers: defaultHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({'content-type': ContentType.html}));
      expect(resp, hasBody(isNotNull));
    });

    test("POST /login $name no body returns 400", () async {
      final resp = await harness.agent.post("/login", headers: acceptHeaders);

      expect(resp.statusCode, 400);
    });

    test("POST /login $name body, wrong credentials", () async {
      final resp = await harness.agent.post("/login",
          body: badLogin.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, json ? 400 : 301);
      if (json) {
        expect(resp, hasHeaders(
            {HttpHeaders.contentTypeHeader: accept.contentType.toString()}));
        expect(resp, hasBody(containsValue("Wrong credentials")));
      } else {
        expect(resp, hasHeaders({'location': '/wrong.html'}));
      }
    });

    test("POST /login $name, good credentials returns 200", () async {
      final resp = await harness.agent
          .post("/login", body: goodLogin.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, 200);
      expect(resp, hasHeaders({HttpHeaders.contentTypeHeader: accept.contentType}));
      final body = resp.body.toString();
      expect(body, contains(goodUser.name));
    });

    test("POST /login $name, wrong mail returns", () async {
      final Login l = Login.copy(goodLogin)
        ..mail = badLogin.mail;

      final resp = await harness.agent
          .post("/login", body: l.asMap(), headers: acceptHeaders);


      expect(resp.statusCode, json ? 400 : 301);
      if (json) {
        expect(resp, hasHeaders(
            {HttpHeaders.contentTypeHeader: accept.contentType.toString()}));
        expect(resp, hasBody(containsValue("Wrong credentials")));
      } else {
        expect(resp, hasHeaders({'location': '/wrong.html'}));
      }
    });

    test("POST /login $name, wrong password returns 301 /wrong.html", () async {
      final Login l = Login.copy(goodLogin)
        ..password = badLogin.password;

      final resp = await harness.agent
          .post("/login", body: l.asMap(), headers: acceptHeaders);

      expect(resp.statusCode, json ? 400 : 301);
      if (json) {
        expect(resp, hasHeaders(
            {HttpHeaders.contentTypeHeader: accept.contentType.toString()}));
        expect(resp, hasBody(containsValue("Wrong credentials")));
      } else {
        expect(resp, hasHeaders({'location': '/wrong.html'}));
      }
    });
  }
}
