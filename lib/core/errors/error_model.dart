class ErrorModel {
  final String errorMessage;

  const ErrorModel({required this.errorMessage});

  factory ErrorModel.fromJson(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey("detail")) {
      final detail = jsonData["detail"];

      if (detail is List && detail.isNotEmpty) {
        return ErrorModel(errorMessage: detail.join(', '));
      } else if (detail is String) {
        return ErrorModel(errorMessage: detail);
      }
    }

    final combinedErrors = jsonData.entries
        .map((entry) {
          final key = entry.key;
          final value = entry.value;

          if (value is List && value.isNotEmpty) {
            return "$key: ${value.join(', ')}";
          } else {
            return "$key: $value";
          }
        })
        .where((msg) => msg.isNotEmpty)
        .join("\n");

    return ErrorModel(
      errorMessage: combinedErrors.isNotEmpty
          ? combinedErrors
          : "An unexpected error occurred. Please try again.",
    );
  }

  @override
  String toString() => errorMessage;
}
