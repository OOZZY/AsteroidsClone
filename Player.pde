/*
 * This class implements the player spaceship. The player can rotate left/right,
 * accelerate forward, and shoot projectiles. The game is over when the player's
 * health reaches 0. Only one object of this class is active at any given time.
 */
class Player extends MovingObject {
  static final int fullHealth = 200; // the maximum health player can have
  int health = fullHealth; // player's current health
  float angle = -HALF_PI; // angle of rotation. face up initially
  int projectileLevel = 1; // projectile's power level

  // stores all of player's projectiles
  ArrayList<Projectile> projectiles;

  // construct
  Player() {
    // position: center of the screen
    // velocity and acceleration: 0
    // radius: 20
    super(new PVector(width / 2, height / 2), new PVector(), new PVector(), 25);
    projectiles = new ArrayList<Projectile>();
  }

  // make this player shoot
  void shoot() {
    projectiles.add(
      new Projectile(pos.get(), new PVector(16 * cos(angle), 16 * sin(angle)),
        projectileLevel)
    );
    shootSFX.play();
    shootSFX.rewind();
  }

  // make player accelerate in direction of angle
  void move() {
    acc.add(new PVector(0.15 * cos(angle), 0.15 * sin(angle)));
  }

  // rotate this player left
  void rotateLeft() {
    angle -= 0.1;
  }

  // rotate this player right
  void rotateRight() {
    angle += 0.1;
  }

  // updates to execute when player is hit
  void updateAfterHit() {
    health -= 10;
  }

  // displays this player's health at given position. given position will be
  // upper-left corner of the health bar
  void displayHealth(float x, float y) {
    pushMatrix();
    translate(x, y);
    rectMode(CORNER);
    fill(255, 0, 0);
    rect(0, 0, fullHealth, 20);
    fill(0, 255, 0);
    rect(0, 0, health, 20);
    popMatrix();
  }

  // display player
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle + HALF_PI);
    scale(radius * 2 / playerImg.width, radius * 2 / playerImg.height);
    imageMode(CENTER);
    image(playerImg, 0, 0);
    popMatrix();
  }
}

