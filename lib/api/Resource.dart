class Resource {
  final String? url;
  dynamic data;
  dynamic queryParameters;
  Function(Map response)? parse;

  Resource({this.url, this.parse, this.queryParameters, this.data});
}
