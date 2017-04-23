/*
 * This class implements power-ups. Power-ups move and wrap around the screen.
 * power-ups can be an ammo boost or a health boost. Ammo boosts strengthen the
 * player's projectiles. Health boosts replenish the player's health. Power-ups
 * disappear when used.
 */
class PowerUp extends MovingObject {
  boolean active = true;

  final static int AMMO = 0;
  final static int HEALTH = 1;
  int type; // stores the type of power-up this is

  // construct with given position
  PowerUp(PVector pos_) {
    super(pos_, new PVector(random(-1, 1), random(-1, 1)), new PVector(), 15);
    type = int(random(2));
  }

  // updates to execute when given player collides with this power-up
  // updates given player
  void updateAfterHit(Player player) {
    if (type == AMMO) { // ammo boost
      player.projectileLevel++;
    } else if (type == HEALTH) { // health boost
      player.health += player.fullHealth / 10;

      // make sure player.health doesn't exceed maximum health
      if (player.health > player.fullHealth) {
        player.health = player.fullHealth;
      }
    }
    active = false;
  }

  // update this power-up
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

  // display this power-up
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    imageMode(CENTER);
    if (type == AMMO) { // ammo boost
      scale(radius * 2 / ammoImg.width, radius * 2 / ammoImg.height);
      image(ammoImg, 0, 0);
    } else if (type == HEALTH) { // health boost
      scale(radius * 2 / healthImg.width, radius * 2 / healthImg.height);
      image(healthImg, 0, 0);
    }
    popMatrix();
  }
}

