import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:mime/mime.dart';
import 'package:pedantic/pedantic.dart';
import 'package:tuple/tuple.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

Future<Map<String, dynamic>> getConfig() async {
  return jsonDecode(await File("web/images.json").readAsString());
}

Future<void> writeConfig(Map<String, dynamic> conf) {
  return File("web/images.json")
      .writeAsString(JsonEncoder.withIndent("  ").convert(conf));
}

Future<List<int>> getFile(String s) async {
  print("Reading file '$s'");
  var uri = Uri.parse(s);
  if (uri.scheme == "file") {
    return File.fromUri(uri).readAsBytes();
  } else if (uri.scheme == "http" || uri.scheme == "https") {
    return (await (await HttpClient().getUrl(uri)).close())
        .expand((e) => e)
        .toList();
  } else {
    throw "Unknown scheme '${uri.scheme}'";
  }
}

Future<void> writeFile(String s, List<int> data) async {
  await File("web/$s").writeAsBytes(data);
}

Future<void> mkDir(String s) {
  return Directory("web/$s").create(recursive: true);
}

Future<Tuple2<int, int>> imgSize(String path) async {
  var proc = await Process.start(
      "C:\\Program Files\\ImageMagick-7.0.9-Q16\\magick.exe",
      ["identify", "web/$path"]);

  var buf = await proc.stdout.expand((e) => e).toList();

  var str = Utf8Decoder().convert(buf);
  var match = RegExp(r"(\d+)x(\d+)").firstMatch(str);

  if (match == null) throw "Could not get size: '$str'";
  return Tuple2(int.parse(match.group(1)), int.parse(match.group(2)));
}

Future<List<int>> convert(List<String> args, [List<int> data]) async {
  var proc = await Process.start(
      "C:\\Program Files\\ImageMagick-7.0.9-Q16\\magick.exe", args);

  if (data != null) {
    proc.stdin.add(data);
    await proc.stdin.close();
  }

  unawaited(stderr.addStream(proc.stderr));
  return proc.stdout.expand((e) => e).toList();
}

Future<List<int>> makeThumbnail(List<String> mime, String path) async {
  if (mime[0] == "video" || mime[1] == "gif") {
    return convert([
      "-background",
      "#404040",
      "web/$path[0]",
      "-resize",
      "400x200>",
      "jpeg:-"
    ]);
  } else if (mime[0] == "image") {
    return convert(
        ["-background", "#404040", "web/$path", "-thumbnail", "400x200>", "-"]);
  } else
    throw "Unknown kind: '${mime[0]}'";
}

void main(List<String> args) async {
  if (args.length != 1) throw "Wrong number of arguments";

  var config = await getConfig();
  var imgData = await getFile(args[0].replaceAll("\\", "/"));
  print("Done!");
  var id = md5.convert(imgData).toString();

  config["feed"] ??= [];
  config["pool"] ??= {};
  if (config["pool"][id] != null) throw "Image already exists;";

  var mime = lookupMimeType(args[0], headerBytes: imgData).split("/");

  await mkDir("content/$id");
  await writeFile("content/$id/full.${mime[1]}", imgData);

  var thumbailData = await makeThumbnail(mime, "content/$id/full.${mime[1]}");

  if (thumbailData.isEmpty) throw "Failed to make thumbnail";
  await writeFile("content/$id/thumb.jpg", thumbailData);

  var size = await imgSize("content/$id/full.${mime[1]}");

  config["feed"].add(id);

  config["pool"][id] = {
    "kind": "image",
    "width": size.item1,
    "height": size.item2,
    "src": "/content/$id/full.${mime[1]}",
    "mime": mime.join("/"),
    "thumb": "/content/$id/thumb.jpg",
  };

  await writeConfig(config);
}
