import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:src/config/application_config.dart';
import 'package:src/controllers/login_controller.dart';

import 'controllers/register_controller.dart';
import 'model/user.dart';
import 'services/user_store.dart';
import 'src.dart';

import 'utility/html_template.dart';

class SrcChannel extends ApplicationChannel {
  HTMLRenderer htmlRenderer;
  ApplicationConfiguration conf;

  UserStore userStore;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    conf = ApplicationConfiguration(options.configurationFilePath);

    htmlRenderer = HTMLRenderer(cacheEnabled: conf.server.caching);

    final users = stringMapStoreFactory.store("users");

    final DatabaseFactory dbFactory = createDatabaseFactoryIo();

    bool prefillData = options.context['mode'] == 'development' ||
        options.context['mode'] == 'test';

    DatabaseMode dbMode = DatabaseMode.defaultMode;
    if (prefillData) {
      dbMode = DatabaseMode.empty;
    }

    final db = await dbFactory.openDatabase(conf.database.path,
        version: 1,
        mode: dbMode, onVersionChanged: (db, oldVersion, newVersion) {
      prefillData = true;
    });

    userStore = UserStore(db, users);
    if (prefillData) {
      await userStore.addUser(
          User(name: "Setup User", mail: "setup@setup", password: "setup"));
    }
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/login").link(() =>
        LoginController(htmlRenderer: htmlRenderer, userStore: userStore));

    router.route("/register").link(() =>
        RegisterController(htmlRenderer: htmlRenderer, userStore: userStore));

    final policy = conf.server.caching
        ? const CachePolicy(expirationFromNow: Duration(hours: 12))
        : null;
    router.route("/*").link(
        () => FileController("public/")..addCachePolicy(policy, (_) => true));

    return router;
  }
}
