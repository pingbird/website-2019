@JS()
library t;

import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:svg' hide ImageElement;

import 'package:js/js.dart';
import 'package:tuple/tuple.dart';
import 'package:w2019/modal.dart';

@JS("isIntersecting")
external bool isIntersecting(dynamic obj);

Future<void> startLayout() async {
  var body = querySelector("body")!;
  var bodyBg = querySelector("#body-bg")!;
  var content = querySelector("#content")!;
  var contentBg = querySelector("#content-bg")!;
  var header = querySelector("#header")!;
  var headerBg = querySelector("#header-bg")!;
  var tstText = querySelector("#tst-text")!;
  var gallery = querySelector("#gallery")!;

  int shrink = 0;

  void poly(
    Element parent,
    List<num> points, {
    String? style,
    String? transform,
    String? opacity,
  }) {
    var p = PolygonElement();
    var pts = StringBuffer();
    for (int i = 0; i < points.length; i += 2) {
      pts.write(points[i]);
      pts.write(",");
      pts.write(points[i + 1]);
      pts.write(" ");
    }
    p.attributes["points"] = pts.toString();
    if (style != null) p.attributes["style"] = style;
    if (transform != null) p.attributes["transform"] = transform;
    if (opacity != null) p.attributes["opacity"] = opacity;
    parent.children.add(p);
  }

  int? lastWidth;

  void renderBody() {
    var e = SvgSvgElement();

    var defs = SvgElement.tag("defs");

    defs.children.add(SvgElement.tag("linearGradient")
      ..attributes["id"] = "blue"
      ..attributes["x1"] = "0%"
      ..attributes["x2"] = "0%"
      ..attributes["x2"] = "100%"
      ..attributes["y2"] = "100%"
      ..children.addAll([
        SvgElement.tag("stop")
          ..attributes["offset"] = "0%"
          ..style.setProperty("stop-color", "#333333")
          ..style.setProperty("stop-opacity", "0.9"),
        SvgElement.tag("stop")
          ..attributes["offset"] = "100%"
          ..style.setProperty("stop-color", "#444444")
          ..style.setProperty("stop-opacity", "0.9"),
      ]));

    e.children.add(defs);

    var w = body.clientWidth;
    var h = header.documentOffset.y + header.clientHeight;

    var l = content.documentOffset.x;
    var r = l + content.clientWidth;

    var p = [
      0,
      0,
      w,
      0,
      w,
      if (shrink < 1) h - 4 * 8 else h,
      if (shrink < 1) ...[
        r - 32 * 8,
        h - 4 * 8,
        r - 37 * 8,
        h,
        l + 37 * 8,
        h,
        l + 32 * 8,
        h - 4 * 8,
      ],
      0,
      if (shrink < 1) h - 4 * 8 else h,
    ];

    poly(e, p, style: "stroke:#333333;stroke-width:2;");
    poly(e, p, style: "fill:url(#blue);");

    bodyBg.children = [e];
  }

  var images = <GalleryContent>[];
  var modal = Modal(body);
  var conf = jsonDecode(await HttpRequest.getString("/images.json"));

  for (var id in conf["feed"]) {
    var img = conf["pool"][id];
    images.add(GalleryContent.fromJson(img));
  }

  const imgHeight = 200;

  var loadedThumbs = <String>{};
  var observers = <IntersectionObserver>{};

  void renderGallery() {
    observers.forEach((e) => e.disconnect());
    observers.clear();

    var imgPadding = 6;

    if (lastWidth == content.clientWidth) return;
    gallery.children.clear();

    var widths = <double>[];

    for (var i in images) {
      var estWidth =
          min(imgHeight * 2, imgHeight * (i.meta.width / i.meta.height)) +
              imgPadding;
      widths.add(estWidth.toDouble());
    }

    int i = 0;

    var rows = <List<Tuple2<num, int>>>[];
    var rowWidths = <num>[];

    while (i < images.length) {
      var imgs = <Tuple2<num, int>>[];
      rows.add(imgs);
      var rowWidth = 0.0;
      while (i < images.length && rowWidth < content.clientWidth) {
        imgs.add(Tuple2(widths[i], i));
        rowWidth += widths[i];
        i++;
      }

      rowWidths.add(rowWidth);
    }

    if (rows.length > 1) {
      while (rowWidths[rows.length - 1] < (content.clientWidth - 200)) {
        int largestRow = 0;
        num largestSize = rowWidths[0];
        for (int i = max(1, rows.length - 3); i < rows.length - 1; i++) {
          if (rowWidths[i] > largestSize) {
            largestRow = i;
            largestSize = rowWidths[i];
          }
        }

        var img = rows[largestRow].last;

        rows[largestRow].removeLast();
        rowWidths[largestRow] -= img.item1;
        rowWidths[rows.length - 1] += img.item1;
        rows[rows.length - 1].add(img);
      }
    }

    for (int i = 0; i < rows.length; i++) {
      var row = rows[i];

      var rdiv = DivElement()..classes.add("gallery-row");
      var bias = 0.0;
      for (var img in row) {
        var ow = img.item1 * max(1, content.clientWidth / rowWidths[i]) + bias;
        var w = ow.floor();
        bias = ow - w;

        var div = DivElement();

        var cn = images[img.item2];

        var thumb = cn.meta.thumb;
        if (loadedThumbs.contains(thumb)) {
          div.style.backgroundImage = "url('${thumb}')";
          div.classes.add("visible");
        } else {
          late IntersectionObserver observer;
          observer = IntersectionObserver((l, _2) {
            if (l.length == 1 && !isIntersecting(l[0])) return;
            observer.disconnect();
            observers.remove(observer);
            div.style.backgroundImage = "url('${thumb}')";
            (ImageElement()..src = thumb).onLoad.first.then((_) {
              loadedThumbs.add(thumb);
              div.style.opacity = "1";
            });
          })
            ..observe(div);
          observers.add(observer);
        }

        if (cn is GalleryImage && cn.mime.split("/")[0] == "video") {
          div.children.add(DivElement()
            ..classes.add("gallery-img-overlay")
            ..children.add(ImageElement()
              ..src = "/assets/play.svg"
              ..style.width = "64px"
              ..style.height = "64px"));
        } else if (cn is GalleryImage && cn.mime == "image/gif") {
          div.children.add(DivElement()
            ..classes.add("gallery-img-overlay")
            ..children.add(ImageElement()
              ..src = "/assets/gif.svg"
              ..style.width = "64px"
              ..style.height = "64px"));
        } else if (cn is GalleryScene) {
          div.children.add(DivElement()
            ..classes.add("gallery-img-overlay")
            ..children.add(ImageElement()
              ..src = "/assets/cube.svg"
              ..style.width = "48px"
              ..style.height = "48px"));
        }

        rdiv.children.add(div
          ..classes.add("gallery-img")
          ..style.width = "${w}px"
          ..style.height = "${imgHeight}px"
          ..style.margin = "${imgPadding}px"
          ..onClick.listen((_) => modal.showContent(cn)));
      }

      gallery.children.add(rdiv);
    }
  }

  void render() {
    shrink = 0;
    if (body.clientWidth < 1098) shrink++;
    if (body.clientWidth < 600) shrink++;

    var m = max(8, min(128, max(0, ((body.clientWidth - 1170) / 2).floor())));
    var marg = "${m}px";
    gallery.style.marginTop = marg;
    gallery.style.marginBottom = marg;

    renderBody();
    renderGallery();

    lastWidth = content.clientWidth;
  }

  window.onResize.listen((e) {
    render();
  });
  render();
}

void main() {
  startLayout();
}
