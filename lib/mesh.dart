import 'dart:js';
import 'dart:web_gl';

import 'package:vector_math/vector_math_64.dart';
import 'package:w2019/gl.dart';

abstract class GLMaterial {
  late GLViewport ctx;
  late GLShader shader;
  void draw(GLViewport ctx);
}

class BasicMaterial extends GLMaterial {
  GLShader shader;
  Map<String, dynamic> uniforms;

  BasicMaterial(this.shader, {this.uniforms = const {}});

  draw(GLViewport ctx) {
    var gl = ctx.gl;
    gl.useProgram(shader.program);

    gl.uniformMatrix4fv(
        shader.uniforms['uPMatrix'], false, ctx.pMatrix.storage);
    gl.uniformMatrix4fv(
        shader.uniforms['uMVMatrix'], false, ctx.mvMatrix.storage);

    var tex = WebGL.TEXTURE0;
    for (var u in uniforms.keys) {
      var v = uniforms[u];
      if (!shader.uniforms.containsKey(u)) {
        // print("Warning: inactive uniform $u");
        continue;
      }
      if (v is Texture) {
        gl.activeTexture(tex);
        gl.bindTexture(WebGL.TEXTURE_2D, v);
        gl.uniform1i(shader.uniforms[u], 0);
        tex = tex + 1;
      } else if (v is double) {
        gl.uniform1f(shader.uniforms[u], v);
      } else if (v is Vector3) {
        gl.uniform3f(shader.uniforms[u], v.x, v.y, v.z);
      } else if (v is Vector4) {
        gl.uniform4f(shader.uniforms[u], v.x, v.y, v.z, v.w);
      } else if (v is Matrix3) {
        gl.uniformMatrix3fv(shader.uniforms[u], false, v.storage);
      } else if (v is Matrix4) {
        gl.uniformMatrix4fv(shader.uniforms[u], false, v.storage);
      } else
        throw "Unknown uniform type: '${v.runtimeType}'";
    }
  }
}

class MeshGLObject extends GLObject {
  JsObject obj;
  GLMaterial mat;

  MeshGLObject(this.obj, this.mat);

  Vector3 pos = Vector3.zero();
  Vector3 ang = Vector3.zero();
  Vector3 scale = Vector3(1, 1, 1);

  double tdt = 0.0;

  draw() {
    var gl = ctx.gl;
    var glJs = ctx.glJs;
    super.draw();

    ctx.mvPush();
    ctx.mvMatrix.translate(pos.x, pos.y, pos.z);
    ctx.mvMatrix.scale(scale.x, scale.y, scale.z);
    ctx.mvMatrix.rotateX(ang.x);
    ctx.mvMatrix.rotateZ(ang.y);
    ctx.mvMatrix.rotateZ(ang.z);

    mat.draw(ctx);

    (glJs["bindBuffer"] as JsFunction)
        .apply([WebGL.ARRAY_BUFFER, obj["vertexBuffer"]], thisArg: glJs);
    gl.vertexAttribPointer(mat.shader.attributes["aVertexPosition"]!,
        obj["vertexBuffer"]["itemSize"], WebGL.FLOAT, false, 0, 0);

    (glJs["bindBuffer"] as JsFunction)
        .apply([WebGL.ARRAY_BUFFER, obj["textureBuffer"]], thisArg: glJs);
    gl.vertexAttribPointer(mat.shader.attributes["aTexCoord"]!,
        obj["textureBuffer"]["itemSize"], WebGL.FLOAT, false, 0, 0);

    (glJs["bindBuffer"] as JsFunction)
        .apply([WebGL.ELEMENT_ARRAY_BUFFER, obj["indexBuffer"]], thisArg: glJs);
    gl.drawElements(WebGL.TRIANGLES, obj["indexBuffer"]["numItems"],
        WebGL.UNSIGNED_SHORT, 0);

    ctx.mvPop();
  }
}
