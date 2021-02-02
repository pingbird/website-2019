import 'dart:html';
import 'dart:typed_data';

import 'package:w2019/image_viewer.dart';
import 'package:w2019/scene_viewer.dart';
import 'package:vector_math/vector_math_64.dart';

class GalleryMeta {
  int width;
  int height;
  String thumb;
  String color;

  GalleryMeta(this.width, this.height, this.thumb, this.color);

  factory GalleryMeta.fromJson(data) =>
    GalleryMeta(
      data["width"],
      data["height"],
      data["thumb"],
      data["color"] ?? "#404040",
    );
}

abstract class GalleryContent {
  GalleryContent(this.meta);
  GalleryMeta meta;

  factory GalleryContent.fromJson(dynamic data) {
    var kind = data["kind"];
    if (kind == "image") {
      return GalleryImage.fromJson(data);
    } else if (kind == "scene") {
      return GalleryScene.fromJson(data);
    }

    throw "Unknown gallery kind '$kind'";
  }
}

class GalleryImage extends GalleryContent {
  GalleryImage(this.src, this.mime, GalleryMeta meta) : super(meta);

  String src;
  String mime;

  factory GalleryImage.fromJson(data) =>
    GalleryImage(
      data["src"],
      data["mime"],
      GalleryMeta.fromJson(data),
    );
}

class GalleryScene extends GalleryContent {
  String cubemap;
  List<GalleryModel> models;

  GalleryScene(this.cubemap, this.models, GalleryMeta meta) : super(meta);

  factory GalleryScene.fromJson(data) =>
    GalleryScene(
      data["cubemap"],
      (data["models"] as List).map((e) => GalleryModel.fromJson(e)).toList(),
      GalleryMeta.fromJson(data),
    );
}

List<double> _doubles(dynamic data, int count) {
  var o = Float64List(count);
  for (int i = 0; i < count; i++) {
    o[i] = (data[i] as num).toDouble();
  }
  return o;
}

Vector3 _vector3(dynamic data) {
  var o = Vector3.fromFloat64List(_doubles(data, 3));
  print(o);
  return o;
}

dynamic uniformFromJson(dynamic data) {
  var kind = data["kind"];

  if (kind == "image") {
    return data["src"];
  } else if (kind == "double") {
    return (data["value"] as num).toDouble();
  } else if (kind == "vec3") {
    return _vector3(data["buf"]);
  } else if (kind == "vec4") {
    return Vector3.fromFloat64List(_doubles(data["buf"], 4));
  } else if (kind == "mat3") {
    return Matrix3.fromList(_doubles(data["buf"], 9));
  } else if (kind == "mat4") {
    return Matrix4.fromFloat64List(_doubles(data["buf"], 16));
  }
}

class GalleryModel {
  String obj;
  Vector3 pos;
  Vector3 ang;
  Vector3 scale;
  String fragShader;
  String vertShader;
  Map<String, dynamic> uniforms;

  GalleryModel(
    this.obj, this.pos, this.ang, this.scale,
    this.fragShader, this.vertShader, this.uniforms
  );

  factory GalleryModel.fromJson(data) =>
    GalleryModel(
      data["obj"],
      _vector3(data["pos"]),
      _vector3(data["ang"]),
      _vector3(data["scale"]),
      data["fragShader"],
      data["vertShader"],
      (data["uniforms"] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, uniformFromJson(v)))
    );
}

class Modal {
  Modal(this.parent) {
    parent.onKeyDown.listen((ev) {
      if (ev.keyCode == 27) {
        close();
      }
    });
  }

  Element parent;
  DivElement modal;
  DivElement div;
  bool open = false;
  bool closing = false;
  Viewer viewer;

  void close() async {
    if (!open || closing) return;
    modal.style.opacity = "0";
    closing = true;
    await Future.delayed(Duration(milliseconds: 200));
    modal.remove();
    modal = null;
    div = null;
    closing = false;
    open = false;
    viewer.close();
    viewer = null;
  }

  Future<void> showContent(GalleryContent content) {
    if (content is GalleryImage) {
      return show(ImageViewer(content));
    } else if (content is GalleryScene) {
      return show(SceneViewer(content));
    }
    throw "Unknown content '${content.runtimeType}'";
  }

  Future<void> show(Viewer viewer) async {
    if (open) return;

    modal = DivElement()
      ..id = "modal"
      ..onClick.listen((_) => close());

    div = DivElement()
      ..id = "modal-content";

    modal.children.add(div);
    parent.children.add(modal);

    open = true;
    await Future.delayed(Duration.zero);
    modal.style.opacity = "1";
    viewer.modal = this;
    this.viewer = viewer;
    await viewer.show();
  }
}

abstract class Viewer {
  Modal modal;
  Future<void> show();
  void close() {}
}