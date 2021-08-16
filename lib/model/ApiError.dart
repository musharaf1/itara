class ApiError {
  List? errorMessages;
  String? statusCode;

  ApiError({this.errorMessages, this.statusCode});

  factory ApiError.fromJson(Map json) {
    return ApiError(
      errorMessages: json["errorMessages"],
      statusCode: json["statusCode"],
    );
  }
}
