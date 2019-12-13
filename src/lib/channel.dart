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
    DatabaseMode dbMode =  DatabaseMode.defaultMode;
    if(options.context['mode'] == 'development' || options.context['mode'] == 'test') {
      dbMode = DatabaseMode.empty;
    }

    final db = await dbFactory.openDatabase(conf.database.path,
        version: 1,
        mode: dbMode, onVersionChanged: (db, oldVersion, newVersion) async {
      // If the db does not exist, create some data, or when in testing/development mode
      if (oldVersion == 0 ||
          options.context['mode'] == 'test' ||
          options.context['mode'] == 'development') {
        print("No database found. Prefiling test data");
        await users.add(
            db, User(name: "Test account", mail: "t@t", password: "t").asMap());
      }
    });

    userStore = UserStore(db, users);
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
