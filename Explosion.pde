/*
 * This class implements explosions. Explosions are created when asteroids and
 * enemies are destroyed.
 */
class Explosion {
  PVector pos; // position
  int frame = 0; // stores index of current frame to display
  boolean active = true;
  float angle = random(TWO_PI); // angle of rotation

  // construct explosion with given position
  Explosion(PVector pos_) {
    pos = pos_;
  }

  // update this explosion
  void update() {
    if (frame == NUM_EXPLOSION_FRAMES - 1) {
      active = false;
    }
    if (active) {
      frame++;
    }
  }

  // display this explosion
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle);
    imageMode(CENTER);
    image(explosionFrames[frame], 0, 0);
    popMatrix();
  }
}

