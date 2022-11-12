import 'dart:convert';

import 'package:http/http.dart';

class NotionException implements Exception {
  Response response;
  NotionException(this.response);
  @override
  String toString() {
    final encoder = JsonEncoder.withIndent('\t==> ');
    final body = encoder.convert(jsonDecode(response.body));
    return '''
    ==> Response code: ${response.statusCode}
    ==> ${response.reasonPhrase}
    ==> $body
    ''';
  }
}
