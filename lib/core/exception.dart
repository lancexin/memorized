// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'Result.dart';

class RequestException implements Exception {
  static const int ERROR_CODE_SUCCESS = 200;
  static const int ERROR_CODE_SUCCESS_NOT_CONNECT = 204;
  static const int ERROR_CODE_NO_NET = 1001;
  static const int ERROR_CODE_DNS = 1002;
  static const int ERROR_CODE_SOCKET = 1003;
  static const int ERROR_CODE_CONNECT_TOMEOUT = 1004;

  static const int ERROR_CODE_IO = 1005;
  static const int ERROR_CODE_UNKONW = 1006;

  static const int ERROR_CODE_JSON_ERROR = 1007;
  static const int ERROR_CODE_HTTP_ERROR = 1008;

  static const int ERROR_CODE_SEND_TOMEOUT = 1009;
  static const int ERROR_CODE_RECEIVE_TOMEOUT = 1010;
  static const int ERROR_CODE_CANCEL = 1011;
  static const int ERROR_CODE_RESPONSE = 1012;
  static const int ERROR_CODE_VERIFY = 1013;

  static const int ERROR_CODE_404 = 404;
  static const int ERROR_CODE_500 = 500;
  static const int ERROR_CODE_REQUEAT_ERROR = 3001;
  static const int ERROR_CODE_NOT_BIND = 3002;

  static const int ERROR_DOWNLOAD_ERROR = 2001;
  static const int ERROR_LOAD_ERROR = 2002;

  static const int ERROR_TOKEN_TIMEOUT = 30001;

  static const int ERROR_TOKEN_ERROR = 30008;
  static const int ERROR_SERVER_ERROR = 20000;

  static const int ERROR_CAMERA_ERROR = 40001;
  static const int ERROR_MICROPHONE_ERROR = 40002;
  static const int ERROR_PHONE_ERROR = 40003;

  static const RequestException noNetException =
      RequestException(ERROR_CODE_NO_NET, '网络未连接，请检查您的网络！');
  static const RequestException dnsException =
      RequestException(ERROR_CODE_NO_NET, '网络未连接，请检查您的网络！');
  static const RequestException socketException =
      RequestException(ERROR_CODE_SOCKET, '网络服务连接错误，请稍后重试！');
  static const RequestException connectTimeoutException =
      RequestException(ERROR_CODE_CONNECT_TOMEOUT, '网络连接超时，请稍后重试！');
  static const RequestException sendTimeoutException =
      RequestException(ERROR_CODE_CONNECT_TOMEOUT, '数据发送超时，请稍后重试！');
  static const RequestException receiveTimeoutException =
      RequestException(ERROR_CODE_RECEIVE_TOMEOUT, '数据接收超时，请稍后重试！');
  static const RequestException cancelException =
      RequestException(ERROR_CODE_RECEIVE_TOMEOUT, '请求已取消！');
  static const RequestException ioException =
      RequestException(ERROR_CODE_IO, '网络传输错误，请稍后重试！');
  static const RequestException notFoundException =
      RequestException(ERROR_CODE_404, '网络传输错误，请稍后重试！');
  static const RequestException serverException =
      RequestException(ERROR_CODE_500, '网络服务不稳定，请稍后重试！');
  static const RequestException formatException =
      RequestException(ERROR_CODE_JSON_ERROR, '网络报文传输错误，请稍后重试！');
  static const RequestException httpException =
      RequestException(ERROR_CODE_HTTP_ERROR, '服务器异常，请稍后重试！');
  static const RequestException unkonwException =
      RequestException(ERROR_CODE_UNKONW, '网络服务错误，请联系管理员或稍后重试！');
  static const RequestException tokenException =
      RequestException(ERROR_TOKEN_ERROR, '用户信息过期，请重新登录！');

  static const RequestException cameraException =
      RequestException(ERROR_CAMERA_ERROR, '调用摄像头失败,请确认是否有权限！');

  static const RequestException cameraErrorException =
      RequestException(ERROR_CAMERA_ERROR, '调用摄像头失败,请重新启动！');

  static const RequestException microphoneException =
      RequestException(ERROR_MICROPHONE_ERROR, '调用麦克风失败,请确认是否有权限！');

