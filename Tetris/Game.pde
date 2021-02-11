int TICK_DURATION_DEFAULT = 500;
int TICK_DURATION_BOOSTED = 50;

int tick_duration = TICK_DURATION_DEFAULT;

class Game {
  Figure figure;
  color[][] field_colors;
  PVector size;
  float square_size;
  int timer;
  int[][] map;
  int state = 0;

  Game(int size_x, int size_y) {
    field_colors = new color[size_x][size_y];
    square_size = height / size_y;
    size = new PVector(size_x, size_y);

    map = new int[size_x][size_y];
    for (int i = 0; i < size_x; i++)
      for (int j = 0; j < size_y; j++)
        map[i][j] = 0;

    createFigureAt(int(size.x/2), -2);

    timer = millis();
  }

  void display() {
    switch (state) {
      case 0:
        draw_field();
        draw_dead_figures();
        figure.display();
        //draw_map();
      break;
        
      case 1:
        drawGameOverScreen();
        
      break;
    }
  }
  
  void draw_dead_figures() {
   for (int i = 0; i < size.x; ++i)
     for (int j = 0; j < size.y; ++j)
       if (map[i][j] == 1) {
         Square sq = new Square(width/2 - size.x * square_size/2 + square_size * i, square_size * j, square_size);
         sq.setColor(field_colors[i][j]);
         sq.display();
       }
  }
  
  void update() {
    if (millis() - timer >= tick_duration) {
      timer = millis();
      int respawn = moveFigure(0, 1);
      println(figure.pos.x, figure.pos.y, respawn);
      
      int gameover = 0;
      if (respawn == 1) {
        // функция figureToMap вернет 1, если фигура выходит за верхнюю границу поля
        gameover = figureToMap();
        // после того как создали фигуру, удалим заполненные строки поля
        respawnFigure();
        
        if (gameover == 1) {
          state = 1;
        }
      }
    }
  }
  
