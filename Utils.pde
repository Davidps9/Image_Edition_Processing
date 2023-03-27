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

void showHistogram() {
  stroke(255);
  fill(0);
  int[] histogramR = new int[256];
  int[] histogramG = new int[256];
  int[] histogramB = new int[256];
  color c;

  rect(width-256, height-100, 256, 100);

  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      c = img.get(x, y);
      histogramR[int(red(c))]++;
      histogramG[int(green(c))]++;
      histogramB[int(blue(c))]++;
    }
  }
  int maxValue = max(max(histogramR), max(histogramG), max(histogramB));

  loadPixels();
  for (int x = 0; x < 256; x++) {
    int[] mappedValues = {
      round(map(histogramR[x], 0, maxValue, 0, 100)),
      round(map(histogramG[x], 0, maxValue, 0, 100)),
      round(map(histogramB[x], 0, maxValue, 0, 100))
    };
    for (int ch = 0; ch < mappedValues.length; ch++) {
      for (int y = 0; y < mappedValues[ch]; y++) {
        color pixelColor = get(width-256+x, height-y);
        switch(ch) {
        case 0:
          pixelColor = color(255, green(pixelColor), blue(pixelColor));
          break;
        case 1:
          pixelColor = color(red(pixelColor), 255, blue(pixelColor));
          break;
        case 2:
          pixelColor = color(red(pixelColor), green(pixelColor), 255);
          break;
        }
        set(width-256+x, height-y, pixelColor);
      }
    }
  }
  updatePixels();
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
