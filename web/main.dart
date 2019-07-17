import 'dart:html';

import 'dart:svg';

void main() {
  var content = querySelector("#content");
  var header = querySelector("#header");
  var headerBg = querySelector("#header-bg");
  var tstText = querySelector("#tst-text");
  var tstBtnRow = querySelector("#tst-btn-row");
  var aboutRow = querySelector("#about-row");
  var about = querySelector("#about");
  var aboutTitle = querySelector("#about-title");
  var aboutContent = querySelector("#about-content");
  var links = querySelector("#links");
  var linksTitle = querySelector("#links-title");
  var linksContent = querySelector("#links-content");

  void poly(Element parent, List<num> points, {String style, String transform}) {
    var p = PolygonElement();
    var pts = StringBuffer();
    for (int i = 0; i < points.length; i += 2) {
      pts.write(points[i]);
      pts.write(",");
      pts.write(points[i + 1]);
      pts.write(" ");
    }
    p.attributes["points"] = pts.toString();
    p.attributes["style"] = style;
    p.attributes["transform"] = transform;
    parent.children.add(p);
  }

  void renderHeader() {
    print("hello");
    var e = SvgSvgElement();

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

    {
      var p = PolygonElement();
      var w = header.clientWidth;
      var h = header.clientHeight;
      p.attributes["points"] =
        "0,8 "
        "8,0 "
        "${w - 8},0 "
        "$w,8 "
        "$w,${h - 7 * 8} "
        "${w - 8},${h - 6 * 8} "
        "${w - 31 * 8},${h - 6 * 8} "
        "${w - 36 * 8},${h - 8} "
        "${36 * 8},${h - 8} "
        "${31 * 8},${h - 6 * 8} "
        "8,${h - 6 * 8} "
        "0,${h - 7 * 8} "
      ;
      p.attributes["style"] = "fill:#3b536d";
      e.children.add(p);
    }

    {
      var p = PolygonElement();
      var w = tstText.clientWidth;
      var h = tstText.clientHeight;
      p.attributes["points"] =
        "0,8 "
        "8,0 "
        "${w - 8},0 "
        "$w,8 "
        "$w,${h - 8} "
        "${w - 8},$h "
        "8,$h "
        "0,${h - 8}";
      p.attributes["style"] = "fill:#2b94e5";
      p.attributes["transform"]="translate(${tstText.offsetLeft},${tstText.offsetTop})";
      e.children.add(p);
    }


    headerBg.children = [e];
  }

  void render() {
    renderHeader();
  }

  ResizeObserver((entries, observer) {
    render();
  }).observe(querySelector("body"));
}
