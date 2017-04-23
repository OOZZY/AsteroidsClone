/*
 * This class implements asteroids. Asteroids move and wrap around the screen.
 * They move faster in higher levels. Asteroids can be big or small. Big
 * asteroids spawn small asteroids when destroyed. Small asteroids disappear
 * when destroyed.
 */
class Asteroid extends MovingObject {
  int health = 10;
  boolean active = true;
  float angle = random(TWO_PI); // angle of rotation

  // construct big asteroid with given level
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

  // construct small asteroid with given position and level
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

  // returns whether this asteroid is a big one
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

  // update this asteroid
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

  // display this asteroid
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    scale(radius * 2 / asteroidImg.width, radius * 2 / asteroidImg.height);
    imageMode(CENTER);
    image(asteroidImg, 0, 0);
    popMatrix();
  }
}

