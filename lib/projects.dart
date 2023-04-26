import 'dart:html';

void startProjects() {
  var r1 = querySelector("#proj-row1")!;
  var r2 = querySelector("#proj-row2")!;
  var r3 = querySelector("#proj-row3")!;

  r1.children.clear();
  r2.children.clear();
  r3.children.clear();

  void add(
    Element e, {
    required String name,
    String? content,
    String? github,
    String? gitlab,
    String? website,
    String? blog,
    String? bg,
  }) {
    AnchorElement btn(String icon, String name, String url) => AnchorElement()
      ..href = url
      ..classes.add("btn")
      ..children.addAll([
        DivElement()..classes.add("btn-bg"),
        Element.img()
          ..classes.add("btn-icon")
          ..attributes["src"] = icon,
      ])
      ..appendText(name);

    e.children.add(DivElement()
      ..classes.add("project")
      ..children.addAll([
        DivElement()..classes.add("project-bg"),
        DivElement()
          ..classes.add("project-header")
          ..children.addAll([
            DivElement()..classes.add("project-logo"),
            DivElement()
              ..classes.add("project-title")
              ..text = name,
          ])
          ..style.backgroundImage = bg == null ? null : "url(\"$bg\")",
        DivElement()
          ..classes.add("content")
          ..text = content,
        DivElement()
          ..classes.add("btn-row")
          ..children.addAll([
            if (blog != null) btn("icons/proj/circ.svg", "Blog", blog),
            if (website != null)
              btn("icons/proj/globe.svg", "Website", website),
            if (github != null) btn("icons/proj/github.svg", "Source", github),
            if (gitlab != null) btn("icons/proj/gitlab.svg", "Source", gitlab),
          ])
      ]));
  }

  add(
    r1,
    name: "Boxy",
    content:
        "Boxy is a popular Flutter package to overcome the limitations of built-in layout widgets.",
    website: "https://boxy.wiki",
    github: "https://github.com/PixelToast/boxy",
    bg: "icons/banner/boxy.svg",
  );

  add(
    r1,
    name: "Puro",
    content:
        "Puro is a powerful command line tool for managing Flutter versions, it's especially useful for devs that have multiple projects or slow internet.",
    website: "https://puro.dev",
    github: "https://github.com/PixelToast/puro",
    bg: "icons/banner/puro.svg",
  );

  add(
    r2,
    name: "StackVM",
    content:
        "A curiously fast runtime for a popular esolang using a handful of novel optimization techniques and an LLVM-based JIT.",
    github: "https://github.com/PixelToast/stackvm",
    bg: "icons/banner/toast.svg",
  );

  add(
    r2,
    name: "c.tst.sh",
    content:
        "A zachtronics inspired CMOS digital logic simulator. Allows you to create any digital circuit at the silicon level.",
    blog: "https://blog.tst.sh/kohctpyktop-2-electric-bogaloo/",
    website: "https://c.tst.sh/",
    bg: "icons/banner/crc.svg",
  );

  add(
    r2,
    name: "Tangent",
    content:
        "First of its kind discord bot with an interactive repl for 50+ languages, gives users full control over a secure Linux VM.",
    github: "https://github.com/PixelToast/tangent",
    bg: "icons/banner/tan.svg",
  );

  add(
    r3,
    name: "Llama",
    content:
        "An experimental lambda calculus based programming language, includes a comprehensive and innovative standard library.",
    blog: "https://blog.tst.sh/llama/",
    github: "https://github.com/PixelToast/llama",
    bg: "icons/banner/llama.svg",
  );

  add(
    r3,
    name: "DartLua",
    content:
        "A Dart library and CLI for running, disassembling, and debugging Lua programs. Includes a functioning bytecode VM and disassembler.",
    github: "https://github.com/PixelToast/dartlua",
    bg: "icons/banner/lua.svg",
  );
}
