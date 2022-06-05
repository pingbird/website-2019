attribute vec4 aPos;
uniform mat4 uMatrix;
varying vec2 vTexCoord;

void main() {
    gl_Position = uMatrix * (aPos - 0.5);
    vTexCoord = aPos.xy;
}