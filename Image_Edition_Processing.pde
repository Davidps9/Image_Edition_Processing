LazyGui gui;
PImage img;

float x;
boolean Inverted, IsInverted =false;
void settings(){
img = loadImage("wp.png");
  size(img.width,img.height,P2D);

}
void setup(){
  
  gui = new LazyGui(this);


}

void draw(){
  image(img,0,0);
  

    gui.pushFolder("Handmade_Photoshop");
    
    //Invert Image
    Inverted = gui.toggle("Invert Colors",false);
    if(Inverted != IsInverted){
      invertImg();
    }
    
    
    x = gui.slider("x",0,-10,10);
    
    
    gui.popFolder();

    showPixelInfo(mouseX,mouseY);
}
void invertImg(){
  color c;
  color newc;
  
  loadPixels();
  
  for(int x = 0; x<img.width; x++){
    for(int y = 0; y<img.height; y++){
  
    c = img.get(x,y);
    newc = invertColor(c);
    img.set(x,y,newc);
    
    }
  }
  
  updatePixels();
  IsInverted = !IsInverted ;
}

color invertColor(color c){
  float newc_red = map(red(c), 0,255, 255,0);
  float newc_green =  map(green(c), 0,255, 255,0);
  float newc_blue =  map(blue(c), 0,255, 255,0);
  return color(newc_red,newc_green,newc_blue);
}

void showPixelInfo(int x, int y){
  loadPixels();
  color c = img.get(x,y);
  int xOffset;
  
  if(x > width-120){
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
