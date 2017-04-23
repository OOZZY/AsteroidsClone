Player player;

// stores all asteroids
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

// stores all enemies
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

// stores all powerUps
ArrayList<PowerUp> powerUps = new ArrayList<PowerUp>();

// variables to keep track of HUD data
int score = 0;
int asteroidsDestroyed = 0;
int enemiesDestroyed = 0;
int finalElapsedTime = 0;
int level = 1;
int levelGoal = 1000;

// points rewarded
final int asteroidPoints = 10;
final int enemyPoints = 20;

// background image
PImage bgImage;

// boolean values that will be set to true/false when the corresponding key is
// pressed/released
boolean up, left, right, space;

// set boolean value to true if the corresponding key is pressed
void keyPressed() {
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

// set boolean value to false if the corresponding key is released
void keyReleased() {
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

void displayGameOverScreen() {
  background(0);
  textAlign(CENTER, CENTER);
  text("Game Over! Thank you for playing!", width/2, height/2);
  displayHUD(10, 20, true);
}

void displayHUD(float x, float y, boolean gameOver) {
  pushMatrix();
  translate(x, y);
  // display HUD data
  textAlign(LEFT, LEFT);
  fill(0, 255, 0);
  int yOffset = -20;
  text("Level: " + level, 0, yOffset += 20);
  text("Score: " + score, 0, yOffset += 20);
  text("Asteroids destroyed: " + asteroidsDestroyed, 0, yOffset += 20);
  text("Enemies destroyed: " + enemiesDestroyed, 0, yOffset += 20);
  if (!gameOver) {
    text("Time elapsed (s): " + millis() / 1000, 0, yOffset += 20);
    text("Frame rate (fps): " + int(frameRate), 0, yOffset += 20);
  } else {
    text("Time elapsed (s): " + finalElapsedTime, 0, yOffset += 20);
  }
  text("player.projectiles.size(): " + player.projectiles.size(), 0,
    yOffset += 20);
  text("player.projectileLevel: " + player.projectileLevel, 0, yOffset += 20);
  text("asteroids.size(): " + asteroids.size(), 0, yOffset += 20);
  text("enemies.size(): " + enemies.size(), 0, yOffset += 20);
  text("powerUps.size(): " + powerUps.size(), 0, yOffset += 20);
  popMatrix();
}

void setup() {
  size(600, 600);
  background(0);
  player = new Player();
  bgImage = loadImage("stars.png");
}

void draw() {
  // game over if player's health is <= 0
  if (player.health <= 0) {
    if (finalElapsedTime == 0) {
      finalElapsedTime = millis() / 1000; // calculate finalElapsedTime
    }
    displayGameOverScreen();
    return; // avoid executing the rest of this draw() method
  }

  imageMode(CENTER);
  image(bgImage, width / 2, height / 2);

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

  if (score >= levelGoal) {
    level++;
    levelGoal += levelGoal * 2;
  }

  // spawn asteroid. limit number of asteroids active to 10
  if (asteroids.size() < 10 && random(100) < 2) {
    asteroids.add(new Asteroid(level));
  }

  // spawn enemy. limit number of enemies active to 2
  if (enemies.size() < 2 && random(100) < 1) {
    enemies.add(new Enemy(level));
  }

  // make enemies shoot
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
        if (!asteroid.active) {
          score += asteroidPoints;
          asteroidsDestroyed++;
        }
        //sparks.add(new HitSpark(projectile.pos.get()));
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
        if (!enemy.active) {
          score += enemyPoints;
          enemiesDestroyed++;
        }
        //sparks.add(new HitSpark(projectile.pos.get()));
      }
    }
  }

  // check for collisions between player and asteroids
  for (int i = 0; i < asteroids.size(); ++i) {
    Asteroid asteroid = asteroids.get(i);
    if (player.collidingWith(asteroid) && asteroid.active) {
      player.updateAfterHit();
      asteroid.updateAfterHit();
      if (!asteroid.active) {
        score += asteroidPoints;
        asteroidsDestroyed++;
      }
      //sparks.add(new HitSpark(pos.get()));
    }
  }

  // check for collisions between player and enemies
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    if (player.collidingWith(enemy) && enemy.active) {
      player.updateAfterHit();
      enemy.updateAfterHit();
      if (!enemy.active) {
        score += enemyPoints;
        enemiesDestroyed++;
      }
      //sparks.add(new HitSpark(pos.get()));
    }
  }

  // check for collisions between player and powerUps
  for (int i = 0; i < powerUps.size(); ++i) {
    PowerUp powerUp = powerUps.get(i);
    if (player.collidingWith(powerUp) && powerUp.active) {
      powerUp.updateAfterHit(player);
    }
  }

  // remove inactive asteroids
  for (int i = 0; i < asteroids.size(); ++i) {
    Asteroid asteroid = asteroids.get(i);
    if (!asteroid.active) {
      // spawn smaller asteroid
      if (asteroid.big()) {
        asteroids.add(new Asteroid(asteroid.pos.get(), level));
        asteroids.add(new Asteroid(asteroid.pos.get(), level));
      }
      if (random(100) < 5) {
        powerUps.add(new PowerUp(asteroid.pos.get()));
      }
      asteroids.remove(i);
    }
  }

  // remove inactive enemies
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    if (!enemy.active) {
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

