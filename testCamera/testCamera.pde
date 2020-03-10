PImage sunImage, earthImage, mercuryImage, galaxyImage, venusImage, marsImage, moonImage, jupiterImage;
PShape sun, earth, mercury, venus, mars, moon, jupiter, s;

float yaw = -180;
float pitch = 10;
PVector direction = new PVector();
PVector cameraPos = new PVector();
PVector shipPos = new PVector(0, 0, -600);
PVector up = new PVector(0, 1, 0);
int dist = 500;
float horizontalDistance;
float verticalDistance;

int planetSize = 50;
int moonSize = 10;
int sunSize = 100;
float ratioEarthMercury = 365.0 / 88.0;
float ratioEarthVenus = 365.0 / 224.7;
float ratioEarthMars = 365.0 / 687.0;
float ratioEarthMoon = 365 / 27.322; 
float ratioEarthJupiter = 1 / 11.8;
float baseRotation = 0.25;
float sunRotation = baseRotation;
float earthRotation = baseRotation;
float mercuryRotation = baseRotation * ratioEarthMercury;
float venusRotation = baseRotation * ratioEarthVenus;
float marsRotation = baseRotation * ratioEarthMars;
float moonRotation = baseRotation * ratioEarthMoon;
float jupiterRotation = baseRotation  * ratioEarthJupiter;
boolean isSpaceShipView;

boolean wPress = false, sPress = false, aPress = false, dPress = false;
boolean upPress = false, downPress = false, leftPress = false, rightPress = false;
float step = 5.0;
float angleStep = 1;
void settings(){
  size(1200, 800, P3D);
}

void setup(){  
  s = loadShape("spaceship.obj");
  upateShipVectors();
  loadImages();
  createShapes();
  addTextures();
  hideShapeStroke();
  textSize(30);
  textAlign(CENTER);
  isSpaceShipView = false;
  s.rotateX(radians(180));
  s.scale(0.1);
}

void createShapes(){
   moon = createShape(SPHERE, moonSize);
   earth = createShape(SPHERE, planetSize);
   mercury = createShape(SPHERE, planetSize);
   venus = createShape(SPHERE, planetSize);
   mars = createShape(SPHERE, planetSize);
   sun = createShape(SPHERE, sunSize);
   jupiter = createShape(SPHERE, planetSize);
}

void addTextures(){
   jupiter.setTexture(jupiterImage);
   moon.setTexture(moonImage);
   sun.setTexture(sunImage);
   earth.setTexture(earthImage);
   mercury.setTexture(mercuryImage);
   venus.setTexture(venusImage);
   mars.setTexture(marsImage);
}

void hideShapeStroke(){
   moon.setStroke(color(255, 0));
   mars.setStroke(color(255, 0));
   sun.setStroke(color(255, 0));
   earth.setStroke(color(255, 0));
   venus.setStroke(color(255, 0));
   mercury.setStroke(color(255, 0));
   jupiter.setStroke(color(255, 0));
}

void loadImages(){
   sunImage = loadImage("sun.jpg");
   earthImage = loadImage("earth.jpg");
   mercuryImage = loadImage("mercury.jpg");
   galaxyImage = loadImage("galaxy.jpg");
   galaxyImage.resize(width, height);
   venusImage = loadImage("venus.jpg");
   marsImage = loadImage("mars.jpg");
   moonImage = loadImage("moon.jpg");
   jupiterImage = loadImage("jupiter.jpg");
}

 public void showControls() {
  fill(255);
  textSize(16);
  text("WASD keys → Move SpaceShip", 140, 20);
  text("ARROWS keys → Rotate Space Ship", 140 ,40);
  text("ENTER → Toggle Views",140, 60);
  noFill();
}

void draw(){
  background(galaxyImage);
  if (!isSpaceShipView){
    showControls();
    camera();
  }else{
    updateCameraPosition();
    camera(
      cameraPos.x, cameraPos.y, cameraPos.z,
      shipPos.x, shipPos.y, shipPos.z,
      up.x, up.z, up.y);
    pushMatrix();
    translate(shipPos.x, shipPos.y, shipPos.z);
    shape(s);
    popMatrix();
  }
  
  drawStars();
}


