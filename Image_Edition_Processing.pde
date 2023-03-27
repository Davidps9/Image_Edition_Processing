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
  gui.pushFolder("Binarize");
  int GrayValue = gui.sliderInt("Threshold", 0, 0, 255);
  if (gui.button("Binarize")) {
    imgToGrayscale();
    binarizeImg(GrayValue);
  }
  gui.popFolder();
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
  String bdType = gui.radio("Detect", new String[]{"All", "Horizontal", "Vertical"});
  if (gui.button("Detect Borders")) {
    generateMatrix(3, "Border" + bdType);
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
  showHistogram();
}
