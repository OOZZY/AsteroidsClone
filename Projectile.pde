class Projectile extends MovingObject {
  boolean active = true;

  // construct with given arguments
  Projectile(PVector pos_, PVector vel_) {
    // acceleration: 0
    // radius: 4
    super(pos_, vel_, new PVector(), 4);
  }

  // returns whether this projectile is off the screen
  boolean offScreen() {
    return pos.x < 0 || pos.x > width || pos.y < 0 || pos.y > height;
  }

  void updateAfterHit() {
    active = false;
  }

  void update() {
    pos.add(vel);
    if (offScreen()) { active = false; }
  }

  void display() {
    if (active) {
      pushMatrix();
      translate(pos.x, pos.y);
      fill(255, 255, 0);
      ellipse(0, 0, radius * 2, radius * 2);
      popMatrix();
    }
  }
}

