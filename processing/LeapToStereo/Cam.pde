import processing.video.*;

/*
Leap Motion known values
800x800 @ 24fps
400x400 @ 85fps
*/

Capture cam;
String camString = "Leap Dev Kit";
String[] cameras;
PGraphics tex;
int depthW = 400;
int depthH = 400;
int depthFps = 85;
  
void setupCam() {
  cameras = Capture.list();

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    cam = new Capture(this, 640, 480);
  } else if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);

    // The camera can be initialized directly using an element
    // from the array returned by list():
    //cam = new Capture(this, cameras[0]);

    // Or, the camera name can be retrieved from the list (you need
    // to enter valid a width, height, and frame rate for the camera).
    cam = new Capture(this, depthW, depthH, camString, depthFps);
  }

  tex = createGraphics(depthW, depthH, P2D);
  setupShaders();
  cam.start();    
}

void updateCam() {
    if (cam.available() == true) {
    cam.read();
    updateShaders();
  }
  //image(cam, 0, 0);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  tex.beginDraw();
  //tex.filter(shader_yuv);
  tex.image(cam, 0, 0);
  tex.endDraw();
}
