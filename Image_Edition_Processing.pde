LazyGui gui; //<>// //<>//
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

    gui.show("Edit image");
    gui.show("Export image");
    gui.show("Close image");
  }

  if (img == null) {
    return;
  }

  gui.pushFolder("Edit image");

  gui.pushFolder("Colorize");
  
  //Invert image
  if (gui.button("Invert colors")) {
    invertImg();
  }
  
  //Invert image
  if (gui.button("Grayscale")) {
    imgToGrayscale();
  }
  gui.popFolder();

  //Denoise image
  gui.pushFolder("Denoise");
  int denoiseValue = gui.sliderInt("Denoise amount", 1, 1, 100);
  String denoiseType = gui.radio("Denoise type", new String[]{"Average", "Gaussian"});
  if (gui.button("Apply denoise")) {
    int mappedDenoiseValue = round(map(denoiseValue, 1, 100, 3, 25));
    generateMatrix(mappedDenoiseValue, denoiseType);
  }
  gui.popFolder();

  //Sharpen image
  gui.pushFolder("Sharpen");
  int sharpenValue = gui.sliderInt("Sharpen amount", 1, 1, 100);
  if (gui.button("Apply sharpen")) {
    int mappedSharpenValue = round(map(sharpenValue, 1, 100, 3, 25));
    generateMatrix(mappedSharpenValue, "Sharpen");
  }
  gui.popFolder();
  
  // Border detection
  gui.pushFolder("Border Detection");
  if (gui.button("Border Detection")) {
    generateMatrix(3, "Border Detection");
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
  color c,newc;

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

void imgToGrayscale(){
  color c, newc;
  loadPixels();
  
  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {

      c = img.get(x, y);
      newc = rgb2Gray(c);
      img.set(x, y, newc);
    }
  }

  updatePixels();
}

void generateMatrix(int matrixSize, String matrixType) {
  matrixSize = matrixSize % 2 == 0 ? matrixSize + 1 : matrixSize;
  float[][] denoiseMatrix = new float[matrixSize][matrixSize];

  switch(matrixType) {
  case "Average":
    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        denoiseMatrix[x][y] = 1 / pow(matrixSize, 2);
      }
    }
    break;

  case "Gaussian":
    float[] Vector = new float [matrixSize];
    float res = 0;
    for (int i = 0; i < matrixSize; i++) {
      Vector[i]= binomialCoeff(matrixSize-1, i);
      res += Vector[i];
    }
    res *= res;
    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        denoiseMatrix[x][y] = (Vector[x] * Vector[y])/ res;
      }
    }
    break;

  case "Sharpen":

    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        if (x == floor(matrixSize/2) && y == floor(matrixSize/2)) {
          denoiseMatrix[x][y] = pow(matrixSize, 2);
        } else {
          denoiseMatrix[x][y] = -1;
        }
        println(denoiseMatrix[x][y]);
      }
    }
    break;
  case "Border Detection":

    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        if (x == floor(matrixSize/2) && y == floor(matrixSize/2)) {
          denoiseMatrix[x][y] = pow(matrixSize, 2) - 1;
        } else {
          denoiseMatrix[x][y] = -1;
        }
      }
    }
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

color rgb2Gray(color c){
  float newc = red(c) * 299/1000 + green(c) * 587/1000 + blue(c) * 114/1000;
  return color(newc,newc,newc);
}

void applyConvolution(PImage img, float[][] matrix) {
  PImage startingImg = img.get();
  int matrixCols = matrix.length;
  int matrixRows = matrix[0].length;
  //int matrixSize = matrixCols * matrixRows;

  loadPixels();
  float newc_red, newc_green, newc_blue;

  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      newc_red = 0;
      newc_green = 0;
      newc_blue = 0;

      for (int m = 0; m<matrixCols; m++) {
        for (int n = 0; n<matrixRows; n++) {
          color c = startingImg.get(x + (m-floor(matrixCols/2)), y + (n-floor(matrixRows/2)));
          newc_red += red(c) * matrix[m][n];
          newc_green += green(c) * matrix[m][n];
          newc_blue += blue(c) * matrix[m][n];
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


int binomialCoeff(int n, int k)
{
  int res = 1;

  if (k > n - k) {
    k = n - k;
  }

  for (int i = 0; i < k; ++i)
  {
    res *= (n - i);
    res /= (i + 1);
  }
  return res;
}
