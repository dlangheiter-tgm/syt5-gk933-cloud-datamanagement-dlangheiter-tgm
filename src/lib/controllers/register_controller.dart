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
    final result = await userStore.hasUser(user.mail);

    if (result == true) {
      return redirect("/alreadyExists.html");
    }

    await userStore.addUser(user);

    return await htmlRenderer.respondHTML("web/registered.html", {'name': user.name});
  }
}
