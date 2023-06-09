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