void drawStars(){
  
  if (!isSpaceShipView){
    translate(width / 2, height / 2);
    rotateX(radians(45));
  }
  
  pushMatrix();
  rotateY(radians(sunRotation));
  shape(sun);
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(mercuryRotation));
  translate(0, -175);
  text("Mercury", 0, 0, planetSize);
  rotateY(radians(mercuryRotation));
  shape(mercury);
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(venusRotation));
  translate(0, -275);
  text("Venus", 0, 0, planetSize);
  rotateY(radians(venusRotation));
  shape(venus);
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(earthRotation));
  translate(0, -375);
  text("Earth", 0, 0, planetSize);
  rotateY(radians(earthRotation));
  shape(earth);
  rotateZ(radians(moonRotation));
  translate(0, -70);
  rotateX(radians(moonRotation));
  shape(moon);
  popMatrix();
  
  pushMatrix();
  rotateZ(radians(marsRotation));
  translate(0, -475);
  text("Mars", 0, 0, planetSize);
  rotateY(radians(marsRotation));
  shape(mars);
  popMatrix();
  
  
  pushMatrix();
  rotateZ(radians(jupiterRotation));
  translate(0, -575);
  text("Jupiter", 0, 0, planetSize);
  rotateY(radians(jupiterRotation));
  shape(jupiter);
  popMatrix();
  
  pushMatrix();
  stroke(255);
  circle(0, 0, 750);
  circle(0, 0, 350);
  circle(0, 0, 550);
  circle(0, 0, 950);
  circle(0, 0, 1150);
  noFill();
  rotateX(radians(90));
  popMatrix();
  
  updateRotateParams(); 
}

void updateRotateParams(){
  sunRotation += baseRotation;
  earthRotation += baseRotation;
  mercuryRotation += baseRotation * ratioEarthMercury;
  venusRotation += baseRotation * ratioEarthVenus;
  marsRotation += baseRotation * ratioEarthMars;
  moonRotation += baseRotation * ratioEarthMoon;
  jupiterRotation += baseRotation  * ratioEarthJupiter;
}

void upateShipVectors(){
  horizontalDistance = dist * cos(radians(pitch));
  verticalDistance = dist * sin(radians(pitch));
  cameraPos.y = shipPos.y + verticalDistance;
  cameraPos.x = shipPos.x + horizontalDistance * sin(radians(yaw));
  cameraPos.z = shipPos.z + horizontalDistance * cos(radians(yaw));
  direction.x = sin(radians(yaw)) * cos(radians(pitch));
  direction.z = cos(radians(yaw)) * cos(radians(pitch));
  direction.y = sin(radians(pitch));
  direction.normalize();
}

void updateCameraPosition(){
  if (wPress){
    shipPos.sub(PVector.mult(direction, step));
  }
  if (sPress){
    shipPos.add(PVector.mult(direction, step));
  }
  if (aPress){
    shipPos.x += step;
  }
  if (dPress){
    shipPos.x -= step;
  }
  if (upPress && pitch > -89.0 && pitch > 1){
    pitch = (pitch - angleStep) % 360;
    s.rotateX(-radians(angleStep));
  }
  if (downPress && pitch < 89.0){
    pitch = (pitch + angleStep) % 360;
    s.rotateX(radians(angleStep));
  }
  if (leftPress){
    yaw = (yaw - angleStep) % 360;
    s.rotateY(-radians(angleStep));
  }
  if (rightPress){
    yaw = (yaw + angleStep) % 360;
    s.rotateY(+radians(angleStep));
  }
  
  println(shipPos);
  upateShipVectors();
}

void keyPressed(){
  if (keyCode == ENTER){
    isSpaceShipView = !isSpaceShipView;
  }else if (key == 'w'){
    wPress = true;
  }else if (key == 's'){
    sPress = true;
  }else if (key == 'a'){
    aPress = true;
  }else if (key == 'd'){
    dPress = true;
  }else if (keyCode == UP){
    upPress = true;
  }else if (keyCode == DOWN){
    downPress = true;
  }else if (keyCode == LEFT){
    leftPress = true;
  }else if (keyCode == RIGHT){
    rightPress = true;
  }
}

void keyReleased(){
  if (key == 'w'){
    wPress = false;
  }else if (key == 's'){
    sPress = false;
  }else if (key == 'a'){
    aPress = false;
  }else if (key == 'd'){
    dPress = false;
  }else if (keyCode == UP){
    upPress = false;
  }else if (keyCode == DOWN){
    downPress = false;
  }else if (keyCode == LEFT){
    leftPress = false;
  }else if (keyCode == RIGHT){
    rightPress = false;
  }
}
