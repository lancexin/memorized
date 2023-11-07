import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'http_util.dart';

const urlBase = "https://www.baidu.com/";

final httpUtilProvider = Provider((ref) => HttpUtil(urlBase));
