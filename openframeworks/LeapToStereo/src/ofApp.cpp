#include "ofApp.h"

using namespace ofxCv;
using namespace cv;

//--------------------------------------------------------------
void ofApp::setup() {    
    ofImgL.load("left.png");
    ofImgR.load("right.png");
    
    ofImgR.setImageType(OF_IMAGE_GRAYSCALE); // you can also use cvtColor(src,dest,COLOR_BGR2GRAY);
    ofImgL.setImageType(OF_IMAGE_GRAYSCALE);
    
    imgMatL = toCv(ofImgL);
    imgMatR = toCv(ofImgR);
    
	cv::Ptr<cv::StereoBM> sbm = cv::StereoBM::create(112, 15); // initialize with NumDisparities, SADWindowSize
    //fiddle-able parameters
	sbm->setNumDisparities(112);
	sbm->setPreFilterSize(5);
	sbm->setPreFilterCap(1);
	sbm->setMinDisparity(-10);
	sbm->setTextureThreshold(5);
	sbm->setUniquenessRatio(5);
	sbm->setSpeckleWindowSize(40);
	sbm->setSpeckleRange(60);
	sbm->setDisp12MaxDiff(64);
    
    sbm->compute(imgMatL, imgMatR, stereoMat); // Calculate the diaparity and save into stereoMat
    
    normalize(stereoMat, stereoMat2, 0.1, 255, CV_MINMAX, CV_8U);
    
    // stereoMat is 16 bit signed -> stereoMat2 is 8 bit unsigned
    // important step, or else the values will be blown out when the image is drawn
    
    
}

//--------------------------------------------------------------
void ofApp::draw() {
    ofBackground(0);
    
    drawMat(stereoMat2, 50, 245);
    
    ofImgR.draw(  0,0, 320,240);
    ofImgL.draw(330,0, 320,240);  
}

