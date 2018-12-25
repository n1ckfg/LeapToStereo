import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;
import de.voidplus.leapmotion.*;

OpenCV ocvL, ocvR;
LeapMotion leap;
PGraphics imgL, imgR; 
PImage depth;

boolean doGrayscale = false;
boolean doInvert = false;
boolean doBlur = false;
boolean doStereoBM = false;
int blurType = 3; // 1 simple, 2 gaussian, 3 median, 4 bilateral
int blurParam = 33; // radius, should be odd
int depthScale = 1;

StereoSGBM stereoSGBM;
StereoBM stereoBM;
Mat left, right, disparity, depthMat;
int depthW = 640;
int depthH = 240;

void setup() {
  size(50, 50, P2D);
  surface.setSize(depthW*2, depthH*4);
  frameRate(120);
  
  leap = new LeapMotion(this);    
  imgL = createGraphics(int(depthW/depthScale), int(depthH/depthScale), P2D);
  imgR = createGraphics(int(depthW/depthScale), int(depthH/depthScale), P2D);
  depth = createImage(int(depthW/depthScale), int(depthH/depthScale), RGB);
  
  ocvL = new OpenCV(this, imgL);
  ocvR = new OpenCV(this, imgR);
  
  stereoSGBM =  new StereoSGBM(0, 32, 3, 128, 256, 20, 16, 1, 100, 20, true);
  stereoBM = new StereoBM();
}

void draw() {
  if (leap.hasImages()) {
    for (Image camera : leap.getImages()) {
      if (camera.isLeft()) {
        imgL.beginDraw();
        imgL.image(camera, 0, 0, imgL.width, imgL.height);
        imgL.endDraw();
        ocvL.loadImage(imgL); // Left camera
        if (doGrayscale) ocvL.gray();
        if (doBlur) ocvL.blur(blurType, blurParam);
      } else {
        imgR.beginDraw();
        imgR.image(camera, 0, 0, imgR.width, imgR.height);
        imgR.endDraw();
        ocvR.loadImage(imgR); // Right camera
        if (doGrayscale) ocvR.gray();
        if (doBlur) ocvR.blur(blurType, blurParam);
      }
    }
  }
  left = ocvL.getGray();
  right = ocvR.getGray();
  disparity = OpenCV.imitate(left);

  if (!doStereoBM) {
    stereoSGBM.compute(left, right, disparity );
  } else {
    stereoBM.compute(left, right, disparity );
  }
  
  depthMat = OpenCV.imitate(left);
  disparity.convertTo(depthMat, depthMat.type());
  
  ocvL.toPImage(depthMat, depth);
  if (doInvert) ocvL.invert();
  image(imgL, 0, 0, width, height/2);
  image(depth, 0, height/2, width, height);
  
  surface.setTitle("" + frameRate);
}

void keyPressed() {
  doStereoBM = !doStereoBM;
}
