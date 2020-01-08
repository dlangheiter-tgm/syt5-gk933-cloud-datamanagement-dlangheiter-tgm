import 'package:src/src.dart';

class ServerConfig extends Configuration {

  /// Port to run the application
  @optionalConfiguration
  int port = 8888;

  /// How many processors (cores) should be used
  ///
  /// 0 uses all cores. Negative numbers use all cores minus the number (-1 => 7 cores on a 8 core machine)
  @optionalConfiguration
  int processors = 0;

  /// If html files should be cached. Preferable on deployment. Defaults to true
  @optionalConfiguration
  bool caching = true;

  @override
  String toString() {
    return 'ServerConfig{port: $port, processors: $processors, caching: $caching}';
  }
}