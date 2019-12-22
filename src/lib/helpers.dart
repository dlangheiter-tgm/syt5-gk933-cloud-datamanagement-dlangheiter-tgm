import 'package:src/utility/html_template.dart';

import 'src.dart';

String ifListFirst(val) {
  if (val is List) {
    return val.first as String;
  }
  return val as String;
}

Response redirect(String to) {
  return Response(
      HttpStatus.movedPermanently,
      {
        HttpHeaders.locationHeader: to,
        HttpHeaders.cacheControlHeader: "no-store",
        HttpHeaders.pragmaHeader: "no-cache",
      },
      null);
}

Response jsonResp(Map<String, dynamic> body, [int error]) {
  return Response(error ?? HttpStatus.ok, {
    HttpHeaders.contentTypeHeader: ContentType.json.toString()
  }, {
    ...body,
    "error": error != null,
  });
}

Response errorJsonResp(String error) {
  return jsonResp({"message": error}, HttpStatus.badRequest);
}

bool shouldReturnJson(Request request) {
  return request != null &&
      (!request.acceptsContentType(ContentType.html)) &&
      request.acceptsContentType(ContentType.json);
}

Response customError(String _redirect, String message,
    {Request request, int code = HttpStatus.badRequest}) {

  return shouldReturnJson(request)
      ? errorJsonResp(message)
      : redirect(_redirect);
}

Future<Response> customRender(
    String htmlPath, Map<String, String> obj, HTMLRenderer htmlRenderer,
    {Request request}) async {
  final isJson = shouldReturnJson(request);

  return isJson ? jsonResp(obj) : await htmlRenderer.respondHTML(htmlPath, obj);
}
