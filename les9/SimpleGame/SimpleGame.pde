PImage back;
Char character;
Monster monster;

Surface[] surfaces;

void setup() {
  fullScreen();
  frameRate(60);
  back = loadImage("img/background.jpg", "jpg");
  back.resize(0, height);
  
  character = new Char(width - 50, 100);
  monster = new Monster(50, height - 300);
  
  surfaces = new Surface[] { 
    new FloatingIsland(width/2, height/2, 600, 10, 0, 0),
    //new FloatingIsland(width/2 + 200, height/2 - 100, 400, 10, -2, 2),
    //new FloatingIsland(width/2 + 200, height/2 - 100, 200, 10, -2, 4),
    //new FloatingIsland(width/2 + 200, height/2 - 100, 100, 10, 5, 2),
    new Cloud(width/2 + 200, height/2 - 400, 350, 10, -5, 2),
    new IslandYou(width/2 + 200, height/2 - 100, 400, 10, 0, 6),
    new CheetahIsland(width/2 + 200, height/2 - 100, 400, 10, 5, 2),
    new Surface(width/2, height - height/10, width * 4, height/3),
  };
}

void draw() {
  background(255);
  drawBackground(back);
  
  
  for (Surface surf : surfaces) {
    surf.update();
    surf.draw();
  }
  
  character.update();
  character.draw();
  
  monster.update();
  monster.draw();
}

void keyPressed() {
  character.move(keyCode);
}

void keyReleased() {
  character.stop(keyCode);
}
