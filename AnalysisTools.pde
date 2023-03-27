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
