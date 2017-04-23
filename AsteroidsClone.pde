import ddf.minim.*;

// player object
Player player;

// stores all asteroids
ArrayList<Asteroid> asteroids;

// stores all enemies
ArrayList<Enemy> enemies;

// stores all powerUps
ArrayList<PowerUp> powerUps;

// stores all explosions
ArrayList<Explosion> explosions;

// variables to keep track of HUD data
int score;
int asteroidsDestroyed; // number asteroids destroyed
int enemiesDestroyed; // number enemies destroyed
int finalElapsedTime; // elapsed time calculated after game over
int level; // current level
int levelGoal; // score needed to reach next level

// points rewarded
final int asteroidPoints = 10;
final int enemyPoints = 20;

// background object
Background background;

// sounds
Minim minim = new Minim(this);
AudioPlayer shootSFX; // played when player/enemies shoot
AudioPlayer explosionSFX; // played when asteroids/enemies get hit
AudioPlayer collisionSFX; // played when player gets hit
AudioPlayer powerupSFX; // played when player picks powerUp

// images
final int NUM_EXPLOSION_FRAMES = 60; // number of explosion frames
PImage[] explosionFrames = new PImage[NUM_EXPLOSION_FRAMES]; // explosion frames
PImage asteroidImg;
PImage enemyImg;
PImage playerImg;
PImage healthImg; // health powerup image
PImage ammoImg; // ammo powerup image

// boolean values that will be set to true/false when the corresponding key is
// pressed/released
boolean up, left, right, space;

final int START_SCREEN = 0;
final int OVER_SCREEN = 1;
final int PLAY_SCREEN = 2;
int screenState = START_SCREEN; // keeps track of the screen's state

// starts game when in start screen or game over screen
void keyTyped() {
  if (screenState != PLAY_SCREEN) {
    if (int(key) == ENTER) {
      // set or reset global variables
      screenState = PLAY_SCREEN;
      player = new Player();
      asteroids = new ArrayList<Asteroid>();
      enemies = new ArrayList<Enemy>();
      powerUps = new ArrayList<PowerUp>();
      explosions = new ArrayList<Explosion>();
      score = 0;
      asteroidsDestroyed = 0;
      enemiesDestroyed = 0;
      finalElapsedTime = 0;
      level = 1;
      levelGoal = 1000;
      background.x = 0;
      background.xVel = 1;
      up = left = right = space = false;
      frameCount = 0;
    }
  }
}

// set boolean value to true if the corresponding key is pressed
void keyPressed() {
  if (screenState == PLAY_SCREEN) {
    if (key == CODED) {
      if (keyCode == UP) {
        up = true;
      } else if (keyCode == LEFT) {
        left = true;
      } else if (keyCode == RIGHT) {
        right = true;
      }
    } else if (key == ' ') {
      space = true;
    }
  }
}

// set boolean value to false if the corresponding key is released
void keyReleased() {
  if (screenState == PLAY_SCREEN) {
    if (key == CODED) {
      if (keyCode == UP) {
        up = false;
      } else if (keyCode == LEFT) {
        left = false;
      } else if (keyCode == RIGHT) {
        right = false;
      }
    } else if (key == ' ') {
      space = false;
    }
  }
}

// displays start screen
void displayStartScreen() {
  pushMatrix();
  translate(width/2, height/2);
  background(0);
  fill(0, 255, 0);
  textAlign(CENTER, CENTER);
  int i = -20;
  text("How to play:", 0, i += 20);
  text("Left and Right arrow keys: rotate left and right", 0, i += 20);
  text("Up arrow key: accelerate", 0, i += 20);
  text("Space: shoot", 0, i += 20);
  text("Pick up power-ups to boost ammo or replenish health", 0, i += 20);
  text("Shoot down all asteroids and enemies!", 0, i += 20);
  text("Get the highest score you can!", 0, i += 20);
  text("Press ENTER to play!", 0, i += 20);
  popMatrix();
}

// displays game over screen
void displayGameOverScreen() {
  pushMatrix();
  translate(width/2, height/2);
  background(0);
  fill(0, 255, 0);
  textAlign(CENTER, CENTER);
  int i = -20;
  text("Game Over! Thank you for playing!", 0, i += 20);
  text("How to play:", 0, i += 20);
  text("Left and Right arrow keys: rotate left and right", 0, i += 20);
  text("Up arrow key: accelerate", 0, i += 20);
  text("Space: shoot", 0, i += 20);
  text("Pick up power-ups to boost ammo or replenish health", 0, i += 20);
  text("Shoot down all asteroids and enemies!", 0, i += 20);
  text("Get the highest score you can!", 0, i += 20);
  text("Press ENTER to play again!", 0, i += 20);
  popMatrix();
  displayHUD(10, 20, true);
}

