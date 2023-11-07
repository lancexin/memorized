import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:memorized/core/exception.dart';
import 'package:path/path.dart';

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import 'http_util.dart';

//自定义 image 加载和缓存
class NetworkImagePrivider extends ImageProvider<NetworkImagePrivider> {
  final String url;

  final double scale;

  final HttpUtil httpUtil;

  final Duration? cacheMaxAge;

  NetworkImagePrivider(this.url,
      {this.cacheMaxAge, this.scale = 1.0, required this.httpUtil});

  @override
  ImageStreamCompleter loadImage(
      NetworkImagePrivider key, ImageDecoderCallback decode) {
    final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, chunkEvents, decode: decode),
      chunkEvents: chunkEvents.stream,
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<NetworkImagePrivider>('Image provider', this),
        DiagnosticsProperty<NetworkImagePrivider>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(
    NetworkImagePrivider key,
    StreamController<ImageChunkEvent> chunkEvents, {
    required ImageDecoderCallback decode,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      final String md5Key = keyToMd5(key.url);
      final Directory cacheImagesDirectory = Directory(
          join((await getTemporaryDirectory()).path, cacheImageFolderName));
      String savePath = join(cacheImagesDirectory.path, md5Key);
      Uint8List? bytes =
          await _loadCache(key, chunkEvents, cacheImagesDirectory, savePath);
      if (bytes != null) {
        final ui.ImmutableBuffer buffer =
            await ui.ImmutableBuffer.fromUint8List(bytes);
        return decode(buffer);
      }

      bytes =
          await _loadNetwork(key, chunkEvents, cacheImagesDirectory, savePath);
      final ui.ImmutableBuffer buffer =
          await ui.ImmutableBuffer.fromUint8List(bytes!);
      return decode(buffer);
    } catch (e) {
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    } finally {
      chunkEvents.close();
    }
  }

  /// Get the image from cache folder.
  Future<Uint8List?> _loadCache(
      NetworkImagePrivider key,
      StreamController<ImageChunkEvent>? chunkEvents,
      Directory cacheImagesDirectory,
      String savePath) async {
    Uint8List? data;

    if (cacheImagesDirectory.existsSync()) {
      final File cacheFlie = File(savePath);
      if (cacheFlie.existsSync()) {
        if (key.cacheMaxAge != null) {
          final DateTime now = DateTime.now();
          final FileStat fs = cacheFlie.statSync();
          if (now.subtract(key.cacheMaxAge!).isAfter(fs.changed)) {
            cacheFlie.deleteSync(recursive: true);
          } else {
            data = await cacheFlie.readAsBytes();
          }
        } else {
          data = await cacheFlie.readAsBytes();
        }
      }
    }
    // create folder
    else {
      await cacheImagesDirectory.create();
    }
    // load from network
    data ??= await _loadNetwork(
      key,
      chunkEvents,
      cacheImagesDirectory,
      savePath,
    );

    return data;
  }

  Future<Uint8List?> _loadNetwork(
    NetworkImagePrivider key,
    StreamController<ImageChunkEvent>? chunkEvents,
    Directory cacheImagesDirectory,
    String savePath,
  ) async {
    var result = await httpUtil.download(
      urlPath: key.url,
      savePath: savePath,
      progressCallback: (count, total) {
        chunkEvents?.add(ImageChunkEvent(
          cumulativeBytesLoaded: count,
          expectedTotalBytes: total,
        ));
      },
    );
    if (result.success) {
      return await _loadCache(key, chunkEvents, cacheImagesDirectory, savePath);
    }
    throw RequestException(result.statusCode, "load image error");
  }

  @override
  Future<NetworkImagePrivider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<NetworkImagePrivider>(this);
  }
}

const String cacheImageFolderName = 'cacheimage';

/// get md5 from key
String keyToMd5(String key) => md5.convert(utf8.encode(key)).toString();
