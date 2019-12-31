import processing.video.*;

Capture cam;
String camString = "name=Leap Motion,size=800x800,fps=24";
//String camString = "name=HD Pro Webcam C920,size=640x360,fps=30";
boolean printCameraList = true;

void setupCam() {
  if (printCameraList) {
    String[] cameras = Capture.list();
    
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      if (printCameraList) {
        println("Available cameras:");
        for (int i = 0; i < cameras.length; i++) {
          println(i + ". " + cameras[i]);
        }
      }
    }
  }
    
  // The camera can be initialized directly using an 
  // element from the array returned by list():
  cam = new Capture(this, camString);
  int[] wh = getCamWidthHeight(camString);
  depthW = wh[0];
  depthH = wh[1];
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
  
  filter(shader_yuv);
}

int[] getCamWidthHeight(String s) {
  int w = 0;
  int h = 0;
  
  String s2 = s.split("size=")[1];
  String[] s3 = s2.split("x");
  w = parseInt(s3[0]);
  String s4 = s3[1].split(",")[0];
  h = parseInt(s4);

  println("parsed width and height: " + w + ", " + h);
  surface.setSize(w, h);

  int[] returns = { w, h };
  return returns;
}
