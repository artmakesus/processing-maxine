import com.artmakesus.maxine.*;

import java.util.*;
import java.io.*;

final int[] colors = { 0xFFFF0000, 0xFF00FF00, 0xFF0000FF };

Maxine maxine;
List<Maxine.Item> items;

int offsetX = 0;

void setup() {
  size(200, 200);
  noStroke();
  
  maxine = new Maxine(this);

  items = maxine.items();
  println("Got " + items.size() + " items");

  for (int i = 0; i < items.size(); i++) {
    items.get(i).createTexture(width, height);
  }
}

void draw() {
  for (int i = 0; i < items.size(); i++) {
    final int c = colors[i % 3];
    checker(c);
    Maxine.Item item = items.get(i);
    item.setTexture(g);
    item.invalidateTexture();
  }
  
  offsetX = (offsetX + 1) % width;
}

void checker(int c) {
  final int w = width / 10;
  final int h = height / 10;
  
  g.loadPixels();
  
  final int len = g.pixels.length;
  for (int i = 0; i < len; i++) {
    final int x = (i + offsetX) % width;
    final int y = i / width;
    final int xx = int(x / w);
    final int yy = int(y / h);
    
    int pix = 0;
    if ((xx + yy) % 2 == 1) {
      pix = c;
    }
    
    g.pixels[i] = pix;
  }
  
  g.updatePixels();
}