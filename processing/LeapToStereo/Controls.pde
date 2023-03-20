void keyPressed() {
  if (key == ' ') {
    showOrig = !showOrig;
  } else if (key == '1') {
    doStereoBM = true;
  } else if (key == '2') {
    doStereoBM = false;
    stereoSGBM = StereoSGBM.create(0, 32, 3, 100, 1000, 1, 0, 5, 50, 2, 0); // OpenCV doc recs
  } else if (key == '3') {
    doStereoBM = false;
    stereoSGBM = StereoSGBM.create(0, 32, 3, 100, 1000, 1, 0, 5, 400, 200, 0); // OpenCV doc example
  } else if (key == '4') {
    doStereoBM = false;
    stereoSGBM = StereoSGBM.create(0, 32, 3, 128, 256, 20, 16, 1, 100, 20, 1); // Processing example
  } else if (key == '5') {
    doStereoBM = false;
    stereoSGBM =  StereoSGBM.create(0, 32, 3, 100, 1000, -1, 32, 15, 200, 100, 1); // testing
  }
}
