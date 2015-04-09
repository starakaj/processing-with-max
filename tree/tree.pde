/**
 * Tree 
 * 
 * Draws a tree using recursion and magic
 */

// Receive OSC from Max
import oscP5.*;
import netP5.*;
OscP5 oscp5;

// You will draw 2^depth branches. Don't make this number too large 
// or your frame rate will eat it
int depth = 9;
float len; // Length of a segment of the tree

// Each of these parameters can be set via OSC
float ang = 0.6;
float noz = 0.0;
float anoz = 0.0;
int hue = 0;
float sp = 0.01; // Probability that the saturation will take on a random value
float zoom = 1.0;
float rot = 0.0; // How much rotation
float da; // How fast the angle decays as it approaches the leaves
float lean; // 0 leans left, 1 leans right, 0.5 no lean

void setup() {
  size(400, 300);
  frame.setResizable(true);
  colorMode(HSB);
  
  // This connects OSC messages to functions in the Processing sketch
  oscp5 = new OscP5(this, 12000);
  oscp5.plug(this, "setAngle", "/setAngle");
  oscp5.plug(this, "setLengthNoise", "/setLengthNoise");
  oscp5.plug(this, "setAngleNoise", "/setAngleNoise");
  oscp5.plug(this, "setHue", "/setHue");
  oscp5.plug(this, "setSatProb", "/setSatProb");
  oscp5.plug(this, "setZoom", "/setZoom");
  oscp5.plug(this, "setRotation", "/setRotation");
  oscp5.plug(this, "setAngleDecay", "/setAngleDecay");
  oscp5.plug(this, "setLean", "/setLean");
}

void segmentHelper(float len, float ang, float da, int depth, int hue, int sat, int bri) {
  if (depth != 0) {
    pushMatrix();
    rotate(ang);
    
    // Add some noise to the length and angle
    float r = 1.0 + random(-noz, noz);
    len *= r;
    float ar = 1.0 + random(-anoz, anoz);
    ang *= ar;
    ang += lean;
    
    // With some probability, pick a random brightness and saturation
    if (random(0., 1.0) < sp) {
      sat = (int) random(0, 255);
      bri = (int) random(0, 255);
    }
    stroke(hue, sat, bri);
    line(0, 0, 0, (int)-len);
    translate(0, -len);
    
    // Left segment
    segmentHelper(len, -1.0*ang*da, da, depth-1, hue, sat, bri);
    
    // Right segment
    segmentHelper(len, ang*da, da, depth-1, hue, sat, bri);
    popMatrix();
  }
}

void drawTree(float len, float ang, float da, int depth, int hue, int sat, int bri) {
  line(0, 0, 0, (int)-len);
  pushMatrix();
  translate(0, -len);
  segmentHelper(len, -ang*da, da, depth, hue, sat, bri);
  segmentHelper(len, ang*da, da, depth, hue, sat, bri);
  popMatrix();
}

void draw() {
  fill(0, 12); // Using a value less than 255 for alpha makes each frame fade into the next
  rect(0, 0, width, height);
  translate(width/2.0, height/2.0);
  scale(zoom, zoom);
  rotate(rot);
  len = (min(width, height) / (depth * 3.0));
  drawTree(len, ang, da, depth, hue, 0, 12);
  rotate(PI);
  drawTree(len, ang, da, depth, hue, 0, 12);
}

/////////////////////////////// OSC Functions ///////////////////////////////////////////////

void setAngle(float a) {
  ang = map(a, 0.0, 1.0, 0.0, TWO_PI);
}

void setLengthNoise(float f) {
  noz = f;
}

void setAngleNoise(float f) {
  anoz = f;
}

void setZoom(float z) {
  zoom = map(z, 0.0, 1.0, 1.0, 10.0);
}

void setHue(float f) {
  hue = (int) map(f, 0.0, 1.0, 0, 255);
}

void setSatProb(float s) {
  sp = s;
}

void setRotation(float r) {
  rot = r * TWO_PI;
}

void setAngleDecay(float d) {
  float mm = map(d, 1.0, 0.0, 1.0, 10.0);
  da = log(mm)/log(10);
}

void setLean(float l) {
  lean = map(l, 0.0, 1.0, -1.0, 1.0);
}
