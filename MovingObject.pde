/*
 * This class implements moving objects. It is designed to be a superclass. It
 * provides basic movement/physics and collision detection to subclasses.
 */
class MovingObject {
  static final float DAMP = 0.98; // dampening factor

  PVector pos, vel, acc; // position, velocity, acceleration
  float radius;

  // construct with given arguments
  MovingObject(PVector pos_, PVector vel_, PVector acc_, float radius_) {
    pos = pos_;
    vel = vel_;
    acc = acc_;
    radius = radius_;
  }

  // returns whether this MovingObject is colliding with other
  boolean collidingWith(MovingObject other) {
    if (PVector.dist(pos, other.pos) < radius + other.radius) {
      return true;
    }
    return false;
  }

  void update() {
    vel.add(acc); // update velocity
    vel.mult(DAMP); // dampen velocity
    pos.add(vel); // update position
    acc.mult(0); // clear acceleration

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
}