  static const RequestException phoneException =
      RequestException(ERROR_PHONE_ERROR, '获取通话状态失败,请确认是否有权限！');

  final int code;
  final String message;

  const RequestException(this.code, this.message);

  factory RequestException.code(int code) {
    if (_errorMap.containsKey(code)) {
      return _errorMap[code]!;
    }
    return _errorMap[ERROR_CODE_UNKONW]!;
  }

  static RequestException handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return connectTimeoutException;
    } else if (error.type == DioExceptionType.sendTimeout) {
      return sendTimeoutException;
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return receiveTimeoutException;
    } else if (error.type == DioExceptionType.cancel) {
      return cancelException;
    } else if (error.type == DioExceptionType.unknown) {
      if (error.error is SocketException) {
        return socketException;
      } else if (error.error is IOException) {
        return ioException;
      }
      return RequestException.create(ERROR_CODE_UNKONW, "网络服务不稳定，请稍后重试！(UN)");
    } else if (error.type == DioExceptionType.badResponse) {
      if (error.response?.statusCode == 404) {
        return notFoundException;
      }
      return RequestException.create(ERROR_CODE_RESPONSE,
          "网络服务不稳定，请稍后重试！(${(error.response?.statusCode ?? 0) + 1000})");
    }
    return unkonwException;
  }

  factory RequestException.codeOrCreate(int code, String message) {
    if (_errorMap.containsKey(code)) {
      return _errorMap[code]!;
    }
    return RequestException(code, message);
  }

  factory RequestException.create(int code, String message) {
    return RequestException(code, message);
  }

  @override
  String toString() {
    return message;
  }

  static const Map<int, RequestException> _errorMap = <int, RequestException>{
    ERROR_CODE_NO_NET: noNetException,
    ERROR_CODE_DNS: dnsException,
    ERROR_CODE_SOCKET: socketException,
    ERROR_CODE_CONNECT_TOMEOUT: connectTimeoutException,
    ERROR_CODE_SEND_TOMEOUT: sendTimeoutException,
    ERROR_CODE_RECEIVE_TOMEOUT: receiveTimeoutException,
    ERROR_CODE_CANCEL: cancelException,
    ERROR_CODE_IO: ioException,
    ERROR_CODE_404: notFoundException,
    ERROR_CODE_500: serverException,
    ERROR_CODE_JSON_ERROR: formatException,
    ERROR_CODE_HTTP_ERROR: httpException,
    ERROR_CODE_UNKONW: unkonwException,
    ERROR_TOKEN_ERROR: tokenException
  };

  static String? getErrorMessage(int errorCode) {
    var errorMessage = _errorMap[errorCode]?.message;
    if (errorMessage == null) {
      errorCode = ERROR_CODE_UNKONW;
      errorMessage = _errorMap[errorCode]?.message;
    }
    return errorMessage;
  }

  static RequestException getErrorResult(int? errorCode) {
    var errorMsg =
        _errorMap[errorCode]?.message ?? _errorMap[ERROR_CODE_UNKONW]!.message;

    return RequestException(errorCode ?? ERROR_CODE_UNKONW, errorMsg);
  }

  static RequestException handleException(Object error, StackTrace stackTrace) {
    printException(error, stackTrace);
    if (error is RequestException) {
      return error;
    } else if (error is DioException) {
      return handleDioError(error);
    } else if (error is SocketException) {
      return socketException;
    } else if (error is HttpException) {
      return httpException;
    } else if (error is FormatException) {
      return formatException;
    } else {
      return RequestException.create(ERROR_CODE_UNKONW, "请求失败,请稍后再试");
    }
  }

  static printException(Object error, StackTrace stackTrace) {
    FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(exception: error, stack: stackTrace),
        forceReport: true);
  }
}

extension DioErrorTypeExtension on DioExceptionType {
  int get errorCode => [
        RequestException.ERROR_CODE_CONNECT_TOMEOUT,
        RequestException.ERROR_CODE_SEND_TOMEOUT,
        RequestException.ERROR_CODE_RECEIVE_TOMEOUT,
        0,
        RequestException.ERROR_CODE_CANCEL,
        0,
      ][index];
}
