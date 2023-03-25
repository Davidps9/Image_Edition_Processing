LazyGui gui; //<>//
String img_filename;
PImage img;

void setup() {
  size(1280, 720, P2D);
  surface.setTitle("Handmade Photoshop");
  surface.setResizable(true);
  gui = new LazyGui(this, new LazyGuiSettings()
    .setLoadLatestSaveOnStartup(false)
    .setAutosaveOnExit(false)
    );
}

void draw() {
  background(0);

  gui.hide("options");
  gui.hide("saves");

  gui.pushFolder("Open image");
  String load_filename = gui.text("File name");
  boolean loadToggle = gui.button("Open image");
  gui.popFolder();
  
  if (loadToggle && load_filename.length() > 0) {
    img_filename = load_filename;
    img = loadImage(img_filename);
    
    print("yo");
    gui.show("Edit image");
    gui.show("Export image");
    gui.show("Close image");
  }
  
  if (img == null) {
    return;
  }

  gui.pushFolder("Edit image");

  //Invert image
  if (gui.button("Invert colors")) {
    invertImg();
  }

  //Denoise image
  gui.pushFolder("Denoise");
  int denoiseValue = gui.sliderInt("Denoise amount", 1, 1, 100);
  String denoiseType = gui.radio("Denoise type", new String[]{"Average", "Gaussian"});
  if (gui.button("Apply denoise")) {
    int mappedDenoiseValue = round(map(denoiseValue, 1, 100, 3, 25));
    denoiseImg(mappedDenoiseValue, denoiseType);
  }
  gui.popFolder();

  if (gui.button("Reset image")) {
    img = loadImage(img_filename);
  }

  gui.popFolder();

  gui.pushFolder("Export image");
  String export_filename = gui.text("File name");
  if (gui.button("Export image")) {
    img.save("/exports/" + export_filename);
  }
  gui.popFolder();

  if (gui.button("Close image")) {
    img = null;
    img_filename = null;
    
    gui.hide("Edit image");
    gui.hide("Export image");
    gui.hide("Close image");
    
    return;
  }

  image(img, width/2 - img.width/2, height/2 - img.height/2);
  showPixelInfo(mouseX, mouseY);
}

/* EDITS */

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
}

void denoiseImg(int matrixSize, String denoiseType) {

  float[][] denoiseMatrix = new float[matrixSize][matrixSize];

  switch(denoiseType) {
  case "Average":
    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        denoiseMatrix[x][y] = 1;
      }
    }
    break;

  case "Gaussian":
    // TODO: Generate gaussian matrix
    break;
  }

  applyConvolution(img, denoiseMatrix);
}

/* GENERIC TRANSFORM FUNCTIONS */

color invertColor(color c) {
  float newc_red = map(red(c), 0, 255, 255, 0);
  float newc_green =  map(green(c), 0, 255, 255, 0);
  float newc_blue =  map(blue(c), 0, 255, 255, 0);
  return color(newc_red, newc_green, newc_blue);
}

void applyConvolution(PImage img, float[][] matrix) {

  int matrixCols = matrix.length;
  int matrixRows = matrix[0].length;
  int matrixSize = matrixCols * matrixRows;

  loadPixels();
  float newc_red, newc_green, newc_blue;

  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      newc_red = 0;
      newc_green = 0;
      newc_blue = 0;

      for (int m = 0; m<matrixCols; m++) {
        for (int n = 0; n<matrixRows; n++) {
          color c = img.get(x + (m-floor(matrixCols/2)), y + (n-floor(matrixRows/2)));
          newc_red += red(c) * matrix[m][n] / matrixSize;
          newc_green += green(c) * matrix[m][n] / matrixSize;
          newc_blue += blue(c) * matrix[m][n] / matrixSize;
        }
      }
      img.set(x, y, color(newc_red, newc_green, newc_blue));
    }
  }

  updatePixels();
}

/* UTILITIES */

void showPixelInfo(int raw_x, int raw_y) {
  int x = raw_x - width/2 + img.width/2;
  int y = raw_y - height/2 + img.height/2;

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
  text(text, raw_x + xOffset + 1, raw_y + 1);
  fill(255);
  text(text, raw_x + xOffset, raw_y);
}





//(x,y,z) * (x,y,z)
//for(fuera){
//for(dentro)
//Matriz[fuera][dentro] = array[fuera]*array[dentro]
//}
