float depth = 50;
float rotX = 0, rotY = 0;
float zoom = 1.5;
float roll = 0;
float crab = 0;
float ped = 0;
boolean wPressed = false, sPressed = false;
boolean aPressed = false, dPressed = false;
boolean qPressed = false, ePressed = false;
boolean jPressed = false, lPressed = false;
boolean iPressed = false, kPressed = false;
PVector lightPos = new PVector(0, 0, 300); // posisi sumber cahaya
boolean showStroke = false; // toggle untuk debugging
boolean useTexture = false;  // toggle tekstur
PImage tex;

void setup() {
  size(1000, 600, P3D);
  smooth(8);
  tex = loadImage("texture.jpg");
}

void draw() {
  background(220);
  ambientLight(80, 80, 80);
  pointLight(255, 255, 255, lightPos.x, lightPos.y, lightPos.z);
  translate(width / 2, height / 2, -100);
  scale(zoom);
  rotateX(rotX);
  rotateY(rotY);
  translate(crab, ped);
  rotateZ(roll);

  fill(255, 100, 100);
  if (showStroke) stroke(0);
  else noStroke();

  // Kontrol cahaya
  if (keyPressed) {
    if (keyCode == LEFT) lightPos.x -= 10;
    if (keyCode == RIGHT) lightPos.x += 10;
    if (keyCode == UP) lightPos.y -= 10;
    if (keyCode == DOWN) lightPos.y += 10;
    if (key == 'z') lightPos.z += 10;
    if (key == 'x') lightPos.z -= 10;
  }

  // F
  pushMatrix();
  drawLetterF();
  popMatrix();

  // N
  pushMatrix();
  drawLetterN();
  popMatrix();

  // D
  pushMatrix();
  translate(180, 0, 0);
  drawLetterD();
  popMatrix();

  // Rotasi
  if (wPressed) rotX -= 0.05;
  if (sPressed) rotX += 0.05;
  if (aPressed) rotY -= 0.05;
  if (dPressed) rotY += 0.05;
  if (qPressed) roll -= 0.05;
  if (ePressed) roll += 0.05;

  // Translasi
  if (jPressed) crab -= 2;
  if (lPressed) crab += 2;
  if (iPressed) ped -= 2;
  if (kPressed) ped += 2;
}

void drawLetterF() {
  ArrayList<PVector> leftlineF = new ArrayList<PVector>();
  leftlineF.add(new PVector(-220, 100));
  leftlineF.add(new PVector(-220, -100));
  leftlineF.add(new PVector(-185, -100));
  leftlineF.add(new PVector(-185, 100));
  extrudeShape(leftlineF, useTexture);

  ArrayList<PVector> horizontalF1 = new ArrayList<PVector>();
  horizontalF1.add(new PVector(-185, -65));
  horizontalF1.add(new PVector(-185, -100));
  horizontalF1.add(new PVector(-90, -100));
  horizontalF1.add(new PVector(-90, -65));
  extrudeShape(horizontalF1, useTexture);

  ArrayList<PVector> horizontalF2 = new ArrayList<PVector>();
  horizontalF2.add(new PVector(-185, 0));
  horizontalF2.add(new PVector(-185, -35));
  horizontalF2.add(new PVector(-110, -35));
  horizontalF2.add(new PVector(-110, 0));
  extrudeShape(horizontalF2, useTexture);
}

void drawLetterN() {
  ArrayList<PVector> leftLineN = new ArrayList<PVector>();
  leftLineN.add(new PVector(-70, 100));
  leftLineN.add(new PVector(-70, -100));
  leftLineN.add(new PVector(-35, -100));
  leftLineN.add(new PVector(-35, 100));
  extrudeShape(leftLineN, useTexture);

  ArrayList<PVector> diagonalN = new ArrayList<PVector>();
  diagonalN.add(new PVector(-35, -100));
  diagonalN.add(new PVector(-35, -30));
  diagonalN.add(new PVector(35, 100));
  diagonalN.add(new PVector(35, 30));
  extrudeShape(diagonalN, useTexture);

  ArrayList<PVector> rightLineN = new ArrayList<PVector>();
  rightLineN.add(new PVector(35, -100));
  rightLineN.add(new PVector(70, -100));
  rightLineN.add(new PVector(70, 100));
  rightLineN.add(new PVector(35, 100));
  extrudeShape(rightLineN, useTexture);
}

