precision mediump float;
varying highp vec2 vTexCoord;
uniform sampler2D uMatColor;
uniform sampler2D uMatNorm;
uniform sampler2D uMatORM;
uniform highp mat4 uMVMatrix;
uniform highp mat4 uPMatrix;

void main(void) {
    gl_FragColor = texture2D(uMatColor, vec2(vTexCoord.x, vTexCoord.y));
}