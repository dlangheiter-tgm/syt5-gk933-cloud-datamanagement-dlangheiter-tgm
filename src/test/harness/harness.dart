import 'package:src/src.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:src/src.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';


class Harness extends TestHarness<SrcChannel> {
  @override
  Future beforeStart() async {
    application.options.context['mode'] = 'test';
  }
}
