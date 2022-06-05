import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'package:vector_math/vector_math.dart';
import 'package:w2019/gl.dart';
import 'package:w2019/mesh.dart';
import 'package:w2019/modal.dart';

class SceneViewer extends Viewer {
  final GalleryScene scene;

  SceneViewer(this.scene);

  late GLApp app;

  show() async {
    var e = CanvasElement()
      ..id = "modal-image"
      ..style.width = "1024px"
      ..style.height = "768px"
      ..style.backgroundColor = scene.meta.color;

    modal.div!.children.add(e);

    app = GLApp(e);
    await app.init();

    var vp = app.viewport;

    var previewShader = await vp.loadShader(
        "/assets/gl/plainColor/vert.glsl", "/assets/gl/plainColor/frag.glsl");

    for (var m in scene.models) {
      var uniforms = <String, dynamic>{};

      var mat = BasicMaterial(
        previewShader,
        uniforms: uniforms,
      );

      if (m.vertShader != null && m.fragShader != null) {
        unawaited(vp.loadShader(m.vertShader!, m.fragShader!).then((s) async {
          for (var k in m.uniforms.keys) {
            var v = m.uniforms[k];
            if (v is String) {
              uniforms[k] = await vp.loadTexture(v);
            } else
              uniforms[k] = v;
          }
          mat.shader = s;
        }));
      }

      await app.addObject(MeshGLObject(
        await vp.loadObj(m.obj),
        mat,
      )
        ..pos = m.pos
        ..ang = m.ang
        ..scale = m.scale);
    }

    await app.addObject(GLFilter(
        vp,
        await vp.loadShader(
          "/assets/gl/tonemap/vert.glsl",
          "/assets/gl/tonemap/frag.glsl",
        )));

    app.start();

    e.style.opacity = "1";

    var cameraYaw = 0.0;
    var cameraPitch = 0.0;
    var cameraDist = 10.0;

    Point<num>? lastOffset;
    int? lastDt;

    var down = false;

    void updateCamera() {
      vp.cameraAng = Vector3(0.0, cameraPitch, cameraYaw);
      vp.cameraPos = Vector3(0, 0, -cameraDist);
      print(vp.cameraAng);
    }

    e.onMouseDown.listen((e) {
      lastOffset = e.offset;
      lastDt = DateTime.now().millisecondsSinceEpoch;
      down = true;
      e.stopPropagation();
      e.preventDefault();
    });

    e.onMouseMove.listen((e) {
      if (!down) return;

      var dt = DateTime.now().millisecondsSinceEpoch;

      lastOffset ??= e.offset;

      if (dt - lastDt! > 500 && (lastOffset! - e.offset).magnitude > 100) {
        lastOffset = e.offset;
      }

      cameraPitch = max(-pi / 2 + 0.1,
          min(pi / 2 - 0.1, cameraPitch + (e.offset.y - lastOffset!.y) * 0.01));
      cameraYaw += (e.offset.x - lastOffset!.x) * 0.01;
      updateCamera();

      lastOffset = e.offset;
    });

    e.onClick.listen((e) {
      e.preventDefault();
      e.stopPropagation();
    });

    window.onBlur.listen((e) {
      down = false;
    });

    e.onMouseUp.listen((e) {
      lastOffset = null;
      down = false;
      e.stopPropagation();
      e.preventDefault();
    });

    e.onWheel.listen((e) {
      cameraDist = min(80, max(5, cameraDist + e.deltaY * 0.05));

      updateCamera();

      e.stopPropagation();
      e.preventDefault();
    });

    updateCamera();
  }

  void close() {
    app.destroy();
  }
}
