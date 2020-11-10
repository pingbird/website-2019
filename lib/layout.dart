import 'dart:html';
import 'dart:math';
import 'dart:svg';

void startLayout() {
  var body = querySelector("body");
  var bodyBg = querySelector("#body-bg");
  var content = querySelector("#content");
  var contentBg = querySelector("#content-bg");
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
  var posts = querySelector("#recent-posts");
  var postsBg = querySelector("#recent-posts-bg");
  var postsTitle = querySelector("#recent-posts-title");
  var postsContent = querySelector("#recent-posts-content");
  var projects = querySelector("#projects");
  var projectsBg = querySelector("#projects-bg");
  var projectsContent = querySelector("#projects-content");


  int shrink = 0;

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

  const chipPrimary = '#36393f';
  const chipUnder = '#41454c';
  const chipInner = chipPrimary;
  const chipEdge = '#525760';
  const edgeWidth = 3;

  void renderHeader() {
    print("hello");
    var e = SvgSvgElement();

    var defs = SvgElement.tag("defs");

    defs.children.add(
        SvgElement.tag("linearGradient")
          ..attributes["id"] = "blue"
          ..attributes["x1"] = "0%"
          ..attributes["x2"] = "0%"
          ..attributes["x2"] = "100%"
          ..attributes["y2"] = "100%"
          ..children.addAll([
            SvgElement.tag("stop")
              ..attributes["offset"] = "0%"
              ..style.setProperty("stop-color", "#2a70b3")
              ..style.setProperty("stop-opacity", "1"),

            SvgElement.tag("stop")
              ..attributes["offset"] = "100%"
              ..style.setProperty("stop-color", "#2d8dd7")
              ..style.setProperty("stop-opacity", "1"),
          ])
    );

    e.children.add(defs);

    const showTitleBg = false;

    if (showTitleBg) {
      var w = header.clientWidth;
      var h = header.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 6 * 8,
        w - 8, h - 5 * 8,
        if (shrink < 1) ...[
          w - 31 * 8, h - 5 * 8,
          w - 36 * 8, h,
          36 * 8, h,
          31 * 8, h - 5 * 8,
        ],
        8, h - 5 * 8,
        0, h - 6 * 8,
      ], style: "fill:$chipUnder");

      poly(e, [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 7 * 8,
        w - 8, h - 6 * 8,
        if (shrink < 1) ...[
          w - 31 * 8, h - 6 * 8,
          w - 36 * 8, h - 8,
          36 * 8, h - 8,
          31 * 8, h - 6 * 8,
        ],
        8, h - 6 * 8,
        0, h - 7 * 8,
      ], style: "fill:$chipPrimary");
    }

    if (showTitleBg) {
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
      ], style: "fill:url(#blue)", transform: "translate(${tstText.offsetLeft},${tstText.offsetTop})");
    }

    headerBg.children = [e];
  }

  void renderContent() {
    var e = SvgSvgElement();


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

      var w = content.clientWidth;
      var h = content.clientHeight;

      var os = btns[0].documentOffset - content.documentOffset;

      var ch = os.y + 8 * 17;

      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, ch + 8 * -5 + st * -2,
        26 * st + os.x, ch + 8 * -5,
        os.x + st * 20 + 8 * 18, ch + 8 * -5,
        os.x + st * 24 + 8 * 18, ch + 8 * -5 + st * 4,
        os.x + st * 24 + 8 * 18, h - 8,
        os.x + st * 18 + 8 * 18, h - 8,
        os.x + st * 18 + 8 * 18, ch + 8 * -4 + st * 2,
        os.x + st * 16 + 8 * 18, ch - 8 * 4,
        22 * st + os.x, ch + 8 * -4,
        18 * st + os.x, ch + 8 * -4 + st * -4,
      ], style: "fill:#fff", opacity: "0.2");

      os = btns[1].documentOffset - content.documentOffset;
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, ch + 8 * -7 + st * -2,
        26 * st + os.x, ch + 8 * -7,
        os.x + st * 19 + 8 * 8, ch - 8 * 7,
        os.x + st * 24 + 8 * 9, ch + 8 * -6 + st * 5,
        os.x + st * 24 + 8 * 9, h - 8,
        os.x + st * 18 + 8 * 9, h - 8,
        os.x + st * 18 + 8 * 9, ch + 8 * -5 + st * 2,
        os.x + st * 16 + 8 * 8, ch - 8 * 6,
        22 * st + os.x, ch + 8 * -6,
        18 * st + os.x, ch + 8 * -6 + st * -4,
      ], style: "fill:#fff", opacity: "0.2");

      os = btns[2].documentOffset - content.documentOffset;
      poly(e, [
        ...head(os.x, os.y + 56),
        os.x + st * 24, h - 8,
        os.x + st * 18, h - 8,
      ], style: "fill:#fff", opacity: "0.2");

      os = btns[3].documentOffset - content.documentOffset;
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, ch + 8 * -6 + st * -4,
        20 * st + os.x, ch + 8 * -6,
        os.x + st * 26 - 8 * 8, ch - 8 * 6,
        os.x + st * 24 - 8 * 9, ch + 8 * -5 + st * 2,
        os.x + st * 24 - 8 * 9, h - 8,
        os.x + st * 18 - 8 * 9, h - 8,
        os.x + st * 18 - 8 * 9, ch + 8 * -6 + st * 5,
        os.x + st * 23 - 8 * 8, ch - 8 * 7,
        16 * st + os.x, ch - 8 * 7,
        18 * st + os.x, ch - 8 * 7 + st * -2,
      ], style: "fill:#fff", opacity: "0.2");

      os = btns[4].documentOffset - content.documentOffset;
      poly(e, [
        ...head(os.x, os.y + 56),
        24 * st + os.x, ch + 8 * -4 + st * -4,
        20 * st + os.x, ch + 8 * -4,
        os.x + st * 26 - 8 * 18, ch - 8 * 4,
        os.x + st * 24 - 8 * 18, ch + 8 * -4 + st * 2,
        os.x + st * 24 - 8 * 18, h - 8,
        os.x + st * 18 - 8 * 18, h - 8,
        os.x + st * 18 - 8 * 18, ch + 8 * -5 + st * 4,
        os.x + st * 22 - 8 * 18, ch - 8 * 5,
        16 * st + os.x, ch - 8 * 5,
        18 * st + os.x, ch - 8 * 5 + st * -2,
      ], style: "fill:#fff", opacity: "0.2");
    }

    contentBg.children = [e];
  }

  renderBody() {
    var e = SvgSvgElement();

    var defs = SvgElement.tag("defs");

    defs.children.add(
      SvgElement.tag("linearGradient")
        ..attributes["id"] = "blue"
        ..attributes["x1"] = "0%"
        ..attributes["x2"] = "0%"
        ..attributes["x2"] = "100%"
        ..attributes["y2"] = "100%"
        ..children.addAll([
          SvgElement.tag("stop")
            ..attributes["offset"] = "0%"
            ..style.setProperty("stop-color", "#2a70b3")
            ..style.setProperty("stop-opacity", "0.9"),

          SvgElement.tag("stop")
            ..attributes["offset"] = "100%"
            ..style.setProperty("stop-color", "#3c82bc")
            ..style.setProperty("stop-opacity", "0.9"),
        ])
    );

    e.children.add(defs);

    var w = body.clientWidth;
    var h = header.documentOffset.y + header.clientHeight;

    var l = content.documentOffset.x;
    var r = l + content.clientWidth;

    var p = [
      0, 0,
      w, 0,
      w, if (shrink < 1) h - 5 * 8 else h,
      if (shrink < 1) ...[
        r - 32 * 8, h - 5 * 8,
        r - 37 * 8, h,
        l + 37 * 8, h,
        l + 32 * 8, h - 5 * 8,
      ],
      0, if (shrink < 1) h - 5 * 8 else h,
    ];

    poly(e, p, style: "stroke:#2a70b3;stroke-width:1.5;");
    poly(e, p, style: "fill:url(#blue);");

    bodyBg.children = [e];
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
      ], style: "fill:$chipUnder");
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
      ], style: "fill:$chipEdge;");
    }

    {
      var w = about.clientWidth;
      var h = about.clientHeight;
      poly(e, [
        0.5, 8,
        8, 0.5,
        30 * 8 - 0.3, 0.5,
        35 * 8 - 0.3, 0.5 + 8 * 5,
        w - 8 - 0.3, 0.5 + 8 * 5,
        w - 0.5, 8 * 6 + 0.3,
        w - 0.5, h - 16 - 0.3,
        w - 8 - 0.3, h - 8 - 0.5,
        8 + 0.3, h - 8 - 0.5,
        0.5, h - 16 - 0.3,
      ], style: "fill:$chipPrimary;");
    }

    {
      var w = aboutContent.clientWidth;
      var h = aboutContent.clientHeight;
      var p = [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ];

      poly(e, p, style: "fill:$chipInner;", transform: "translate(${aboutContent.offsetLeft},${aboutContent.offsetTop})");
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
      ], style: "fill:$chipUnder");
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
      ], style: "fill:$chipEdge");
    }

    {
      var w = links.clientWidth;
      var h = links.clientHeight;
      poly(e, [
        0.5, 8 * 6 + 0.3,
        8 + 0.3, 8 * 5 + 0.5,
        w - 35 * 8 + 0.3, 8 * 5 + 0.5,
        w - 30 * 8 + 0.3, 0.5,
        w - 8 - 0.3, 0.5,
        w - 0.5, 8 + 0.3,
        w - 0.5, h - 16 - 0.3,
        w - 8 - 0.3, h - 8 - 0.5,
        8 - 0.3, h - 8 - 0.5,
        0.5, h - 16 - 0.3,
      ], style: "fill:$chipPrimary");
    }

    {
      var w = linksContent.clientWidth;
      var h = linksContent.clientHeight;
      var p = [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ];

      poly(e, p, style: "fill:$chipInner;", transform: "translate(${linksContent.offsetLeft},${linksContent.offsetTop})");
    }

    linksBg.children = [e];
  }

  void renderPosts() {
    var e = SvgSvgElement();

    {
      var w = posts.clientWidth;
      var h = posts.clientHeight;
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
      ], style: "fill:$chipUnder");
    }

    {
      var w = posts.clientWidth;
      var h = posts.clientHeight;
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
      ], style: "fill:$chipEdge");
    }

    {
      var w = posts.clientWidth;
      var h = posts.clientHeight;
      poly(e, [
        0.5, 8 + 0.3,
        8 + 0.3, 0.5,
        30 * 8 - 0.3, 0.5,
        35 * 8 - 0.3, 8 * 5 + 0.5,
        w - 8 - 0.3, 8 * 5 + 0.5,
        w - 0.5, 8 * 6 - 0.3,
        w - 0.5, h - 16 - 0.3,
        w - 8 - 0.3, h - 8 - 0.5,
        8 + 0.5, h - 8 - 0.5,
        0 + 0.5, h - 16 - 0.3,
      ], style: "fill:$chipPrimary");
    }

    postsBg.children = [e];

    var w = postsContent.clientWidth;
    var h = postsContent.clientHeight;
    var path =
      "polygon("
      "0px 8px,"
      "8px 0px,"
      "${w - 8}px 0px,"
      "${w}px 8px,"
      "${w}px ${h - 8}px,"
      "${w - 8}px ${h}px,"
      "8px ${h}px,"
      "0px ${h - 8}px"
      ")";
    postsContent.style.clipPath = path;
  }

  void renderProjects() {
    var e = SvgSvgElement();

    {
      var w = projects.clientWidth;
      var h = projects.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        15 * 8, 0,
        20 * 8, 8 * 5,
        w - 8, 8 * 5,
        w, 8 * 6,
        w, h - 8,
        w - 8, h,
        w - 15 * 8, h,
        w - 20 * 8, h - 8 * 5,
        20 * 8, h - 8 * 5,
        15 * 8, h,
        15 * 8, h,
        8, h,
        0, h - 8,
      ], style: "fill:$chipUnder");
    }

    {
      var w = projects.clientWidth;
      var h = projects.clientHeight;
      poly(e, [
        0, 8,
        8, 0,
        15 * 8, 0,
        20 * 8, 8 * 5,
        w - 20 * 8, 8 * 5,
        w - 15 * 8, 0,
        w - 8, 0,
        w, 8,
        w, h - 16,
        w - 8, h - 8,
        w - 15 * 8, h - 8,
        w - 20 * 8, h - 8 * 6,
        20 * 8, h - 8 * 6,
        15 * 8, h - 8,
        8, h - 8,
        0, h - 16,
      ], style: "fill:$chipEdge;");
    }

    {
      var w = projects.clientWidth;
      var h = projects.clientHeight;
      poly(e, [
        0 + 0.5, 8 + 0.3,
        8 + 0.3, 0.5,
        15 * 8 - 0.3, 0 + 0.5,
        20 * 8 - 0.3, 8 * 5 + 0.5,
        w - 20 * 8 + 0.3, 8 * 5 + 0.5,
        w - 15 * 8 + 0.3, 0 + 0.5,
        w - 8 - 0.5 , 0.5,
        w - 0.3, 8 + 0.5,
        w - 0.5, h - 16 - 0.3,
        w - 8 - 0.3, h - 8 - 0.5,
        w - 15 * 8 + 0.3, h - 8 - 0.5,
        w - 20 * 8 + 0.3, h - 8 * 6 - 0.5,
        20 * 8 - 0.3, h - 8 * 6 - 0.5,
        15 * 8 - 0.3, h - 8 - 0.5,
        8 + 0.3, h - 8 - 0.5,
        0 + 0.5, h - 16 + 0.3,
      ], style: "fill:$chipPrimary;");
    }

    {
      var w = projectsContent.clientWidth;
      var h = projectsContent.clientHeight;
      var p = [
        0, 8,
        8, 0,
        w - 8, 0,
        w, 8,
        w, h - 8,
        w - 8, h,
        8, h,
        0, h - 8,
      ];

      poly(e, p, style: "fill:$chipInner", transform: "translate(${projectsContent.offsetLeft},${projectsContent.offsetTop})");
    }

    projectsBg.children = [e];
  }

  void render() {
    shrink = 0;
    if (body.clientWidth < 1098) shrink++;
    if (body.clientWidth < 600) shrink++;

    aboutRow.style.flexDirection = shrink > 0 ? "column" : "row";
    aboutRow.style.marginTop = shrink > 0 ? "16px" : "";

    links.style.marginLeft = shrink > 0 ? "0" : "";
    links.style.width = shrink > 0 ? "100%" : "";
    links.style.maxWidth = shrink > 0 ? "none" : "";

    linksContent.style.flexDirection = shrink > 0 ? "row" : "";

    if (shrink > 0) {
      linksContent.classes.add("shrink");
    } else {
      linksContent.classes.remove("shrink");
    }

    links.style.marginTop = shrink > 0 ? "16px" : "";

    var m = max(8, min(128, max(0, ((body.clientWidth - 1170) / 2).floor())));
    var marg = "${m}px";
    tstText.style.margin = "${m ~/ 2}px auto";
    tstText.style.maxWidth = shrink > 1 ? "400px" : "";
    content.style.marginBottom = marg;

    // renderHeader();
    // renderContent();
    renderBody();
    renderAbout();
    renderLinks();
    renderPosts();
    renderProjects();
  }

  window.onResize.listen((e) {
    render();
  });
  render();
}