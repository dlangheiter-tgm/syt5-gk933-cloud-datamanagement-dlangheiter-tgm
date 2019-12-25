import 'package:src/model/user.dart';
import 'package:src/services/user_store.dart';
import 'package:src/src.dart';
import 'package:meta/meta.dart';
import 'package:src/utility/html_template.dart';

class RegisterController extends ResourceController {
  RegisterController({@required this.htmlRenderer, @required this.userStore});

  final HTMLRenderer htmlRenderer;
  final UserStore userStore;

  @override
  List<ContentType> acceptedContentTypes = [
    ContentType("application", "x-www-form-urlencoded"),
    ContentType("application", "json")
  ];

  @Operation.get()
  Future<Response> displayLoginForm() async {
    return await htmlRenderer.respondHTML("web/register.html");
  }

  @Operation.post()
  Future<Response> login(@Bind.body() User user) async {
    if (!user.isValid()) {
      return Response.badRequest();
    }

    final result = await userStore.hasUser(user.mail);

    if (result == true) {
      return customError("/alreadyExists.html", "User already exists",
          request: request);
    }

    await userStore.addUser(user);

    final obj = {"name": user.name, "mail": user.mail};

    return await customRender("web/registered.html", obj, htmlRenderer,
        request: request);
  }
}
