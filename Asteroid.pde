class Asteroid extends MovingObject {
  int health = 10;
  boolean active = true;

  Asteroid() {
    super(new PVector(), new PVector(), new PVector(), random(20, 30));
    int edge = int(random(4));
    switch (edge) {
      case 0: // enter from top edge
        pos = new PVector(random(width), 0);
        vel = new PVector(random(-1, 1), 1);
        break;
      case 1: // enter from bottom edge
        pos = new PVector(random(width), height);
        vel = new PVector(random(-1, 1), -1);
        break;
      case 2: // enter from left edge
        pos = new PVector(0, random(height));
        vel = new PVector(1, random(-1, 1));
        break;
      case 3: // enter from right edge
        pos = new PVector(width, random(height));
        vel = new PVector(-1, random(-1, 1));
        break;
      default:
    }
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
    fill(255, 0, 0);
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, radius * 2, radius * 2);
    popMatrix();
  }
}

