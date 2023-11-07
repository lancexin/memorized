import 'package:memorized/core/http/http_util.dart';

void main() async {
  var httpUtil = HttpUtil("");
  const String filePath =
      "https://img.177picyy.com/uploads/2023/06b/013_28-1.jpg";

  await httpUtil.download(urlPath: filePath, savePath: "013_28-1.jpg");
}
