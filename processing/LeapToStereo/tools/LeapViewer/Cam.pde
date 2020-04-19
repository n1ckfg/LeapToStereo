import processing.video.*;

Capture cam;
String camString = "name=Leap Motion,size=800x800,fps=24";
//String camString = "name=Leap Motion,size=400x400,fps=85";
boolean printCameraList = false;
PGraphics tex, texL, texR;

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
  tex = createGraphics(wh[0], wh[1], P2D);
  texL = createGraphics(wh[0], wh[1], P2D);
  texR = createGraphics(wh[0], wh[1], P2D);
  
  surface.setSize(wh[0]*2, wh[1]);
  
  cam.start();    
}

void updateCam() {
  if (cam.available() == true) {
    cam.read();
    //image(cam, 0, 0);
    // The following does the same, and is faster when just drawing the image
    // without any additional resizing, transformations, or tint.
    //set(0, 0, cam);
    updateShaders();
    
    tex.beginDraw();
    if (showTex) {
      tex.image(cam, 0, 0);
    } else {
      tex.filter(shader_yuv);
    }
    tex.endDraw();
    
    texL.beginDraw();
    texL.image(tex.get(0,0,tex.width/2, tex.height), 0, 0);
    texL.endDraw();
  
    texR.beginDraw();
    texR.image(tex.get(tex.width/2,0,tex.width/2, tex.height), 0, 0);
    texR.endDraw();
  }
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

  int[] returns = { w, h };
  return returns;
}
