import oscP5.*;
import netP5.*;

OscP5 oscp5;
int hue;
float bscale = 1;
float brotate = 0;
float offsetX = 0;
float offsetY = 0;

void setup() {
  background(128, 72, 10);
  size(400, 300);
  frame.setResizable(true);
  
  // Setup OscP5
  oscp5 = new OscP5(this, 12000); // Port on which you're listening
  oscp5.plug(this, "boxHue", "/boxHue");
  oscp5.plug(this, "boxScale", "/boxScale");
  oscp5.plug(this, "boxRotate", "/boxRotate");
  oscp5.plug(this, "boxOffset", "/boxOffset");
}

void drawbox(float dx, float dy) {
  pushMatrix();
  translate(dx, dy);
  scale(bscale);
  rotate(brotate);
  rect(0, 0, 30, 30);
  popMatrix();
}

void draw() {
  colorMode(HSB);
  stroke(129, 30, 30);
  strokeWeight(0.5);
  fill(hue, 200, 230);
  rectMode(CENTER);
  
  translate(width/2, height/2);
  translate(offsetX*width, offsetY*height);
  drawbox(0, 0);
}

void boxHue(float _hue) {
  hue = (int) map(_hue, 0, 1, 0, 256);
}

void boxScale(float _scale) {
  bscale = map(_scale, 0, 1, 1, 10);
}

void boxRotate(float _rot) {
  brotate = map(_rot, 0, 1, 0, TWO_PI);
}

void boxOffset(float ox, float oy) {
  offsetX = map(ox, 0, 1, -0.5, 0.5);
  offsetY = map(oy, 0, 1, -0.5, 0.5);
}