void drawLetterD() {
  ArrayList<PVector> outer = new ArrayList<PVector>();
  float barLeft = -80;
  float barRight = -45;
  float height = 100;
  float radius = 100;

  outer.add(new PVector(barLeft, -height));
  outer.add(new PVector(barLeft, height));
  outer.add(new PVector(barRight, height));
  outer.addAll(arcPoints(barRight, 0, radius, radians(90), radians(-90)));
  outer.add(new PVector(barRight, -height));

  ArrayList<PVector> hole = arcPoints(barLeft + 35, 0, 70, radians(90), radians(-90));

  textureMode(NORMAL);

  // Sisi depan
  beginShape();
  if (useTexture) texture(tex);
  for (int i = 0; i < outer.size(); i++) {
    PVector v = outer.get(i);
    float u = map(i, 0, outer.size() - 1, 0, 1);
    vertex(v.x, v.y, -depth/2, u, 0);
  }
  beginContour();
  for (int i = hole.size() - 1; i >= 0; i--) {
    PVector v = hole.get(i);
    float u = map(i, 0, hole.size() - 1, 1, 0);
    vertex(v.x, v.y, -depth/2, u, 1);
  }
  endContour();
  endShape(CLOSE);

  // Sisi belakang
  beginShape();
  if (useTexture) texture(tex);
  for (int i = outer.size() - 1; i >= 0; i--) {
    PVector v = outer.get(i);
    float u = map(i, 0, outer.size() - 1, 0, 1);
    vertex(v.x, v.y, depth/2, u, 0);
  }
  beginContour();
  for (PVector v : hole) {
    float u = map(hole.indexOf(v), 0, hole.size() - 1, 0, 1);
    vertex(v.x, v.y, depth/2, u, 1);
  }
  endContour();
  endShape(CLOSE);

  for (int i = 0; i < outer.size(); i++) {
    int next = (i + 1) % outer.size();
    drawQuad(outer.get(i), outer.get(next), -depth/2, depth/2, useTexture);
  }

  for (int i = 0; i < hole.size(); i++) {
    int next = (i + 1) % hole.size();
    drawQuad(hole.get(next), hole.get(i), -depth/2, depth/2, useTexture); // arah balik
  }
}

void extrudeShape(ArrayList<PVector> shape, boolean texEnabled) {
  // Sisi depan
  beginShape();
  if (texEnabled) texture(tex);
  for (PVector v : shape) {
    float u = map(shape.indexOf(v), 0, shape.size() - 1, 0, 1);
    if (texEnabled) vertex(v.x, v.y, -depth/2, u, 0);
    else vertex(v.x, v.y, -depth/2);
  }
  endShape(CLOSE);

  // Sisi belakang
  beginShape();
  if (texEnabled) texture(tex);
  for (int i = shape.size() - 1; i >= 0; i--) {
    PVector v = shape.get(i);
    float u = map(i, 0, shape.size() - 1, 0, 1);
    if (texEnabled) vertex(v.x, v.y, depth/2, u, 1);
    else vertex(v.x, v.y, depth/2);
  }
  endShape(CLOSE);

  // Samping
  for (int i = 0; i < shape.size(); i++) {
    int next = (i + 1) % shape.size();
    drawQuad(shape.get(i), shape.get(next), -depth/2, depth/2, texEnabled);
  }
}

void drawQuad(PVector a, PVector b, float z1, float z2, boolean texEnabled) {
  beginShape(QUADS);
  if (texEnabled) texture(tex);
  if (texEnabled) {
    vertex(a.x, a.y, z1, 0, 0);
    vertex(b.x, b.y, z1, 1, 0);
    vertex(b.x, b.y, z2, 1, 1);
    vertex(a.x, a.y, z2, 0, 1);
  } else {
    vertex(a.x, a.y, z1);
    vertex(b.x, b.y, z1);
    vertex(b.x, b.y, z2);
    vertex(a.x, a.y, z2);
  }
  endShape();
}

ArrayList<PVector> arcPoints(float cx, float cy, float r, float startAngle, float endAngle) {
  ArrayList<PVector> points = new ArrayList<PVector>();
  int detail = 60;
  if (endAngle < startAngle) {
    float tmp = startAngle;
    startAngle = endAngle;
    endAngle = tmp;
  }
  for (int i = 0; i <= detail; i++) {
    float t = map(i, 0, detail, startAngle, endAngle);
    float x = cx + cos(t) * r;
    float y = cy + sin(t) * r;
    points.add(new PVector(x, y));
  }
  return points;
}

void keyPressed() {
  if (key == 'w') wPressed = true;
  if (key == 's') sPressed = true;
  if (key == 'a') aPressed = true;
  if (key == 'd') dPressed = true;
  if (key == 'q') qPressed = true;
  if (key == 'e') ePressed = true;
  if (key == 'j') jPressed = true;
  if (key == 'l') lPressed = true;
  if (key == 'i') iPressed = true;
  if (key == 'k') kPressed = true;
  if (key == '+') zoom += 0.1;
  if (key == '-') zoom -= 0.1;
  if (key == 't') showStroke = !showStroke;
  if (key == 'p') useTexture = !useTexture;
}

void keyReleased() {
  if (key == 'w') wPressed = false;
  if (key == 's') sPressed = false;
  if (key == 'a') aPressed = false;
  if (key == 'd') dPressed = false;
  if (key == 'q') qPressed = false;
  if (key == 'e') ePressed = false;
  if (key == 'j') jPressed = false;
  if (key == 'l') lPressed = false;
  if (key == 'i') iPressed = false;
  if (key == 'k') kPressed = false;
}
