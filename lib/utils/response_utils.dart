abstract class ResponseUtils {
  static Map<String, dynamic> error(String e) {
    return {
      "statusCode": 400,
      "data": {"status": false, "message": e}
    };
  }

  static Map<String, dynamic> ok(String e) {
    return {
      "statusCode": 200,
      "data": {"status": true, "message": e}
    };
  }
}
