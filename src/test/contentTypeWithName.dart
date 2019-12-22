import 'harness/harness.dart';

class ContentTypeWithName {
  ContentTypeWithName(this.name, this.contentType);

  final String name;
  final ContentType contentType;

  @override
  String toString() {
    return 'ContentTypeWithName{name: $name, contentType: $contentType}';
  }
}