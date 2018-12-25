PShader shader_thresh, shader_thresh2, shader_blur;

PVector shaderMousePos = new PVector(0,0);
PVector shaderMouseClick = new PVector(0,0);

void setupShaders() {
  shader_thresh = loadShader("thresh.glsl"); 
  shader_thresh2 = loadShader("thresh2.glsl"); 
  shader_blur = loadShader("blur.glsl"); 
  
  shaderSetSize(shader_thresh, depthW/depthScale, depthH/depthScale);
  shaderSetSize(shader_thresh2, depthW/depthScale, depthH/depthScale);
  
  shaderSetVar(shader_thresh, "threshold", 60);
  shaderSetVar(shader_thresh2, "threshold", 1);
  shader_blur.set("blurSize", 9);
  shader_blur.set("sigma", 5.0); 
}

void updateShaders() {
  //shaderSetMouse(shader);
  //shaderSetTime(shader);
  shaderSetTexture(shader_thresh, "tex0", pgL);
}

//void drawShaders() {
  //filter(shader);
//}

// ~ ~ ~ ~ ~ ~ ~

void shaderSetVar(PShader ps, String name, float val) {
    ps.set(name, val);
}

void shaderSetSize(PShader ps) {
  ps.set("iResolution", float(width), float(height), 1.0);
}

void shaderSetSize(PShader ps, float w, float h) {
  ps.set("iResolution", w, h, 1.0);
}

void shaderSetMouse(PShader ps) {
  if (mousePressed) shaderMousePos = new PVector(mouseX, height - mouseY);
  ps.set("iMouse", shaderMousePos.x, shaderMousePos.y, shaderMouseClick.x, shaderMouseClick.y);
}

void shaderSetTime(PShader ps) {
  ps.set("iGlobalTime", float(millis()) / 1000.0);
}

void shaderMousePressed() {
  shaderMouseClick = new PVector(mouseX, height - mouseY);
}

void shaderMouseReleased() {
  shaderMouseClick = new PVector(-shaderMouseClick.x, -shaderMouseClick.y);
}

void shaderSetTexture(PShader ps, String name, PImage tex) {
  ps.set(name, tex);
}
