import de.voidplus.leapmotion.*;

/*
Leap Motion known values
800x800 @ 24fps
400x400 @ 85fps
*/

LeapMotion leap;
PGraphics tex;
int depthW = 640;
int depthH = 480;
  
void setupLeap() {
  leap = new LeapMotion(this);
  tex = createGraphics(depthW, depthH, P2D);
  setupShaders();
}

void updateLeap() {
  if (leap.hasImages()) {
    tex.beginDraw();
    
    for (Image camera : leap.getImages()) {
      if (camera.isLeft()) {
        // Left camera
        tex.image(camera, 0, 0);
      } else {
        // Right camera
        tex.image(camera, 0, camera.getHeight());
      }
    }
    
    tex.endDraw();
  }
    updateShaders();
}
