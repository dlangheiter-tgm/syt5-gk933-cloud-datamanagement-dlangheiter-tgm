import 'harness/harness.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /login returns 200 HTML", () async {
    final resp = await harness.agent.get("/login");

    expect(resp.statusCode, 200);
    expect(resp, hasHeaders({'content-type': ContentType.html}));
    expect(resp, hasBody(isNotNull));
  });

  test("POST /login no body returns 400", () async {
    final resp = await harness.agent.post("/login");

    expect(resp.statusCode, 400);
  });

  test("POST /login json body, wrong credentials returns 301", () async {
    final resp = await harness.agent
        .post("/login", body: {'mail': 'd@d.d', 'password': 'd'});

    expect(resp.statusCode, 301);
    expect(resp, hasHeaders({'location': '/wrong.html'}));
  });

  test("POST /login json body, right credentials returns 200 HTML containts 'Logged In'", () async {
    //when(harness.channel.userStore.authenticate("t@t", "t")).thenAnswer((_) => Future.value(User(name: "testing_user")));

    final resp = await harness.agent
        .post("/login", body: {'mail': 't@t', 'password': 't'});

    //verify(harness.channel.userStore.authenticate("t@t", "t"));

    expect(resp.statusCode, 200);
    expect(resp, hasHeaders({'content-type': ContentType.html}));
    expect(resp, hasBody(contains("Logged In")));
  });

  test("POST /register mock", () async {
    final resp = await harness.agent
        .post("/register", body: {'mail': 't@t', 'password': 't', 'name': 'Tests'});

    expect(resp.statusCode, 301);
    expect(resp, hasHeaders({'location': '/alreadyExists.html'}));
  });
}
