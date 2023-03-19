import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;
import processing.video.*;

OpenCV ocvL, ocvR;
PGraphics pgL, pgR;
PImage depth, texL;

boolean doStereoBM = false;

StereoSGBM stereoSGBM; // semi-global block matching
StereoBM stereoBM; // block matching
Mat left, right, disparity, depthMat;

void setup() {
  size(50, 50, P2D);
  setupCam();
     
  pgL = createGraphics(depthW, depthH, P2D);
  pgR = createGraphics(depthW, depthH, P2D);
  depth = createImage(depthW, depthH, RGB);
  
  setupShaders();

  ocvL = new OpenCV(this, pgL);
  ocvR = new OpenCV(this, pgR);
  
  /* https://docs.opencv.org/3.4/d1/d9f/classcv_1_1stereo_1_1StereoBinarySGBM.html
  1. int minDisparity : normally 0.
  2. int numDisparities : divisible by 16.
  3. int blockSize : odd, >=1, normally between 3 and 11.
  4. int P1 : first param for disparity method.
  5. int P2 : second param for disparity method, must be larger.
  6. int disp12MaxDiff : max pixels of disparity, -1 means no max.
  7. int preFilterCap : 
  8. int uniquenessRatio : normally between 5 and 15.
  9. int speckleWindowSize : noise filtering, 50-200, or 0 to disable.
  10. int speckleRange : normally 1 or 2.
  11. boolean mode : true enables MODE_HH (high quality), false is MODE_SGBM (low quality).
  */
  //stereoSGBM = StereoSGBM.create(0, 32, 3, 100, 1000, 1, 0, 5, 50, 2, 0); // OpenCV doc recs
  //stereoSGBM = StereoSGBM.create(0, 32, 3, 100, 1000, 1, 0, 5, 400, 200, 0); // OpenCV doc example
  //stereoSGBM = StereoSGBM.create(0, 32, 3, 128, 256, 20, 16, 1, 100, 20, 1); // Processing example
  stereoSGBM =  StereoSGBM.create(0, 32, 3, 100, 1000, -1, 32, 15, 200, 100, 1); // testing
  
  stereoBM = StereoBM.create();
}

void draw() {
  updateCam();

  pgL.beginDraw();
  pgL.image(tex.get(0,0,tex.width/2, tex.height), 0, 0, pgL.width, pgL.height);
  pgL.endDraw();
  ocvL.loadImage(pgL); // Left tex

  pgR.beginDraw();
  pgR.image(tex.get(tex.width/2,0,tex.width/2, tex.height), 0, 0, pgR.width, pgR.height);
  pgR.endDraw();
  ocvR.loadImage(pgR); // Right tex

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
  
  image(depth, 0, 0, width, height);
  
  surface.setTitle("" + frameRate);
}
