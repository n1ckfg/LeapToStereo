#pragma once

#include "ofMain.h"
#include "ofxCv.h"
#include "ofxOpenCv.h"

using namespace ofxCv;
using namespace cv;

class ofApp : public ofBaseApp {
    
	public:
		void setup();
		void draw();
    
		ofImage ofImgL;
		ofImage ofImgR;
		Mat imgMatL;
		Mat imgMatR;
    
		Mat stereoMat;
		Mat stereoMat2;
    
};