// displays HUD in given position. doesn't display frameRate when gameOver is
// true
void displayHUD(float x, float y, boolean gameOver) {
  pushMatrix();
  translate(x, y);
  // display HUD data
  fill(0, 255, 0);
  textAlign(LEFT, LEFT);
  int i = -20;
  text("Level: " + level, 0, i += 20);
  text("Score: " + score, 0, i += 20);
  text("Asteroids destroyed: " + asteroidsDestroyed, 0, i += 20);
  text("Enemies destroyed: " + enemiesDestroyed, 0, i += 20);
  if (!gameOver) {
    text("Time elapsed (s): " + frameCount / 60, 0, i += 20);
    text("Frame rate (fps): " + int(frameRate), 0, i += 20);
  } else {
    text("Time elapsed (s): " + finalElapsedTime, 0, i += 20);
  }
  /*
  // for debugging purposes:
  text("player.projectiles.size(): " + player.projectiles.size(), 0,
    i += 20);
  text("player.projectileLevel: " + player.projectileLevel, 0, i += 20);
  text("asteroids.size(): " + asteroids.size(), 0, i += 20);
  text("enemies.size(): " + enemies.size(), 0, i += 20);
  text("powerUps.size(): " + powerUps.size(), 0, i += 20);
  text("explosions.size(): " + explosions.size(), 0, i += 20);
  */
  popMatrix();
}

void setup() {
  size(600, 600);
  background(0);
  background = new Background(); // initialize background

  // load sounds
  shootSFX = minim.loadFile("sound/shoot.mp3");
  explosionSFX = minim.loadFile("sound/explosion.mp3");
  collisionSFX = minim.loadFile("sound/collision.mp3");
  powerupSFX = minim.loadFile("sound/powerup.mp3");

  // load explosion animation frames
  for (int i = 0; i < NUM_EXPLOSION_FRAMES; ++i) {
    explosionFrames[i]
      = loadImage("image/explosion/explosion1_00" + (i + 10) + ".png");
  }

  // load images
  asteroidImg = loadImage("image/asteroid.png");
  enemyImg = loadImage("image/enemy.png");
  playerImg = loadImage("image/player.png");
  healthImg = loadImage("image/health.png");
  ammoImg = loadImage("image/ammo.png");
}

