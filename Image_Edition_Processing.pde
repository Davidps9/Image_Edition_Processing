LazyGui gui;
String img_filename = "wp.png";
PImage img;

int MitArm;
boolean Inverted, IsInverted =false;
boolean Mitjana, IsMitjanaApplied =false;
int [][] MatrixR = new int [3][3];
int [][] MatrixG = new int [3][3];
int [][] MatrixB = new int [3][3];

void settings() {
  img = loadImage(img_filename);
  size(img.width, img.height, P2D);
}
void setup() {

  gui = new LazyGui(this);
}

void draw() {
  image(img, 0, 0);

  gui.hide("options");
  //gui.hide("saves");
  gui.pushFolder("Handmade_Photoshop");

  //Invert Image
  Inverted = gui.toggle("Invert Colors", false);
  if (Inverted != IsInverted) {
    invertImg();
  }

  //Denoise image
  MitArm = (int)gui.slider("Denoise Amount", 0, -10, 10);
  Mitjana = gui.toggle("Apply Denoise", false);
  if (Mitjana) {
    if(!IsMitjanaApplied){
      ApplyMitjanaToImg();
    } 
  } else {
    if(IsMitjanaApplied){
      print("E");
      img = loadImage(img_filename);
      IsMitjanaApplied = false;
    }
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
  float newc_blue =  map(blue(c), 0, 255, 255, 0); //<>//
  return color(newc_red, newc_green, newc_blue);
}

void applyConvolution(PImage img, float[][] matrix){
  
  loadPixels();
  float newc_red, newc_green, newc_blue;
  
  for(int x = 0; x<img.width; x++){
    for(int y = 0; y<img.height; y++){
      newc_red = 0;
      newc_green = 0;
      newc_blue = 0;
      
      for(int m = 0; m<matrix.length; m++){
        for(int n = 0; n<matrix[0].length; n++){
          color c = img.get(x + (m-1), y + (n-1));
          newc_red += red(c) * matrix[m][n] / 9;
          newc_green += green(c) * matrix[m][n] / 9;
          newc_blue += blue(c) * matrix[m][n] / 9;
        }
      }
      img.set(x,y,color(newc_red, newc_green, newc_blue));
    }
  }
  
  updatePixels();
}

void ApplyMitjanaToImg() {
  //int resultR,resultG,resultB;
  //color newc;
  //loadPixels();



  /*for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      if ((x>0 && y>0)||(x<img.width && y<img.height) ) {
        color [][] PixelMatrix = {
          {img.get(x-1, y-1), img.get(x, y-1), img.get(x+1, y-1)},
          {img.get(x-1, y), img.get(x, y), img.get(x+1, y)},
          {img.get(x-1, y+1), img.get(x, y+1), img.get(x+1, y+1)}
        };
        for (int i=0; i<3; i++) {
          for (int z=0; z<3; z++) {
            
            MatrixR[i][z] = (int)red(PixelMatrix[i][z]) /  2 ;
            MatrixG[i][z] = (int)green(PixelMatrix[i][z]) /  2 ;    
            MatrixB[i][z] = (int)blue(PixelMatrix[i][z]) /  2 ;
          }
        }
        resultR = (MatrixR[0][0]) * ((MatrixR[1][1] * MatrixR[2][2])+(MatrixR[2][1] * MatrixR[1][2] )) + (-1*MatrixR[1][0])*((MatrixR[0][1] * MatrixR[2][2])+(MatrixR[0][2]* MatrixR[2][1])) + (MatrixR[2][0])*((MatrixR[0][1] * MatrixR[1][2])+(MatrixR[0][2]*MatrixR[1][1]));
        resultG = (MatrixG[0][0]) * ((MatrixG[1][1] * MatrixG[2][2])+(MatrixG[2][1] * MatrixG[1][2] )) + (-1*MatrixG[1][0])*((MatrixG[0][1] * MatrixG[2][2])+(MatrixG[0][2]* MatrixG[2][1])) + (MatrixG[2][0])*((MatrixG[0][1] * MatrixG[1][2])+(MatrixG[0][2]*MatrixG[1][1]));
        resultB = (MatrixB[0][0]) * ((MatrixB[1][1] * MatrixB[2][2])+(MatrixB[2][1] * MatrixB[1][2] )) + (-1*MatrixB[1][0])*((MatrixB[0][1] * MatrixB[2][2])+(MatrixB[0][2]* MatrixB[2][1])) + (MatrixB[2][0])*((MatrixB[0][1] * MatrixB[1][2])+(MatrixB[0][2]*MatrixB[1][1]));
        newc = color(resultR,resultG,resultB);
        img.set(x, y, newc);
        
      }
    }
  }*/
  
  float[][] denoiseMatrix = { {1,1,1},{1,1,1},{1,1,1} };
  applyConvolution(img,denoiseMatrix);
     
  //updatePixels();
  IsMitjanaApplied = true;
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
