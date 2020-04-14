/* IPCapture sample sketch for Java and Android   *
 *                                                *
 * === IMPORTANT ===                              *
 * In Android mode, Remember to enable            *
 * INTERNET permissions in the                    *
 * Android -> Sketch permissions menu             */

import ipcapture.*;

IPCapture cam1, cam2;

void setup() {
  size(320,480);
  cam1 = new IPCapture(this, "http://195.235.198.107:3346/axis-cgi/mjpg/video.cgi?resolution=320x240", "", "");
  cam1.start();
  cam2 = new IPCapture(this, "http://195.235.198.107:3346/axis-cgi/mjpg/video.cgi?resolution=320x240", "", "");
  cam2.start();
  
  // this works as well:
  
  // cam = new IPCapture(this);
  // cam.start("url", "username", "password");
  
  // It is possible to change the MJPEG stream by calling stop()
  // on a running camera, and then start() it with the new
  // url, username and password.
}

void draw() {
  if (cam1.isAvailable()) {
    cam1.read();
    image(cam1,0,0);
  }
  if (cam2.isAvailable()) {
    cam2.read();
    image(cam2,0,height/2);
  }
}
