class Player extends MovingObject {
  static final int fullHealth = 200;
  int health = fullHealth;
  float angle = -HALF_PI; // angle of rotation. face up initially

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

  void shoot() {
    projectiles.add(
      new Projectile(pos.get(), new PVector(16 * cos(angle), 16 * sin(angle)))
    );
  }

  // make player accelerate in direction of angle
  void move() {
    acc.add(new PVector(0.15 * cos(angle), 0.15 * sin(angle)));
  }

  void rotateLeft() {
    angle -= 0.1;
  }

  void rotateRight() {
    angle += 0.1;
  }

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

  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(angle + HALF_PI);
    scale(radius * 2 / 150, radius * 2 / 200);

    // tip
    stroke(0);
    strokeWeight(2);
    line(0, 0, 0, -100);

    // thrusters
    fill(255, 255, 0);
    ellipse(0, 80, 15, 40);
    ellipse(-64, 60, 12, 40);
    ellipse(64, 60, 12, 40);

    // wing rect
    fill(150, 150, 255);
    rectMode(CENTER);
    rect(45, 50, 60, 10);
    rect(-45, 50, 60, 10);

    // wing quad
    fill(255, 200, 200);
    quad(-75, 55, -75, -20, -65, 30, -50, 55);
    quad(75, 55, 75, -20, 65, 30, 50, 55);

    // tail
    triangle(-25, 95, 0, 0, 25, 25);
    triangle(25, 95, 0, 0, -25, 25);

    // body
    fill(200, 200, 255);
    ellipse(0, -10, 75, 140);

    // center line
    line(0, -30, 0, 60);

    // front viewport
    fill(100);
    quad(-25, -40, -10, -70, 10, -70, 25, -40);

    popMatrix();
  }
}

