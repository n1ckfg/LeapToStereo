boolean showTex = false;

void setup() {
  size(50, 50, P2D);
  
  setupCam();
  setupShaders();
}

void draw() {
  background(0);
  
  updateCam();
  
  if (showTex) {
    image(tex, 0, 0);
  } else {
    image(texL, 0, 0);
    image(texR, width/2, 0);
  }
  
  surface.setTitle("" + frameRate);
}
