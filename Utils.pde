color invertColor(color c) {
  float newc_red = map(red(c), 0, 255, 255, 0);
  float newc_green =  map(green(c), 0, 255, 255, 0);
  float newc_blue =  map(blue(c), 0, 255, 255, 0);
  return color(newc_red, newc_green, newc_blue);
}

color rgb2Gray(color c) {
  float newc = red(c) * 299/1000 + green(c) * 587/1000 + blue(c) * 114/1000;
  return color(newc, newc, newc);
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

void showHistogram(){
  stroke(255);
  fill(0);
  int[] histogramValues = new int[256];
  color c;
  int cAverage = 0;
  
  rect(width-256,height-100,256,100);
  
  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      c = img.get(x,y);
      cAverage = round((red(c) + green(c) + blue(c)) / 3);
      histogramValues[cAverage]++;
    }
  }
  
  int maxValue = max(histogramValues);
  
  for(int i = 0; i < histogramValues.length; i++){
    line(width-256+i, height, width-256+i, height - map(histogramValues[i],0,maxValue,0,100));
  }
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