void draw() {
  if (screenState == START_SCREEN) {
    displayStartScreen();
    return; // avoid executing the rest of this draw() method
  }

    if (screenState == OVER_SCREEN) {
    displayGameOverScreen();
    return; // avoid executing the rest of this draw() method
  }

  // game over if player's health is <= 0
  if (player.health <= 0) {
    screenState = OVER_SCREEN;
    if (finalElapsedTime == 0) {
      finalElapsedTime = millis() / 1000; // calculate finalElapsedTime
    }
    return; // avoid executing the rest of this draw() method
  }

  // update/display background
  background.update();
  background.display();

  // make player move/shoot based on boolean values set by keystrokes
  if (up) {
    player.move();
  }
  if (left) {
    player.rotateLeft();
  }
  if (right) {
    player.rotateRight();
  }
  if (space) {
    player.shoot();
    space = false;
  }

  // update level and levelGoal when current levelGoal is reached
  if (score >= levelGoal) {
    level++;
    levelGoal += levelGoal + levelGoal/2;
  }

  // spawn asteroid. limit number of asteroids active to 9+level
  if (asteroids.size() < 9+level && random(100) < 2) {
    asteroids.add(new Asteroid(level));
  }

  // spawn enemy. limit number of enemies active to 2
  if (enemies.size() < 2 && random(100) < 1) {
    enemies.add(new Enemy(level));
  }

  // make enemies shoot every 120 frames (2 seconds)
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    if (enemy.framesActive() % 120 == 0) {
      enemy.shoot();
    }
  }

  // check for collisions between enemy projectiles and player
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    for (int j = 0; j < enemy.projectiles.size(); ++j) {
      Projectile projectile = enemy.projectiles.get(j);
      if (projectile.collidingWith(player)) {
        projectile.updateAfterHit();
        player.updateAfterHit();
        collisionSFX.play();
        collisionSFX.rewind();
      }
    }
  }

  // check for collisions between player projectiles and asteroids
  for (int i = 0; i < player.projectiles.size(); ++i) {
    for (int j = 0; j < asteroids.size(); ++j) {
      Projectile projectile = player.projectiles.get(i);
      Asteroid asteroid = asteroids.get(j);
      if (projectile.collidingWith(asteroid) && asteroid.active) {
        projectile.updateAfterHit();
        asteroid.updateAfterHit();
      }
    }
  }

  // check for collisions between player projectiles and enemies
  for (int i = 0; i < player.projectiles.size(); ++i) {
    for (int j = 0; j < enemies.size(); ++j) {
      Projectile projectile = player.projectiles.get(i);
      Enemy enemy = enemies.get(j);
      if (projectile.collidingWith(enemy) && enemy.active) {
        projectile.updateAfterHit();
        enemy.updateAfterHit();
      }
    }
  }

  // check for collisions between player and asteroids
  for (int i = 0; i < asteroids.size(); ++i) {
    Asteroid asteroid = asteroids.get(i);
    if (player.collidingWith(asteroid) && asteroid.active) {
      player.updateAfterHit();
      asteroid.updateAfterHit();
      collisionSFX.play();
      collisionSFX.rewind();
    }
  }

  // check for collisions between player and enemies
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    if (player.collidingWith(enemy) && enemy.active) {
      player.updateAfterHit();
      enemy.updateAfterHit();
      collisionSFX.play();
      collisionSFX.rewind();
    }
  }

  // check for collisions between player and powerUps
  for (int i = 0; i < powerUps.size(); ++i) {
    PowerUp powerUp = powerUps.get(i);
    if (player.collidingWith(powerUp) && powerUp.active) {
      powerUp.updateAfterHit(player);
      powerupSFX.play();
      powerupSFX.rewind();
    }
  }

  // remove inactive asteroids
  for (int i = 0; i < asteroids.size(); ++i) {
    Asteroid asteroid = asteroids.get(i);
    if (!asteroid.active) {
      // update HUD
      score += asteroidPoints;
      asteroidsDestroyed++;

      explosionSFX.play();
      explosionSFX.rewind();
      explosions.add(new Explosion(asteroid.pos.get()));

      // drop power up
      if (random(100) < 5) {
        powerUps.add(new PowerUp(asteroid.pos.get()));
      }

      // spawn smaller asteroid
      if (asteroid.big()) {
        asteroids.add(new Asteroid(asteroid.pos.get(), level));
        asteroids.add(new Asteroid(asteroid.pos.get(), level));
      }

      asteroids.remove(i);
    }
  }

  // remove inactive enemies
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    if (!enemy.active) {
      // update HUD
      score += enemyPoints;
      enemiesDestroyed++;

      explosionSFX.play();
      explosionSFX.rewind();
      explosions.add(new Explosion(enemy.pos.get()));

      // drop power up
      if (random(100) < 5) {
        powerUps.add(new PowerUp(enemy.pos.get()));
      }

      enemies.remove(i);
    }
  }

  // remove inactive powerUps
  for (int i = 0; i < powerUps.size(); ++i) {
    PowerUp powerUp = powerUps.get(i);
    if (!powerUp.active) {
      powerUps.remove(i);
    }
  }

  // remove inactive explosions
  for (int i = 0; i < explosions.size(); ++i) {
    Explosion explosion = explosions.get(i);
    if (!explosion.active) {
      explosions.remove(i);
    }
  }

  // remove inactive enemy projectiles
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    for (int j = 0; j < enemy.projectiles.size(); ++j) {
      Projectile projectile = enemy.projectiles.get(j);
      if (!projectile.active) {
        enemy.projectiles.remove(j);
      }
    }
  }

  // remove inactive player projectiles
  for (int i = 0; i < player.projectiles.size(); ++i) {
    Projectile projectile = player.projectiles.get(i);
    if (!projectile.active) {
      player.projectiles.remove(i);
    }
  }

  // update/display asteroids
  for (int i = 0; i < asteroids.size(); ++i) {
    Asteroid asteroid = asteroids.get(i);
    asteroid.update();
    asteroid.display();
  }

  // update/display enemies
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    enemy.update();
    enemy.display();
  }

  // update/display powerUps
  for (int i = 0; i < powerUps.size(); ++i) {
    PowerUp powerUp = powerUps.get(i);
    powerUp.update();
    powerUp.display();
  }

  // update/display explosions
  for (int i = 0; i < explosions.size(); ++i) {
    Explosion explosion = explosions.get(i);
    explosion.update();
    explosion.display();
  }

  // update/display enemy projectiles
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    for (int j = 0; j < enemy.projectiles.size(); ++j) {
      Projectile projectile = enemy.projectiles.get(j);
      projectile.update();
      projectile.display();
    }
  }

  // update/display player projectiles
  for (int i = 0; i < player.projectiles.size(); ++i) {
    Projectile projectile = player.projectiles.get(i);
    projectile.update();
    projectile.display();
  }

  // update/display player and health
  player.update();
  player.display();
  player.displayHealth(10, height - 30);

  displayHUD(10, 20, false);
}

