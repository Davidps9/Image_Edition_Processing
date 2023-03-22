LazyGui gui;
PImage img;

int MitArm;
boolean Inverted, IsInverted =false;
boolean Mitjana, IsMitjanaApplied =false;
int [][] Matrix = new int [3][3];


void settings() {
  img = loadImage("wp.png");
  size(img.width, img.height, P2D);
}
void setup() {

  gui = new LazyGui(this);
}

void draw() {
  image(img, 0, 0);


  gui.pushFolder("Handmade_Photoshop");

  //Invert Image
  Inverted = gui.toggle("Invert Colors", false);
  if (Inverted != IsInverted) {
    invertImg();
  }


  MitArm = (int)gui.slider("Valor de la mitjana aritmetica", 0, -10, 10);
  Mitjana = gui.toggle("Aplicar Mitjana", false);
  if (Mitjana != IsMitjanaApplied) {
    ApplyMitjanaToImg();
  }

  gui.popFolder();

  showPixelInfo(mouseX, mouseY);
}
void invertImg() {
  color c;
  color newc;

  loadPixels();

  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {

      c = img.get(x, y);
      newc = invertColor(c);
      img.set(x, y, newc);
    }
  }

  updatePixels();
  IsInverted = !IsInverted ;
}

color invertColor(color c) {
  float newc_red = map(red(c), 0, 255, 255, 0);
  float newc_green =  map(green(c), 0, 255, 255, 0);
  float newc_blue =  map(blue(c), 0, 255, 255, 0);
  return color(newc_red, newc_green, newc_blue);
}


void ApplyMitjanaToImg() {
  int result;

  for (int x=0; x<3; x++) {
    for (int y=0; y<3; y++) {

      Matrix[x][y]=MitArm;
    }
  }
  loadPixels();

  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      if ((x>0 && y>0)||(x<img.width && y<img.height) ) {
        int [][] PixelMatrix = {
          {img.get(x-1, y-1), img.get(x, y-1), img.get(x+1, y-1)},
          {img.get(x-1, y), img.get(x, y), img.get(x+1, y)},
          {img.get(x-1, y+1), img.get(x, y+1), img.get(x+1, y+1)}
        };
        for (int i=0; i<3; i++) {
          for (int z=0; z<3; z++) {

            Matrix[i][z] *= PixelMatrix[i][z];
          }
        }
        result = (Matrix[0][0]) * ((Matrix[1][1] * Matrix[2][2])+(Matrix[2][1] * Matrix[1][2] )) + (-1*Matrix[1][0])*((Matrix[0][1] * Matrix[2][2])+(Matrix[0][2]* Matrix[2][1])) + (Matrix[2][0])*((Matrix[0][1] * Matrix[1][2])+(Matrix[0][2]*Matrix[1][1]));
        img.set(x, y, result);
         println(result);

      }
    }
  }
  updatePixels();
  IsMitjanaApplied = !IsMitjanaApplied;
}

void showPixelInfo(int x, int y) {
  loadPixels();
  color c = img.get(x, y);
  int xOffset;

  if (x > width-120) {
    xOffset = -20;
    textAlign(RIGHT);
  } else {
    xOffset = 20;
    textAlign(LEFT);
  }

  String text = "("+ x +","+ y +")\nRGB: ("+ int(red(c)) +","+ int(green(c)) +","+ int(blue(c)) +")";
  fill(0);
  text(text, x + xOffset + 1, y + 1);
  fill(255);
  text(text, x + xOffset, y);
}
