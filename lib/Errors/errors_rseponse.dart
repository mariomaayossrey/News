import 'dart:convert';



class ErrorResponse {
  String? code;
  String? key;
  // String? message;
  String? error;
  String? description;
  String? txID;
  String? callingURL;
  ErrorResponse(
      {this.code, this.key, this.error, this.description, this.txID, this.callingURL});


  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      code: json['errorCode'],
      key: json['key'],
      error: json['errorMessage'],
      // error: json[ERROR],
      txID: json['TxID'],
    );
  }
}

ErrorResponse errorResponseFromJson(String str) {
  final jsonData = json.decode(str);
  return ErrorResponse.fromJson(jsonData);
}


class NotAcceptableErrorResponse {
  String? errorMessage;
  String? errorCode;

  NotAcceptableErrorResponse({this.errorMessage, this.errorCode});

  factory NotAcceptableErrorResponse.fromJson(Map<String, dynamic> json) {
    return NotAcceptableErrorResponse(
      errorMessage: json['errorMessage'],
      errorCode: json['errorCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'errorMessage': errorMessage,
      'errorCode': errorCode,
    };
  }

  @override
  String toString() => errorMessage ?? 'Unknown error';
}

// Function to convert JSON string to ErrorResponse object
NotAcceptableErrorResponse notAcceptableErrorResponseFromJson(Map<String, dynamic> jsonData) {
  return NotAcceptableErrorResponse.fromJson(jsonData);
}