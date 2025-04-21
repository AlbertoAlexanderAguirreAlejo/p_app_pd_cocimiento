class ApiResponseOra<T> {
  final int status;
  final T data;

  ApiResponseOra({
    required this.status,
    required this.data,
  });

  factory ApiResponseOra.fromJson(
      Map<String, dynamic> json, T Function(dynamic json) fromJsonT) {
    return ApiResponseOra<T>(
      status: json['status'] as int,
      data: fromJsonT(json['data']),
    );
  }
}
