int WIDTH;
int HEIGHT;
int DIM=15;
int WDIM = DIM/2;
boolean move = false;
boolean start = true;
boolean support = true;
ArrayList<Point> trail = new ArrayList<Point>();
ArrayList<Point> snail = new ArrayList<Point>();
ArrayList<Point> ground = new ArrayList<Point>();
ArrayList<Point> shadow = new ArrayList<Point>();

Point apple = new Point(0, 7);

int snailSize = 4;
int position = 0;
int time = 0;
class Point {
  int x;
  int y;
  Point(int x, int y) {
    this.x = x;
    this.y = y;
  }
  @Override
    boolean equals(Object o) {
    if (o == null) {
      return false;
    }
    Point p2 = (Point)o;

    if (p2.x == this.x && p2.y == this.y) {
      return true;
    }
    return false;
  }
}

void setup() {
  //fullScreen();
  size(400, 800);
  WIDTH = width/WDIM;
  HEIGHT = height/DIM;
  createGround();
}

void createGround() {
  for (int i = 0; i < 5; i++) {
    ground.add(new Point(i+3, 7));
    ground.add(new Point(i+3, 8));
    ground.add(new Point(i+3, 9));
    ground.add(new Point(i+3, 10));
    ground.add(new Point(i, 11));
  }
}

void createSnail() {
  if (!trail.isEmpty()) {
    if (trail.size() > snailSize) {
      for (int i = 0; i < snailSize; i++) {
        snail.add(trail.get(i));
      }
      start = false;
    }
  }
}

void drawTrail() {
  for (Point p : trail) {
    //noStroke();
    fill(100, 230, 20, 50);
    rect(p.x*WIDTH, p.y*HEIGHT, WIDTH, HEIGHT);
  }
}

void drawGround() {
  for (Point p : ground) {
    fill(100, 230, 255, 50);
    rect(p.x*WIDTH, p.y*HEIGHT, WIDTH, HEIGHT);
  }
}

void draw() {
  background(#EBF8FA);
  appleCollision();
  if (start) {
    createSnail();
  } else {
    if (time++ % 5 == 0) {
      checkSupport();
      if (move && support) {
        move();
      } else if (!support) {
        gravity();
      }
    }
  }

  drawApple();
  drawTrail();
  drawGround();
  drawSnail();
}

void appleCollision() {
  if (snail.isEmpty())
    return;
  if (snail.get(snail.size()-1).equals(apple)) {
    snailSize++; 
    snail.add(new Point(apple.x, apple.y));
    apple = null;
  }
}

void drawApple() {
  if (apple!= null) {
    fill(200, 20, 20, 200);
    rect(apple.x*WIDTH, apple.y*HEIGHT, WIDTH, HEIGHT);
  }
}
void drawSnail() {
  for (Point s : snail) {
    fill(87, 111, 175);
    rect(s.x*WIDTH, s.y*HEIGHT, WIDTH, HEIGHT);
  }
}

void gravity() {
  if (!support) {
    for (Point p : snail) {
      p.y++;
    }
    for (Point t : trail) {
      if (!snail.contains(t)) {
        t.y++;
      }
    }
  }
}

void move() {
  removeInvalidTrail();
  if (support == true) {
    for (int i = position, j = 0; i < trail.size() && j < snail.size(); i++, j++) {
      snail.set(j, trail.get(i));
    }
    if (trail.size() - position > snail.size()) {
      position++;
    } else {
      position = 0;
      while (trail.size()> snail.size()) {
        trail.remove(0);
      }
    }
  } else {
    while (trail.size()> snail.size()) {
      trail.remove(0);
    }
  }
}

void removeInvalidTrail() {
  for (int i = 0; i < trail.size(); i++) {
    Point t = trail.get(i);
    for (Point g : ground) {
      if (t.equals(g)) {
        trail.clear();
      }
    }
  }
}

void checkSupport() {
  support = false;
  for (Point p : snail) {
    for (Point g : ground) {
      if (p.y + 1 == g.y && p.x == g.x) {
        support = true;
      }
    }
  }
}

void mouseDragged() {
  makeTrailFromMouse();
}

void mousePressed() {
  makeTrailFromMouse();
}

void makeTrailFromMouse() {
  boolean includeInTrail = true;
  if (!trail.isEmpty()) {
    if (isAlreadyAddedTrail()) {
      includeInTrail = false;
    } else {
      for (Point p : ground) {
        if (p.x == mouseX/WIDTH && p.y == mouseY/HEIGHT)
          includeInTrail = false;
      }
    }
    move =false;
  }
  addTrailPoints(includeInTrail);
}

boolean isAlreadyAddedTrail() {
  return trail.get(trail.size()-1).x== mouseX/WIDTH && trail.get(trail.size()-1).y == mouseY/HEIGHT;
}

void addTrailPoints(boolean includeInTrail) {
  if (includeInTrail) {
    if (trail.isEmpty() || isValidTrail()) {
      Point newTrailPoint = new Point(mouseX/WIDTH, mouseY/HEIGHT);
      trail.add(newTrailPoint);
    }
  }
}

boolean isValidTrail() {
  return (trail.get(trail.size()-1).x == mouseX/WIDTH || trail.get(trail.size()-1).y == mouseY/HEIGHT) && Math.abs(trail.get(trail.size()-1).y - mouseY/HEIGHT) <= 1 && Math.abs(trail.get(trail.size()-1).x - mouseX/WIDTH) <= 1 ;
}


boolean isValidNextMove() {
  return true;
}

void mouseReleased() {
  move = true;
}