  void drawGameOverScreen() {
    noLoop();
      
    background(0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("ГАМОВЕР", width/2, height/2);
  }

  int figureToMap() {
    for (Square sq : figure.squares) {
      int new_x = (int)((sq.pos.x + figure.pos.x - width/2 + square_size * size.x/2) / square_size);
      int new_y = (int)((sq.pos.y + figure.pos.y)/ square_size);
      
      // Если упавшая фигура выходит за верхнюю границу, возвращаем 1
      // Такой случай обрабатываем как конец игры
      if (new_y < 0)
        return 1;
      
      map[new_x][new_y] = 1;
      field_colors[new_x][new_y] = figure.clr;
    }
    return 0;
  }

  void createFigureAt(int x, int y) {
    float _x = width/2 - square_size * size.x/2 + x * square_size;
    float _y = 0 + y * square_size;

    stroke(0, 255, 0);
    strokeWeight(10);
    point(_x, _y);

    int figure_type = (int)random(7);

    //==================
    // ДЛЯ ТЕСТА
    //==================
    // figure_type = 5;
    //==================
    switch (figure_type) {
      // I
      case 0:
        figure = new Figure('I', _x + 2 * square_size, _y + square_size, square_size);
      break;
      // J
      case 1:
        figure = new Figure('J', _x + 1.5 * square_size, _y + 1.5 * square_size, square_size);
      break;
      // L
      case 2:
        figure = new Figure('L', _x + 1.5 * square_size, _y + 1.5 * square_size, square_size);
      break;
      // O
      case 3:
        figure = new Figure('O', _x + square_size, _y + square_size, square_size);
      break;
      // S
      case 4:
        figure = new Figure('S', _x + 1.5 * square_size, _y + 1.5 * square_size, square_size);
      break;
      // T
      case 5:
        figure = new Figure('T', _x + 1.5 * square_size, _y + 1.5 * square_size, square_size);
      break;
      // Z
      case 6:
        figure = new Figure('Z', _x + 1.5 * square_size, _y + 1.5 * square_size, square_size);
      break;
    }
    
    color random_color = color((int)random(0, 255), (int)random(0, 255), (int)random(0, 255));
    figure.setColor(random_color);
  }

  void respawnFigure() {
    int random_x = 3 + (int)random(size.x - 6);
    createFigureAt(random_x, -2);
  }

  // Проверяет столкновение фигуры с окружением
  boolean checkFigureCollision() {
    for (Square sq : figure.squares) {
      // Вычисляем координаты фигуры на поле
      int new_x = (int)((sq.pos.x + figure.pos.x - width/2 + square_size * size.x/2) / square_size);
      int new_y = (int)((sq.pos.y + figure.pos.y)/ square_size);
      println(new_x, new_y);
      if (new_x >= size.x || new_x < 0)
          return true;
    }
    return false;
  }

  // Возвращает TRUE, если текущая фигура сталкивается с предыдущими фигурами
  // или нижней границей поля
  boolean checkBottom() {
    for (Square sq : figure.squares) {
      // Вычисляем координаты фигуры на поле
      int new_x = (int)((sq.pos.x + figure.pos.x - width/2 + square_size * size.x/2) / square_size);
      int new_y = (int)((sq.pos.y + figure.pos.y)/ square_size);

      // Проверка на нижнюю границу
      if (new_y >= size.y)
          return true;
    }
    return false;
  }

  boolean checkMap() {
    for (Square sq : figure.squares) {
      // Вычисляем координаты фигуры на поле
      int new_x = (int)((sq.pos.x + figure.pos.x - width/2 + square_size * size.x/2) / square_size);
      int new_y = (int)((sq.pos.y + figure.pos.y)/ square_size);

      // Проверка на столкновение с "мёртвыми" фигурами
      if (new_x >= 0 && new_x < size.x &&
          new_y >= 0 && new_y < size.y &&
          map[new_x][new_y] == 1)
        return true;
    }
    return false;
  }

  void keyPressed(char _key, int _keyCode) {
    if (_key == CODED) {
      switch (_keyCode) {
        case UP:
          rotateFigure();
        break;
        case DOWN:
          tick_duration = TICK_DURATION_BOOSTED;
        break;
        case RIGHT:
          moveFigure(1, 0);
        break;
        case LEFT:
          moveFigure(-1, 0);
        break;
      }
    }
  }

  void keyReleased(char _key, int _keyCode) {
    if (_key == CODED) {
      switch (_keyCode) {
        case DOWN:
          tick_duration = TICK_DURATION_DEFAULT;
        break;
      }
    }
  }

  int moveFigure(int dx, int dy) {
    float pdx = dx * square_size;
    float pdy = dy * square_size;

    PVector current_pos = figure.pos.copy();

    figure.move(pdx, pdy);

    int respawn = 0;
    if (checkBottom() || checkMap())
      respawn = 1;
    if (checkFigureCollision() || checkBottom() || checkMap()) {
      figure.setPosition(current_pos.x, current_pos.y);
    }

    return respawn;
  }

  void rotateFigure() {
    figure.rotate();
    if (checkFigureCollision())
        figure.rotateBack();
  }

  void draw_field() {
    // Рисуем рамку игрового поля
    float field_width = square_size * size.x;
    float right_border = width/2 + field_width/2;
    float left_border = width/2 - field_width/2;

    noFill();
    stroke(0);
    strokeWeight(5);
    rectMode(CENTER);
    rect(width/2, height/2, field_width, height);

    strokeWeight(1);

    // Рисуем вертикальные линии
    for (float i = left_border; i <= right_border; i += square_size) {
      line(i, 0, i, height);
    }

    // Рисуем горизонтальные линии
    for (float i = 0; i <= height; i += square_size) {
      line(left_border, i, right_border, i);
    }
  }

  void draw_map() {
    for (int i = 0; i < size.x; ++i) {
      for (int j = 0; j < size.y; ++j) {
        if (map[i][j] == 0) {
          noFill();
        }
        else if (map[i][j] == 1) {
          fill(0);
        }
        rectMode(CORNER);
        rect(width - 11 * square_size + i * square_size, j * square_size, square_size, square_size);
      }
    }

  }
}
