Player player;

// stores all asteroids
ArrayList<Asteroid> asteroids = new ArrayList<Asteroid>();

// stores all enemies
ArrayList<Enemy> enemies = new ArrayList<Enemy>();

// variables to keep track of HUD data
int score = 0;
int asteroidsDestroyed = 0;
int enemiesDestroyed = 0;
int finalElapsedTime = 0;

// points rewarded
final int asteroidPoints = 10;
final int enemyPoints = 20;

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
  text("Score: " + score, 0, 0);
  text("Asteroids destroyed: " + asteroidsDestroyed, 0, 20);
  text("Enemies destroyed: " + enemiesDestroyed, 0, 40);
  if (!gameOver) {
    text("Time elapsed (s): " + millis() / 1000, 0, 60);
    text("Frame rate (fps): " + int(frameRate), 0, 80);
  } else {
    text("Time elapsed (s): " + finalElapsedTime, 0, 60);
  }
  text("player.projectiles.size(): " + player.projectiles.size(), 0, 100);
  text("asteroids.size(): " + asteroids.size(), 0, 120);
  text("enemies.size(): " + enemies.size(), 0, 140);
  popMatrix();
}

void setup() {
  size(600, 600);
  background(0);
  player = new Player();
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

  background(0);

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

  // spawn asteroid. limit number of asteroids active to 10
  if (asteroids.size() < 10 && random(0, 100) < 2) {
    asteroids.add(new Asteroid());
  }

  // spawn enemy. limit number of enemies active to 2
  if (enemies.size() < 2 && random(0, 100) < 1) {
    enemies.add(new Enemy());
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

  // remove inactive asteroids
  for (int i = 0; i < asteroids.size(); ++i) {
    Asteroid asteroid = asteroids.get(i);
    if (!asteroid.active) {
      asteroids.remove(i);
    }
  }

  // remove inactive enemies
  for (int i = 0; i < enemies.size(); ++i) {
    Enemy enemy = enemies.get(i);
    if (!enemy.active) {
      enemies.remove(i);
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
