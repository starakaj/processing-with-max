import oscP5.*;
import netP5.*;

OscP5 oscp5;

int fwidth = 800;
int fheight = 600;

float zoom = 1.0;
float rotation = 0;
float tX = 0.0;
float tY = 0.0;
int h = 0;
int s = 0;

PGraphics tex, bTex;

void setup() {
  oscp5 = new OscP5(this, 12000);
  oscp5.plug(this, "setZoom", "/setZoom");
  oscp5.plug(this, "setRotation", "/setRotation");
  oscp5.plug(this, "setTx", "/setTx");
  oscp5.plug(this, "setTy", "/setTy");
  oscp5.plug(this, "setHue", "/setHue");
  oscp5.plug(this, "setSaturation", "/setSaturation");
  
  size(fwidth, fheight, P2D);
  tex = createGraphics(fwidth, fheight, P2D);
  bTex = createGraphics(fwidth, fheight, P2D);
  
  background(0);
  bTex.beginDraw();
  bTex.endDraw();
}

void draw() {
  
  // Draw the new graphics onto tex
  tex.beginDraw();
  tex.background(0);
  
  // Draw the background tex back onto the main tex
  tex.image(bTex, 0, 0, fwidth, fheight);
  
  tex.noFill();
  tex.colorMode(HSB);
  tex.stroke(h, s, 200, 255);
  tex.strokeWeight(4);
  tex.rect(width/2.0 - 5, height/2.0 - 5, 10, 10);
  tex.endDraw();
  
  // Now draw tex onto the main screen
  image(tex, 0, 0, fwidth, fheight);
  
  // Transform and draw tex onto the background tex
  bTex.beginDraw();
  bTex.pushMatrix();
  bTex.translate(width/2.0, height/2.0);
  bTex.translate(tX, tY);
  bTex.scale(zoom);
  bTex.rotate(rotation);
  bTex.image(tex, -width/2.0, -height/2.0, fwidth, fheight);
  bTex.popMatrix();
  bTex.tint(255, 240);
  bTex.endDraw();
}

void setZoom(float z) {
  zoom = map(z, 0.0, 1.0, 1.0, 10.0);
}

void setRotation(float r) {
  rotation = r * TWO_PI;
}

void setTx(float x) {
  tX = map(x, 0.0, 1.0, 0.0, 20.0);
}

void setTy(float y) {
  tY = map(y, 0.0, 1.0, 0.0, 20.0);
}

void setHue(float f) {
  h = (int) map(f, 0.0, 1.0, 0, 255);
  println(h);
}

void setSaturation(float f) {
  s = (int) map(f, 0.0, 1.0, 0, 255);
}
