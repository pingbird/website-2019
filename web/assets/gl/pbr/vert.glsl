attribute vec3 aVertexPosition;
attribute vec3 aVertexNormal;
attribute vec2 aTexCoord;
uniform highp mat4 uMVMatrix;
uniform highp mat4 uPMatrix;
varying highp vec2 vTexCoord;

void main(void) {
    vec4 worldPos = uMVMatrix * vec4(aVertexPosition, 1.0);
    gl_Position = uPMatrix * worldPos;
    vTexCoord = aTexCoord;
}