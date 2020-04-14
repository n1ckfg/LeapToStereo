#pragma once

#include "ofMain.h"
#include "ofxCv.h"
#include "ofxOpenCv.h"

using namespace ofxCv;
using namespace cv;

class ofApp : public ofBaseApp {
    
	public:
		void setup();
		void update();
		void draw();
		void calculateStereo();

		cv::Ptr<cv::StereoBM> sbm;

		ofImage frame, imgL, imgR;
		Mat imgMatL, imgMatR;   
		Mat stereoMat, stereoMat2;
		ofFbo fbo1, fbo2;

		ofVideoGrabber cam;
		int camWidth = 400;
		int camHeight = 400;
		int deviceId = 0;
		int fps = 60;

};
