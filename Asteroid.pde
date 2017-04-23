class Asteroid extends MovingObject {
  int health = 10;
  boolean active = true;
  float angle = random(TWO_PI); // angle of rotation
  PImage img = loadImage("meteor.png"); // image

  // construct big asteroid
  Asteroid(int level) {
    super(new PVector(), new PVector(), new PVector(), random(20, 30));
    int edge = int(random(4));
    switch (edge) {
      case 0: // enter from top edge
        pos = new PVector(random(width), 0);
        vel = new PVector(random(-level, level), level);
        break;
      case 1: // enter from bottom edge
        pos = new PVector(random(width), height);
        vel = new PVector(random(-level, level), -level);
        break;
      case 2: // enter from left edge
        pos = new PVector(0, random(height));
        vel = new PVector(level, random(-level, level));
        break;
      case 3: // enter from right edge
        pos = new PVector(width, random(height));
        vel = new PVector(-level, random(-level, level));
        break;
      default:
    }
  }

  // construct small asteroid
  Asteroid(PVector pos_, int level) {
    super(pos_, new PVector(), new PVector(), random(10, 15));
    int edge = int(random(4));
    switch (edge) {
      case 0: // enter from top edge
        vel = new PVector(random(-level, level), level);
        break;
      case 1: // enter from bottom edge
        vel = new PVector(random(-level, level), -level);
        break;
      case 2: // enter from left edge
        vel = new PVector(level, random(-level, level));
        break;
      case 3: // enter from right edge
        vel = new PVector(-level, random(-level, level));
        break;
      default:
    }
  }

  boolean big() {
    return radius >= 20;
  }

  // updates to execute when this asteroid is hit
  void updateAfterHit() {
    if (active) {
      health -= 10;
      if (health <= 0) { active = false; }
    }
  }

  void update() {
    pos.add(vel); // update position

    // wrap around edges of the screen
    if (pos.x < 0) {
      pos.x = width;
    }
    if (pos.x > width) {
      pos.x = 0;
    }
    if (pos.y < 0) {
      pos.y = height;
    }
    if (pos.y > height) {
      pos.y = 0;
    }
  }

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    scale(radius * 2 / img.width, radius * 2 / img.height);
    imageMode(CENTER);
    image(img, 0, 0);
    popMatrix();
  }
}

