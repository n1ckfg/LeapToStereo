#include "ofApp.h"

using namespace ofxCv;
using namespace cv;

//--------------------------------------------------------------
void ofApp::setup() {   
	sbm = cv::StereoBM::create(112, 15); // initialize with NumDisparities, SADWindowSize
	// Creative Inquiry example fiddle-able parameters
	sbm->setNumDisparities(112);
	sbm->setPreFilterSize(5);
	sbm->setPreFilterCap(1);
	sbm->setMinDisparity(-10); // -10
	sbm->setTextureThreshold(5);
	sbm->setUniquenessRatio(5);
	sbm->setSpeckleWindowSize(200); // 40
	sbm->setSpeckleRange(60); // 60
	sbm->setDisp12MaxDiff(64); // 64

	frame.allocate(camWidth, camHeight, OF_IMAGE_COLOR);
	imgL.allocate(camWidth / 2, camHeight, OF_IMAGE_GRAYSCALE);
	imgR.allocate(camWidth / 2, camHeight, OF_IMAGE_GRAYSCALE);
	fbo1.allocate(camWidth / 4, camHeight, GL_RGB);
	fbo2.allocate(camWidth / 2, camHeight, GL_RGB);

	// ~ ~ ~ ~ ~ ~
  
	//get back a list of devices.
	vector<ofVideoDevice> devices = cam.listDevices();

	for (size_t i = 0; i < devices.size(); i++) {
		if (devices[i].bAvailable) {
			//log the device
			ofLogNotice() << devices[i].id << ": " << devices[i].deviceName;
		} else {
			//log the device and note it as unavailable
			ofLogNotice() << devices[i].id << ": " << devices[i].deviceName << " - unavailable ";
		}
	}

	cam.setDeviceID(deviceId);
	cam.setDesiredFrameRate(fps);
	cam.initGrabber(camWidth, camHeight);    
}

//--------------------------------------------------------------
void ofApp::update() {
	cam.update();

	if (cam.isFrameNew()) {
		frame.setFromPixels(cam.getPixels());
		frame.setImageType(OF_IMAGE_GRAYSCALE);
		imgL.cropFrom(frame, 0, 0, camWidth / 2, camHeight);
		imgR.cropFrom(frame, camWidth / 2, 0, camWidth / 2, camHeight);

		calculateStereo();
	}
}

void ofApp::draw() {
	ofBackground(50);

	imgL.draw(0, 0, camWidth, camHeight);
	imgR.draw(camWidth, 0, camWidth, camHeight);

	fbo1.begin();
	ofBackground(0, 0, 255);
	drawMat(stereoMat2, -fbo1.getWidth(), 0);
	fbo1.end();

	fbo2.begin();
	ofBackground(255, 0, 0);
	fbo1.draw(0, 0, fbo2.getWidth(), fbo2.getHeight());
	fbo2.end();

	fbo2.draw(camWidth - fbo1.getWidth(), camHeight);
}

void ofApp::calculateStereo() {
	imgMatL = toCv(imgL);
	imgMatR = toCv(imgR);

	sbm->compute(imgMatL, imgMatR, stereoMat); // Calculate the diaparity and save into stereoMat
	normalize(stereoMat, stereoMat2, 0.1, 255, CV_MINMAX, CV_8U);
	// stereoMat is 16 bit signed -> stereoMat2 is 8 bit unsigned
	// important step, or else the values will be blown out when the image is drawn
}