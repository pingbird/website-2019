import 'dart:async';
import 'dart:html';

import 'package:xml/xml.dart' as xml;

Future<String> _timeoutRequest(
  String url, {
  String? method,
  bool? withCredentials,
  String? responseType,
  String? mimeType,
  Map<String, String>? requestHeaders,
  dynamic sendData,
  void Function(ProgressEvent e)? onProgress,
  double? timeout,
}) {
  var completer = Completer<HttpRequest>();

  var xhr = HttpRequest();
  if (method == null) {
    method = 'GET';
  }

  xhr.open(method, url, async: true);

  if (withCredentials != null) {
    xhr.withCredentials = withCredentials;
  }

  if (responseType != null) {
    xhr.responseType = responseType;
  }

  if (mimeType != null) {
    xhr.overrideMimeType(mimeType);
  }

  if (requestHeaders != null) {
    requestHeaders.forEach((header, value) {
      xhr.setRequestHeader(header, value);
    });
  }

  if (onProgress != null) {
    xhr.onProgress.listen(onProgress);
  }

  if (timeout != null) xhr.timeout = (timeout * 1000).floor();

  xhr.onLoad.listen((e) {
    var accepted = xhr.status! >= 200 && xhr.status! < 300;
    var fileUri = xhr.status == 0;
    var notModified = xhr.status == 304;
    var unknownRedirect = xhr.status! > 307 && xhr.status! < 400;
    if (accepted || fileUri || notModified || unknownRedirect) {
      completer.complete(xhr);
    } else {
      completer.completeError(e);
    }
  });

  xhr.onError.listen(completer.completeError);

  if (sendData != null) {
    xhr.send(sendData);
  } else {
    xhr.send();
  }

  return completer.future.then((e) => e.response);
}

void startBlog() async {
  try {
    var res = await _timeoutRequest("https://blog.tst.sh/rss/", timeout: 5.0);
    var doc = xml.XmlDocument.parse(res);

    xml.XmlElement? find(xml.XmlNode p, String name) {
      for (var c in p.children) {
        if (c is xml.XmlElement && c.name.toString() == name) return c;
      }
      return null;
    }

    Iterable<xml.XmlElement> findAll(xml.XmlNode p, String name) sync* {
      for (var c in p.children) {
        if (c is xml.XmlElement && c.name.toString() == name) yield c;
      }
    }

    String cdata(xml.XmlNode node) => (node.firstChild as xml.XmlCDATA).text;

    var channel = find(find(doc.root, "rss")!, "channel")!;
    var posts = findAll(channel, "item");

    var postsContent = querySelector("#recent-posts-content");

    var postBgs = <DivElement>[];
    var postElms = <HtmlElement>[];
    String? transTo;
    Timer? transTimer;
    Timer? resetTimer;
    DateTime? resetLast;

    var bgMainDiv = querySelector("#blog-posts-bg-main") as DivElement;
    var bgMain = (querySelector("#blog-posts-bg-main")!
        .querySelector(".blog-posts-bg-inner") as DivElement);
    var bgBack = (querySelector("#blog-posts-bg-back")!
        .querySelector(".blog-posts-bg-inner") as DivElement);

    int i = 0;
    for (var post in posts.take(6)) {
      var title = cdata(find(post, "title")!);
      var categories = findAll(post, "category").map(cdata).toSet();
      var banner = find(post, "media:content")!
          .attributes
          .firstWhere((e) => e.name.toString() == "url")
          .value;
      var href = find(post, "link")!.text;

      var c = AnchorElement()
        ..href = href
        ..classes.add("blog-post")
        ..children.addAll([
          DivElement()..classes.add("blog-post-pin"),
          DivElement()
            ..classes.add("blog-post-title")
            ..text = title,
          DivElement()..classes.add("blog-post-text"),
        ]);

      c.onMouseEnter.listen((e) {
        if (resetTimer != null &&
            DateTime.now().difference(resetLast!).inMilliseconds > 50) {
          //bgBack.style.backgroundImage = "none";
        }

        if (transTo != null) {
          transTimer!.cancel();
          bgMainDiv.style.opacity = "1";
          //bgBack.style.backgroundImage = "url($transTo)";
        }

        resetTimer?.cancel();
        resetTimer = null;

        if (true) {
          bgMainDiv.style.transition = "default";
          bgMainDiv.classes.remove("blog-posts-bg");
          bgMainDiv.classes.add("blog-posts-bg");
          bgMainDiv.style.transition = "all 0.5s ease";
        }

        bgMain.style.backgroundImage = 'url("$banner")';
        bgMainDiv.style.opacity = "1";
        transTo = banner;
        transTimer = Timer(Duration(milliseconds: 500), () {
          bgMainDiv.style.opacity = "1";
          //bgBack.style.backgroundImage = "url($transTo)";
          transTo = null;
        });

        for (var p in postElms) if (p != c) p.style.opacity = "0.5";
        for (var p in postBgs) p.style.opacity = "1";
      });

      c.onMouseLeave.listen((e) {
        resetTimer = Timer(Duration(milliseconds: 50), () {
          transTimer?.cancel();
          transTo = null;
          resetTimer = Timer(Duration(milliseconds: 450), () {
            bgMainDiv.style.transition = "default";
            bgMainDiv.style.opacity = "default";
            bgMain.style.backgroundImage = "none";
            bgBack.style.backgroundImage = "none";
            resetTimer = null;
          });
        });
        resetLast = DateTime.now();
        for (var p in postElms) p.style.opacity = "1";
        for (var p in postBgs) p.style.opacity = "1";
      });

      postElms.add(c);
      postsContent!.children.add(c);

      var d = DivElement()
        ..classes.add("blog-posts-bg")
        ..style.clipPath =
            "polygon(0 ${i * 56}px, 100% ${i * 56}px, 100% ${(i + 1) * 56}px, 0 ${(i + 1) * 56}px)"
        ..style.zIndex = "-1"
        ..children.add(DivElement()
          ..classes.add("blog-posts-bg-inner")
          ..style.backgroundImage = 'url("${banner}")');

      postBgs.add(d);
      postsContent.children.add(d);

      i++;
    }

    querySelector("#recent-posts-content")!.style.opacity = "1";
  } catch (e, bt) {
    print("Error requesting rss feed");
    print(e);
    print(bt);
  }
}
