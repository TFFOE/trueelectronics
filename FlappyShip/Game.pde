class Game {
  int score;

  boolean paused = true;
  boolean gameover = false;

  Pu[] objects;
  Ship ship;

  PImage background;
  Game() {
    background = loadImage("img/background.png");
    background.resize(width, 0);

    ship = new Ship(200, height/2);
    objects = new Pu[]{
      new Pu(width, height/2),
      new Pu(width + width/3, height/2),
    };
    score = 0;
  }

  void update() {
    if (paused || gameover) return;

    for (GameObject obj : objects) {
      obj.update();
    }
    ship.update();

    pu_respawn();

    if (checkIfGameOver()) {
      gameover = true;
      return;
    }
  }

  void pu_respawn() {
    for (Pu obj : objects) {
      if (obj.pos.x + obj.image.width < 0) {
        obj.pos.x = width + width/6;
        obj.hole_radius = random(250, 500);
        obj.pos.y = random(height/6, height - height/6);
        score++;
      }
    }
  }

  void draw() {
    imageMode(CORNER);
    image(background, 0, 0);

    for (GameObject obj : objects) {
      obj.draw();
    }
    ship.draw();

    drawPlayerZone();

    fill(255);
    textSize(50);
    textAlign(RIGHT, TOP);
    text("Score: " + str(score) , width, 0);


    if (gameover) {
      drawGameOverScreen();
    }
    else if (paused) {
      drawPauseScreen();
    }
  }

  boolean checkIfGameOver() {
    if (ship.pos.y - ship.image.height/2 - 50 > height)
      return true;

    for (Pu obj : objects) {
      if (obj.check(ship))
        return true;
    }
    return false;
  }

  void keyPressedProcess(char _key, int _keyCode) {
    if (_key != CODED)
      switch (_key) {
        case 'P':
        case 'p':
          paused = true;
          break;

        case ' ':
          start();
          ship.jump();
          break;

        case 'f':
        case 'F':
          start();
          break;

        case 'A':
        case 'a':
          ship.setSpeedX(-10);
        break;

        case 'D':
        case 'd':
          ship.setSpeedX(10);
        break;
      }
    else
      switch (_keyCode) {
        case RIGHT:
          ship.setSpeedX(10);
        break;
        case LEFT:
          ship.setSpeedX(-10);
        break;
      }
  }

  void keyReleasedProcess(char _key, int _keyCode) {
    if (_key != CODED)
      switch (_key) {
        case 'A':
        case 'a':
          if (ship.speed.x < 0)
            ship.setSpeedX(0);
        break;
        case 'D':
        case 'd':
          if (ship.speed.x > 0)
            ship.setSpeedX(0);
        break;
      }
    else
      switch (_keyCode) {
        case RIGHT:
          if (ship.speed.x > 0)
            ship.setSpeedX(0);
        break;
        case LEFT:
          if (ship.speed.x < 0)
            ship.setSpeedX(0);
        break;
      }
  }

  void start() {
    if (gameover) {
      reset();
    }
    else if (paused)
    {
      paused = false;
    }
  }

  void reset() {
    score = 0;
    ship.moveTo(200, height/2);
    int x = width/6;
    for (Pu obj : objects) {
        obj.pos.x = width + x;
        x += width/3;
    }
    paused = true;
    gameover = false;


  }

  void drawPlayerZone() {
    strokeWeight(1);
    stroke(255, 255, 255, 60);
    line(400, 0, 400, height);
  }

  void togglePause() {
    paused = !paused;
  }

  void drawPauseScreen() {
    fill(0, 0, 0, 128);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);

    fill(255);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Game on pause. Press SPACE to continue...", width/2, height/2);
  }

  void drawGameOverScreen() {
    fill(128, 0, 0, 128);
    noStroke();
    rectMode(CORNER);
    rect(0, 0, width, height);

    fill(255);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("You lose! Press 'F' to restart.", width/2, height/2);
    text("Score: " + score, width/2, height/2 + 70);
  }

}
