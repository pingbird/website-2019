import 'dart:html';
import 'dart:math';

import 'dart:svg';

void main() {
  var body = querySelector("body");
  var content = querySelector("#content");
  var header = querySelector("#header");
  var headerBg = querySelector("#header-bg");
  var tstText = querySelector("#tst-text");
  var tstBtnRow = querySelector("#tst-btn-row");
  var aboutRow = querySelector("#about-row");
  var about = querySelector("#about");
  var aboutBg = querySelector("#about-bg");
  var aboutTitle = querySelector("#about-title");
  var aboutContent = querySelector("#about-content");
  var links = querySelector("#links");
  var linksBg = querySelector("#links-bg");
  var linksTitle = querySelector("#links-title");
  var linksContent = querySelector("#links-content");

  void poly(Element parent, List<num> points, {String style, String transform, String opacity}) {
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

  void renderHeader() {
    print("hello");
    var e = SvgSvgElement();

    {
      var w = header.clientWidth;
      var h = header.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 6 * 8,
        w - 8, h - 5 * 8,
        w - 31 * 8, h - 5 * 8,
        w - 36 * 8, h,
        36 * 8, h,
        31 * 8, h - 5 * 8,
        8, h - 5 * 8,
        0, h - 6 * 8,
      ], style: "fill:#2b3d52");

      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 7 * 8,
        w - 8, h - 6 * 8,
        w - 31 * 8, h - 6 * 8,
        w - 36 * 8, h - 8,
        36 * 8, h - 8,
        31 * 8, h - 6 * 8,
        8, h - 6 * 8,
        0, h - 7 * 8,
      ], style: "fill:#3b536d");
    }

    {
      var w = tstText.clientWidth;
      var h = tstText.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ], style: "fill:#2b94e5", transform: "translate(${tstText.offsetLeft},${tstText.offsetTop})");
    }

    var btns = querySelectorAll("#tst-btn-row .tst-btn");
    const st = 8 / 6;

    {
      List<num> head(int ox, int oy) => [
        18 * st + ox, oy + 3 * st,
        16 * st + ox, oy + st,
        16 * st + ox, oy,
        26 * st + ox, oy,
        26 * st + ox, oy + st,
        24 * st + ox, oy + 3 * st,
      ];

      var w = header.clientWidth;
      var h = header.clientHeight;

      var os = btns[0].offsetTo(header);
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, h + 8 * -5 + st * -2,
        26 * st + os.x, h + 8 * -5,
        os.x + st * 20 + 8 * 18, h - 8 * 5,
        os.x + st * 24 + 8 * 18, h + 8 * -5 + st * 4,
        os.x + st * 24 + 8 * 18, h - 8,
        os.x + st * 18 + 8 * 18, h - 8,
        os.x + st * 18 + 8 * 18, h + 8 * -4 + st * 2,
        os.x + st * 16 + 8 * 18, h - 8 * 4,
        22 * st + os.x, h + 8 * -4,
        18 * st + os.x, h + 8 * -4 + st * -4,
      ], style: "fill:#fff", opacity: "0.27");

      os = btns[1].offsetTo(header);
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, h + 8 * -7 + st * -2,
        26 * st + os.x, h + 8 * -7,
        os.x + st * 20 + 8 * 9, h - 8 * 7,
        os.x + st * 24 + 8 * 9, h + 8 * -7 + st * 4,
        os.x + st * 24 + 8 * 9, h - 8,
        os.x + st * 18 + 8 * 9, h - 8,
        os.x + st * 18 + 8 * 9, h + 8 * -6 + st * 2,
        os.x + st * 16 + 8 * 9, h - 8 * 6,
        22 * st + os.x, h + 8 * -6,
        18 * st + os.x, h + 8 * -6 + st * -4,
      ], style: "fill:#fff", opacity: "0.27");

      os = btns[2].offsetTo(header);
      poly(e, [
        ...head(os.x, os.y + 56),
        os.x + st * 24, h - 8,
        os.x + st * 18, h - 8,
      ], style: "fill:#fff", opacity: "0.27");

      os = btns[3].offsetTo(header);
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, h + 8 * -6 + st * -4,
        20 * st + os.x, h + 8 * -6,
        os.x + st * 26 - 8 * 9, h - 8 * 6,
        os.x + st * 24 - 8 * 9, h + 8 * -6 + st * 2,
        os.x + st * 24 - 8 * 9, h - 8,
        os.x + st * 18 - 8 * 9, h - 8,
        os.x + st * 18 - 8 * 9, h + 8 * -7 + st * 4,
        os.x + st * 22 - 8 * 9, h - 8 * 7,
        16 * st + os.x, h - 8 * 7,
        18 * st + os.x, h - 8 * 7 + st * -2,
      ], style: "fill:#fff", opacity: "0.27");

      os = btns[4].offsetTo(header);
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, h + 8 * -4 + st * -4,
        20 * st + os.x, h + 8 * -4,
        os.x + st * 26 - 8 * 18, h - 8 * 4,
        os.x + st * 24 - 8 * 18, h + 8 * -4 + st * 2,
        os.x + st * 24 - 8 * 18, h - 8,
        os.x + st * 18 - 8 * 18, h - 8,
        os.x + st * 18 - 8 * 18, h + 8 * -5 + st * 4,
        os.x + st * 22 - 8 * 18, h - 8 * 5,
        16 * st + os.x, h - 8 * 5,
        18 * st + os.x, h - 8 * 5 + st * -2,
      ], style: "fill:#fff", opacity: "0.27");
    }

    headerBg.children = [e];
  }

  void renderAbout() {
    var e = SvgSvgElement();

    {
      var w = about.clientWidth;
      var h = about.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        30 * 8, 0,
        35 * 8, 8 * 5,
        w - 8, 8 * 5,
        w, 8 * 6,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ], style: "fill:#2b3d52");
    }

    {
      var w = about.clientWidth;
      var h = about.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        30 * 8, 0,
        35 * 8, 8 * 5,
        w - 8, 8 * 5,
        w, 8 * 6,
        w, h - 16,
        w - 8, h - 8,
        8, h - 8,
        0, h - 16,
      ], style: "fill:#3b536d");
    }

    {
      var w = aboutContent.clientWidth;
      var h = aboutContent.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ], style: "fill:#303d4f", transform: "translate(${aboutContent.offsetLeft},${aboutContent.offsetTop})");
    }

    aboutBg.children = [e];
  }

  void renderLinks() {
    var e = SvgSvgElement();

    {
      var w = links.clientWidth;
      var h = links.clientHeight;
      poly(e, [
        0, 8 * 6,
        8, 8 * 5,
        w - 35 * 8, 8 * 5,
        w - 30 * 8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ], style: "fill:#2b3d52");
    }

    {
      var w = links.clientWidth;
      var h = links.clientHeight;
      poly(e, [
        0, 8 * 6,
        8, 8 * 5,
        w - 35 * 8, 8 * 5,
        w - 30 * 8, 0,
        w - 8, 0,
        w, 8,
        w, h - 16,
        w - 8, h - 8,
        8, h - 8,
        0, h - 16,
      ], style: "fill:#3b536d");
    }

    {
      var w = linksContent.clientWidth;
      var h = linksContent.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ], style: "fill:#303d4f", transform: "translate(${linksContent.offsetLeft},${linksContent.offsetTop})");
    }

    linksBg.children = [e];
  }

  void render() {
    content.style.marginTop = "${min(128, max(0, ((body.clientWidth - 1170) / 2).floor()))}px";

    renderHeader();
    renderAbout();
    renderLinks();
  }

  ResizeObserver((entries, observer) {
    render();
  }).observe(querySelector("body"));
}
