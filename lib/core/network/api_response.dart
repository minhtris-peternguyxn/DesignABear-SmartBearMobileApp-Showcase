class ApiError {
  final String code;
  final String description;

  ApiError({
    required this.code,
    required this.description,
  });

  factory ApiError.fromJson(dynamic json) {
    if (json is String) {
      return ApiError(code: 'SERVER_ERROR', description: json);
    }
    if (json is Map<String, dynamic>) {
      return ApiError(
        code: json['code']?.toString() ?? 'SERVER_ERROR',
        description: json['description']?.toString() ?? json['message']?.toString() ?? json['error']?.toString() ?? 'An unknown error occurred.',
      );
    }
    return ApiError(code: 'UNKNOWN_ERROR', description: json?.toString() ?? 'An unknown error occurred.');
  }
}

class ApiResponse<T> {
  final T? value;
  final bool isSuccess;
  final bool isFailure;
  final ApiError? error;

  ApiResponse._({
    this.value,
    required this.isSuccess,
    required this.isFailure,
    this.error,
  });

  factory ApiResponse.success(T value) {
    return ApiResponse._(
      value: value,
      isSuccess: true,
      isFailure: false,
    );
  }

  factory ApiResponse.failure(ApiError error) {
    return ApiResponse._(
      isSuccess: false,
      isFailure: true,
      error: error,
    );
  }
}
