import 'dart:html';

void startProjects() {
  var projContent = querySelector("#projects-content");

  var r1 = querySelector("#proj-row1");
  var r2 = querySelector("#proj-row2");
  var r3 = querySelector("#proj-row3");

  r1.children.clear();
  r2.children.clear();
  r3.children.clear();

  void add(DivElement e, {
    String name,
    String content,
    String github,
    String website,
    String blog,
    String bg,
  }) {
    DivElement btn(String icon, String name) =>
      DivElement()
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
        DivElement()
          ..classes.add("project-bg"),
        DivElement()
          ..classes.add("project-header")
          ..children.addAll([
            DivElement()
              ..classes.add("project-logo"),
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
            if (blog != null) btn("icons/proj/circ.svg", "Blog"),
            if (website != null) btn("icons/proj/globe.svg", "Website"),
            if (github != null) btn("icons/proj/github.svg", "Source"),
          ])
      ])
    );
  }

  add(r1,
    name: "c.tst.sh",
    content: "A zachtronics inspired CMOS digital logic simulator. Allows you to create any digital circuit at the silicon level.",
    blog: "",
    website: "",
    bg: "icons/banner/crc.svg"
  );

  add(r1,
    name: "Tangent",
    content: "A discord bot with an interactive repl for 50+ languages sandboxed using a full Linux VM.",
    blog: "",
    github: "",
    bg: "icons/banner/tan.svg"
  );

  add(r2,
    name: "Llama",
    content: "An experimental lambda calculus based programming language, includes a comprehensive and innovative standard library.",
    blog: "",
    github: "",
    bg: "icons/banner/llama.svg",
  );

  add(r2,
    name: "^v",
    content: "Framework to create modular asynchronous networked applications in Lua, primarily used as an IRC bot.",
    github: ""
  );

  add(r2,
    name: "DartLua",
    content: "A Dart library and CLI for running, disassembling, and debugging Lua programs. Includes a functioning bytecode VM and disassembler.",
    github: "",
    bg: "icons/banner/lua.svg",
  );

  add(r3,
    name: "Starstruck",
    content: "My robot code used in the 2016-2017 VEX Competition “Starstruck”. Includes several high level features never before seen on a vex robot.",
    blog: "",
    github: "",
    bg: "icons/banner/star.svg",
  );

  add(r3,
    name: "Toast",
    content: "An experimental programming language that compiles to brainfuck. Includes type inference, automatic variable initialization and more.",
    github: ""
  );
}