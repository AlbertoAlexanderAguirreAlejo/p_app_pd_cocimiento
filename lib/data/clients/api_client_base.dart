abstract class ApiClientBase {
  final String baseUrl;
  final Map<String, String> defaultQueryParameters;
  final Map<String, String> defaultHeaders;

  ApiClientBase({
    required this.baseUrl,
    Map<String, String>? defaultQueryParameters,
    Map<String, String>? defaultHeaders,
  })  : defaultQueryParameters = defaultQueryParameters ?? {},
        defaultHeaders = defaultHeaders ??
            {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            };

  Uri buildUri(String endpoint, [Map<String, String>? additionalParams]) {
    final mergedParams = {
      ...defaultQueryParameters,
      ...?additionalParams,
    };
    return Uri.parse("$baseUrl$endpoint").replace(queryParameters: mergedParams);
  }
}
