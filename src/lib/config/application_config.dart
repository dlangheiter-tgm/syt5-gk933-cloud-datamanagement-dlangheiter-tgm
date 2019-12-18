import 'package:src/config/database_config.dart';
import 'package:src/config/server_config.dart';
import 'package:src/src.dart';

class ApplicationConfiguration extends Configuration {
  ApplicationConfiguration(String fileName) : super.fromFile(File(fileName));

  ServerConfig server;

  DatabaseConfig database;

  @override
  String toString() {
    return 'ApplicationConfiguration{server: $server, database: $database}';
  }
}
