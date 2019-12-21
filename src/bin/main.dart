import 'dart:math';

import 'package:args/args.dart';
import 'package:src/config/application_config.dart';
import 'package:src/src.dart';

final confs = {
  "deployment": "confgig/config.yaml",
  "development": "config/config.dev.yaml",
  "test": "config/config.src.yaml",
};

Future main(List<String> args) async {
  final parser = ArgParser();
  parser.addOption('mode',
      abbr: 'm',
      defaultsTo: 'deployment',
      allowed: ['deployment', 'development', 'test']);
  final results = parser.parse(args);

  final app = Application<SrcChannel>();

  app.options.configurationFilePath = confs[results['mode']];
  app.options.context['mode'] = results['mode'];

  final conf = ApplicationConfiguration(app.options.configurationFilePath);

  var numProcessors = Platform.numberOfProcessors;
  if(conf.server.processors > 0) {
    numProcessors = min(numProcessors, conf.server.processors);
  } else if(conf.server.processors < 0) {
    numProcessors = max(1, numProcessors + conf.server.processors);
  }
  app.options.port = conf.server.port;

  await app.start(numberOfInstances: max(1, numProcessors));

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}
