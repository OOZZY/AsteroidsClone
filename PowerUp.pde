class PowerUp extends MovingObject {
  boolean active = true;
  int type;

  // construct with given arguments
  PowerUp(PVector pos_) {
    super(pos_, new PVector(random(-1, 1), random(-1, 1)), new PVector(), 15);
    type = int(random(2));
  }

  void updateAfterHit(Player player) {
    if (type == 0) {
      player.projectileLevel++;
    } else if (type == 1) {
      player.health += player.fullHealth / 10;
      if (player.health > player.fullHealth) {
        player.health = player.fullHealth;
      }
    }
    active = false;
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
    if (type == 0) {
      fill(255, 255, 0);
    } else if (type == 1) {
      fill(0, 255, 0);
    }
    stroke(0);
    strokeWeight(1);
    ellipse(0, 0, radius * 2, radius * 2);
    popMatrix();
  }
}

