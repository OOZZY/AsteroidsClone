/*
 * This class implements enemies. Enemies move and wrap around the screen.
 * They move faster in higher levels. Enemies can shoot projectiles. They
 * disappear when destroyed.
 */
class Enemy extends MovingObject {
  int health = 10;
  boolean active = true;
  float angle = random(TWO_PI); // angle of rotation
  int spawnFrame; // stores frame this enemy was spawned

  // stores all of enemy's projectiles
  ArrayList<Projectile> projectiles;

  // construct enemy with given level
  Enemy(int level) {
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
    spawnFrame = frameCount;
    projectiles = new ArrayList<Projectile>();
  }

  // make enemy shoot
  void shoot() {
    projectiles.add(
      new Projectile(pos.get(), new PVector(16 * cos(angle), 16 * sin(angle)),
        1)
    );
    shootSFX.play();
    shootSFX.rewind();
  }

  // returns the number of frames this enemy was active
  int framesActive() {
    return frameCount - spawnFrame;
  }

  // updates to execute when this enemy is hit
  void updateAfterHit() {
    if (active) {
      health -= 10;
      if (health <= 0) { active = false; }
    }
  }

  // update this enemy
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

  // display this enemy
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle + HALF_PI);
    scale(radius * 2 / enemyImg.width, radius * 2 / enemyImg.height);
    imageMode(CENTER);
    image(enemyImg, 0, 0);
    popMatrix();
  }
}

