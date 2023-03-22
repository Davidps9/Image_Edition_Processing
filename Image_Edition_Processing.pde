LazyGui gui;
color c;

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
      InvertImg();
    }
    
    
    x = gui.slider("x",0,-10,10);
    
    
    
    
    
    gui.popFolder();

}
void InvertImg(){
  
float newc_red, newc_green, newc_blue;
color newc;

loadPixels();

for(int x = 0; x<img.width; x++){
  for(int y = 0; y<img.height; y++){

  c = img.get(x,y);
  newc_red = map(red(c), 0,255, 255,0);
  newc_green =  map(green(c), 0,255, 255,0);
  newc_blue =  map(blue(c), 0,255, 255,0);
  newc = color(newc_red,newc_green,newc_blue);
  img.set(x,y,newc);
  
  }
}

updatePixels();
IsInverted = !IsInverted ;
}
