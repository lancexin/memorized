import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//数据存储，本地文件存储相关
class StroageService {
  static const _cacheDirName = "cache";

  late Directory _applicationDir;
  Directory get applicationDir {
    return _applicationDir;
  }

  late Directory _cacheDir;
  Directory get cacheDir {
    return _cacheDir;
  }

  String getCacheFilePath(String fileName) {
    Directory cacheFile =
        Directory(path.join(_cacheDir.path, fileName).toString());
    return cacheFile.path;
  }

  Future init() async {
    _applicationDir = await getApplicationDocumentsDirectory();
    if (!_applicationDir.existsSync()) {
      _applicationDir.createSync(recursive: true);
    }

    _cacheDir = Directory(path.join(_applicationDir.path, _cacheDirName));
    if (!_cacheDir.existsSync()) {
      _cacheDir.createSync(recursive: true);
    }
  }
}

class Service2 {
  Future init() async {
    debugPrint("Service2 init");
  }
}

final stroageServiceProvider = Provider(
  (ref) => StroageService(),
);

final service2Provider = Provider(
  (ref) => Service2(),
);

//软件初次启动异步加载服务
final initProvider = FutureProvider<bool>((ref) async {
  //模拟加载时间
  await Future.delayed(const Duration(seconds: 2));
  await ref.read(stroageServiceProvider).init();
  await ref.read(service2Provider).init();
  return true;
});
