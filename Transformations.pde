void invertImg() {
  color c, newc;

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

void imgToGrayscale() {
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

void shiftHue(float shift){
  color c,newc;
  float newHue;
  loadPixels();
  colorMode(HSB);
  
  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {

      c = img.get(x, y);
      newHue = hue(c) + shift;
      newHue = newHue > 360 ? newHue-360 : newHue;
      newc = color(newHue,saturation(c),brightness(c));
      img.set(x, y, newc);
    }
  }

  updatePixels();
  colorMode(RGB);
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
      }
    }
    break;

  case "BorderAll":
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

  case "BorderHorizontal":
    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        if (y == floor(matrixSize/2)) {
          denoiseMatrix[x][y] = matrixSize - 1;
        } else {
          denoiseMatrix[x][y] = -1;
        }
      }
    }
    break;

  case "BorderVertical":
    for (int x = 0; x<matrixSize; x++) {
      for (int y = 0; y<matrixSize; y++) {
        if (x == floor(matrixSize/2)) {
          denoiseMatrix[x][y] = matrixSize - 1;
        } else {
          denoiseMatrix[x][y] = -1;
        }
      }
    }
    break;
  }

  applyConvolution(img, denoiseMatrix);
}

void binarizeImg(int threshold) {
  color c;
  color newc;
  loadPixels();
  for (int x = 0; x<img.width; x++) {
    for (int y = 0; y<img.height; y++) {
      c = img.get(x, y);
      if (red(c)< threshold) {
        newc = color(0, 0, 0);
      } else {
        newc = color(255, 255, 255);
      }
      img.set(x, y, newc);
    }
  }
  updatePixels();
}
