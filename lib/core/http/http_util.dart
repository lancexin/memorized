import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:memorized/core/exception.dart';

import '../log.dart';
import '../result.dart';

class HttpUtil {
  static const _connectTimeout = Duration(seconds: 20);
  static const _receiveTimeout = Duration(seconds: 20);
  static const _sendTimeout = Duration(seconds: 20);
  static bool showLog = true;

  late Dio _dio;
  late Dio _downloadDio;
  late String _urlBase;

  HttpUtil(String urlBase) {
    _urlBase = urlBase;
    final BaseOptions options = BaseOptions(
      connectTimeout: _connectTimeout,
      receiveTimeout: _receiveTimeout,
      sendTimeout: _sendTimeout,
      responseType: ResponseType.plain,
      baseUrl: _urlBase,
      contentType: Headers.textPlainContentType, // 适用于post form表单提交
    );
    final BaseOptions downloadOptions = BaseOptions(
        connectTimeout: _connectTimeout,
        sendTimeout: _sendTimeout,
        headers: {HttpHeaders.acceptEncodingHeader: '*'});

    _dio = Dio(options);
    _downloadDio = Dio(downloadOptions);

    //添加代理
    // _dio.httpClientAdapter = IOHttpClientAdapter(
    //   createHttpClient: () {
    //     final client = HttpClient();
    //     client.findProxy = (uri) {
    //       return 'PROXY 127.0.0.1:33210';
    //     };
    //     return client;
    //   },
    // );

    // _downloadDio.httpClientAdapter = IOHttpClientAdapter(
    //   createHttpClient: () {
    //     final client = HttpClient();
    //     client.findProxy = (uri) {
    //       return 'PROXY 127.0.0.1:33210';
    //     };

    //     return client;
    //   },
    // );

    /// 添加拦截器
    _dio.interceptors.add(LoggingInterceptor());
    _downloadDio.interceptors.add(LoggingInterceptor());
  }

  Future<Result<RequestException, String?>> get(final String path,
      {final Map<String, dynamic>? data, CancelToken? cancelToken}) async {
    try {
      var response =
          await _dio.get<String>(path, data: data, cancelToken: cancelToken);
      if (response.statusCode == 200) {
        return Success(response.data);
      } else {
        return Failure(RequestException.getErrorResult(response.statusCode));
      }
    } catch (error, stackTrace) {
      Log.d("error:$error");
      return Failure(RequestException.handleException(error, stackTrace));
    }
  }

  Future<DownloadResult> download(
      {required String urlPath,
      required String savePath,
      ProgressCallback? progressCallback,
      CancelToken? cancelToken}) async {
    var startTime = DateTime.now();
    Response? response = await _downloadDio.download(
      urlPath,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: progressCallback,
    );
    var endTime = DateTime.now();
    var duration = endTime.difference(startTime);
    String? contentLength = response.headers.value(Headers.contentLengthHeader);
    final int size = contentLength == null ? -1 : int.parse(contentLength);

    return DownloadResult(
        size: size,
        urlPath: urlPath,
        savePath: savePath,
        duration: duration,
        statusCode: response.statusCode ?? -1);
  }
}

class DownloadResult {
  int size;
  String urlPath;
  String savePath;
  Duration duration;
  int statusCode;

  bool get success {
    return statusCode == RequestException.ERROR_CODE_SUCCESS;
  }

  DownloadResult({
    required this.size,
    required this.urlPath,
    required this.savePath,
    required this.duration,
    required this.statusCode,
  });
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //options.headers["t"] = DateTime.now().millisecondsSinceEpoch;
    if (HttpUtil.showLog) {
      Log.d('----------Start---------- $hashCode');
      if (options.queryParameters.isEmpty) {
        Log.d('RequestUrl: ${options.baseUrl}${options.path}');
      } else {
        Log.d(
            'RequestUrl: ${options.baseUrl}${options.path}?${Transformer.urlEncodeMap(options.queryParameters)}');
      }
      Log.d('RequestMethod: ${options.method}');
      Log.d('RequestHeaders:${options.headers}');
      Log.d('RequestContentType: ${options.contentType}');
      Log.d('RequestData: ${options.data.toString()}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.requestOptions.data == null) {
      super.onResponse(response, handler);
      return;
    }
    var endTime = DateTime.now();
    var startTime = DateTime.fromMillisecondsSinceEpoch(
        response.requestOptions.headers['t'] as int);

    final int duration = endTime.difference(startTime).inMilliseconds;
    _showLogDuration(duration: duration, response: response);
    super.onResponse(response, handler);
  }

  void _showLogDuration(
      {required int duration, required Response response}) async {
    if (HttpUtil.showLog) {
      if (response.statusCode == Response) {
        Log.d('ResponseCode: ${response.statusCode}');
      } else {
        Log.e('ResponseCode: ${response.statusCode}');
      }
      // 输出结果
      Log.json(response.data.toString());
      Log.d('----------End: $duration 毫秒---------- $hashCode');
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _handleResponseError(err: err, handler: handler);
    super.onError(err, handler);
  }

  void _handleResponseError(
      {required DioException err,
      required ErrorInterceptorHandler handler}) async {
    Log.d('----------Error-----------');
    if (err.response != null && err.response!.data != null) {
      Log.json(err.response!.data.toString());
    }
  }
}
