import 'package:src/model/user.dart';
import 'package:src/services/user_store.dart';
import 'package:src/src.dart';
import 'package:meta/meta.dart';
import 'package:src/utility/html_template.dart';

class RegisterController extends ResourceController {
  RegisterController(
      {@required this.htmlRenderer, @required this.userStore});

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
    if(!user.isValid()) {
      return Response.badRequest();
    }

    final ct = ContentType.parse(request.raw.headers[HttpHeaders.contentTypeHeader][0]);
    final isJson = ct.mimeType == ContentType.json.mimeType;

    final result = await userStore.hasUser(user.mail);

    if (result == true) {
      return isJson ? errorJsonResp("User already exists") : redirect("/alreadyExists.html");
    }

    await userStore.addUser(user);

    return isJson ? Response.ok({
      "error": false,
      "name": user.name,
      "mail": user.mail,
    }) : await htmlRenderer.respondHTML("web/registered.html", {'name': user.name});
  }
}
