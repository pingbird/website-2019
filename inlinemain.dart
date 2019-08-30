import 'dart:io';

main() async {
  var html = await File("index.html").readAsString();
  html = html.replaceFirst("<script defer src=\"main.dart.js\"></script>", "<script>${await File("main.dart.js").readAsString()}</script>");
  html = html.replaceFirst("<link rel=\"stylesheet\" href=\"styles.css\">", "<style>${await File("styles.css").readAsString()}</style>");
  //html = html.replaceFirst("<script async=\"\" src=\"picturefill.js\"></script>", "<script>${await new File("picturefill.js").readAsString()}</script>");
  await File("index.html").writeAsString(html);
}