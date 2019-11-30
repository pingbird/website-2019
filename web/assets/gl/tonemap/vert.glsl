attribute vec4 aPos;
varying vec2 vTexCoord;

void main() {
    gl_Position = aPos - 0.5;
    vTexCoord = aPos.xy;
}