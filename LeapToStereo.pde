import gab.opencv.*;
import org.opencv.core.Mat;
import org.opencv.calib3d.StereoBM;
import org.opencv.core.CvType;
import org.opencv.calib3d.StereoSGBM;
import de.voidplus.leapmotion.*;

OpenCV ocvL, ocvR;
LeapMotion leap;
PImage imgL, imgR, depth1, depth2;

void setup() {
  size(640, 240, P2D);
  leap = new LeapMotion(this);
}

void draw() {
  if (leap.hasImages()) {
    for (Image camera : leap.getImages()) {
      println(camera.getWidth() + " " + camera.getHeight());
      if (camera.isLeft()) {
        imgL = camera; // Left camera
      } else {
        imgR = camera; // Right camera
      }
    }
  }
  
  if (imgL != null && imgR != null) {
    ocvL = new OpenCV(this, imgL);
    ocvR = new OpenCV(this, imgR);
    ocvL.gray();
    ocvR.gray();
    
    Mat left = ocvL.getGray();
    Mat right = ocvR.getGray();
  
    Mat disparity = OpenCV.imitate(left);
  
    StereoSGBM stereo =  new StereoSGBM(0, 32, 3, 128, 256, 20, 16, 1, 100, 20, true);
    stereo.compute(left, right, disparity );
  
    Mat depthMat = OpenCV.imitate(left);
    disparity.convertTo(depthMat, depthMat.type());
  
    depth1 = createImage(depthMat.width(), depthMat.height(), RGB);
    ocvL.toPImage(depthMat, depth1);
  
    StereoBM stereo2 = new StereoBM();
    stereo2.compute(left, right, disparity );
    disparity.convertTo(depthMat, depthMat.type());
  
  
    depth2 = createImage(depthMat.width(), depthMat.height(), RGB);
    ocvL.toPImage(depthMat, depth2);
  
    image(depth1, 0, imgL.height);
    image(depth2, imgL.width, imgL.height);
  }
}
