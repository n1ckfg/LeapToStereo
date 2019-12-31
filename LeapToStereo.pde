import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;
import processing.video.*;

OpenCV ocvL, ocvR;
PGraphics pgL, pgR, pgD;
PImage depth, camL;

boolean doStereoBM = false;
boolean maskInput = true;
boolean maskOutput = true;

StereoSGBM stereoSGBM; // semi-global block matching
StereoBM stereoBM; // block matching
Mat left, right, disparity, depthMat;
int depthW = 640;
int depthH = 240;
int depthScale = 2;

void setup() {
  size(50, 50, P2D);
  setupCam();
     
  pgL = createGraphics(depthW/depthScale, depthH/depthScale, P2D);
  pgR = createGraphics(depthW/depthScale, depthH/depthScale, P2D);
  pgD = createGraphics(depthW/depthScale, depthH/depthScale, P2D);
  depth = createImage(depthW/depthScale, depthH/depthScale, RGB);
  
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
  //stereoSGBM =  new StereoSGBM(0, 32, 3, 100, 1000, 1, 0, 5, 50, 2, false); // OpenCV doc recs
  stereoSGBM =  new StereoSGBM(0, 32, 3, 100, 1000, 1, 0, 5, 400, 200, false); // OpenCV doc example
  //stereoSGBM =  new StereoSGBM(0, 32, 3, 128, 256, 20, 16, 1, 100, 20, true); // Processing example
  
  stereoBM = new StereoBM();
}

void draw() {
  updateCam();

  pgL.beginDraw();
  if (maskInput) {
    shaderSetTexture(shader_thresh, "tex0", cam);
    pgL.filter(shader_thresh);
  } else {
    pgL.image(cam, 0, 0, pgL.width, pgL.height);
  }
  pgL.filter(shader_blur);
  pgL.endDraw();
  ocvL.loadImage(pgL); // Left camera

  pgR.beginDraw();
  if (maskInput) {
    shaderSetTexture(shader_thresh, "tex0", cam);
    pgR.filter(shader_thresh);
  } else {
    pgR.image(cam, 0, 0, pgR.width, pgR.height);
  }
  pgR.filter(shader_blur);
  pgR.endDraw();
  ocvR.loadImage(pgR); // Right camera

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
  image(cam, 0, 0, cam.width, cam.height*2);
  
  if (maskOutput) {
    pgD.beginDraw();
    shaderSetTexture(shader_thresh2, "tex0", depth);
    shaderSetTexture(shader_thresh2, "tex1", pgL);
    pgD.filter(shader_thresh2);
    pgD.endDraw();    
    image(pgD, 0, height/2, pgD.width * depthScale, pgD.height*2*depthScale);
  } else {
    image(depth, 0, height/2, pgD.width * depthScale, pgD.height*2*depthScale);
  }
  
  surface.setTitle("" + frameRate);
}

void keyPressed() {
  doStereoBM = !doStereoBM;
}
