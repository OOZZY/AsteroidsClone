/*
 * This class implements the background image. The background image scrolls left
 * and right repeatedly. It scrolls faster in higher levels.
 */
class Background {
  PImage img; // background image
  int x = 0; // horizontal offset from center
  int xVel = 1; // speed the background scrolls
  int xLimit; // stores limit of x variable

  // construct background
  Background() {
    img = loadImage("image/stars.png");
    xLimit = (img.width - width) / 2;
  }

  // update background
  void update() {
    x += xVel * level;
    if (x < -xLimit) {
      x = -xLimit;
      xVel *= -1;
    }
    if (x > xLimit) {
      x = xLimit;
      xVel *= -1;
    }
  }

  // display background
  void display() {
    pushMatrix();
    translate(width / 2, height / 2);
    imageMode(CENTER);
    image(img, x, 0);
    popMatrix();
  }
}

