PShader shader_stereo;
PImage img;

void setup() {
  size(640,480,P2D);
  img = loadImage("scene_l.jpg");
  shader_stereo = loadShader("stereo.glsl");
  //shader_stereo.set("iResolution", float(width), float(height), 1.0);
  //shader_stereo.set("tex0", img);
}

void draw() {
  filter(shader_stereo);
}
