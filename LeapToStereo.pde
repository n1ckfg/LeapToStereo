import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;
import de.voidplus.leapmotion.*;

OpenCV ocvL, ocvR;
LeapMotion leap;
PGraphics imgL, imgR, imgD;
PImage depth;

boolean doStereoBM = false;

StereoSGBM stereoSGBM;
StereoBM stereoBM;
Mat left, right, disparity, depthMat;
int depthW = 640;
int depthH = 240;

void setup() {
  size(50, 50, P2D);
  surface.setSize(depthW, depthH*4);

  leap = new LeapMotion(this);    
  imgL = createGraphics(depthW, depthH, P2D);
  imgR = createGraphics(depthW, depthH, P2D);
  imgD = createGraphics(depthW, depthH, P2D);
  depth = createImage(depthW, depthH, RGB);
  
  setupShaders();

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
        shaderSetTexture(shader_thresh, "tex0", camera);
        imgL.filter(shader_thresh);
        imgL.endDraw();
        ocvL.loadImage(imgL); // Left camera
      } else {
        imgR.beginDraw();
        shaderSetTexture(shader_thresh, "tex0", camera);
        imgR.filter(shader_thresh);
        imgR.endDraw();
        ocvR.loadImage(imgR); // Right camera
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
  image(imgL, 0, 0, imgL.width, imgL.height*2);
  
  imgD.beginDraw();
  shaderSetTexture(shader_thresh2, "tex0", depth);
  shaderSetTexture(shader_thresh2, "tex1", imgL);
  imgD.filter(shader_thresh2);
  imgD.endDraw();
  
  image(imgD, 0, height/2, imgD.width, imgD.height*2);
  
  surface.setTitle("" + frameRate);
}

void keyPressed() {
  doStereoBM = !doStereoBM;
}
