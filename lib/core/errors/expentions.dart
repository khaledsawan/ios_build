import 'package:dio/dio.dart';
import 'package:glowguide/core/errors/error_model.dart';

class ServerException implements Exception {
  final ErrorModel errorModel;
  ServerException(this.errorModel);
}

class CacheExeption implements Exception {
  final String errorMessage;
  CacheExeption({required this.errorMessage});
}

class BadCertificateException extends ServerException {
  BadCertificateException(super.errorModel);
}

class ConnectionTimeoutException extends ServerException {
  ConnectionTimeoutException(super.errorModel);
}

class BadResponseException extends ServerException {
  BadResponseException(super.errorModel);
}

class ReceiveTimeoutException extends ServerException {
  ReceiveTimeoutException(super.errorModel);
}

class ConnectionErrorException extends ServerException {
  ConnectionErrorException(super.errorModel);
}

class SendTimeoutException extends ServerException {
  SendTimeoutException(super.errorModel);
}

class UnauthorizedException extends ServerException {
  UnauthorizedException(super.errorModel);
}

class ForbiddenException extends ServerException {
  ForbiddenException(super.errorModel);
}

class NotFoundException extends ServerException {
  NotFoundException(super.errorModel);
}

class CofficientException extends ServerException {
  CofficientException(super.errorModel);
}

class CancelException extends ServerException {
  CancelException(super.errorModel);
}

class UnknownException extends ServerException {
  UnknownException(super.errorModel);
}

void handleDioException(DioException e) {
  ErrorModel errorModelFromResponse() {
    final data = e.response?.data;
    try {
      if (data == null) {
        return ErrorModel(errorMessage: e.message ?? e.toString());
      }
      if (data is String) return ErrorModel(errorMessage: data);
      return ErrorModel.fromJson(data);
    } catch (_) {
      return ErrorModel(errorMessage: e.message ?? e.toString());
    }
  }

  switch (e.type) {
    case DioExceptionType.connectionError:
      throw ConnectionErrorException(errorModelFromResponse());
    case DioExceptionType.badCertificate:
      throw BadCertificateException(errorModelFromResponse());
    case DioExceptionType.connectionTimeout:
      throw ConnectionTimeoutException(errorModelFromResponse());

    case DioExceptionType.receiveTimeout:
      throw ReceiveTimeoutException(errorModelFromResponse());

    case DioExceptionType.sendTimeout:
      throw SendTimeoutException(errorModelFromResponse());

    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400:
          throw BadResponseException(errorModelFromResponse());

        case 401:
          throw UnauthorizedException(errorModelFromResponse());

        case 403:
          throw ForbiddenException(errorModelFromResponse());

        case 404:
          throw NotFoundException(errorModelFromResponse());

        case 409:
          throw CofficientException(errorModelFromResponse());

        case 504:
          throw BadResponseException(
            ErrorModel(
                errorMessage:
                    e.response?.data?.toString() ?? e.message ?? e.toString()),
          );
      }

    case DioExceptionType.cancel:
      throw CancelException(ErrorModel(errorMessage: e.toString()));

    case DioExceptionType.unknown:
      throw UnknownException(ErrorModel(errorMessage: e.toString()));
  }
}
