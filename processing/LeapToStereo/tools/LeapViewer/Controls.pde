int counter = 0;

void keyPressed() {
  if (key == TAB) {
    showTex = !showTex;
  } else {
    texL.save("test_" + counter + "L.png");
    texR.save("test_" + counter + "R.png");
    counter++;
  }
}
