import com.artmakesus.maxine.*;

import java.util.*;
import java.io.*;

Maxine maxine;
Maxine.Item item;

int offsetX = 0;

void setup() {
  size(200, 200);
  noStroke();
  
  maxine = new Maxine(this);

  List<Maxine.Item> items = maxine.items();
  println("Got " + items.size() + " items");

  if (items.size() > 0) {
    item = items.get(0);
    item.createTexture(width, height);
  }
}

void draw() {
  checker();
  item.setTexture(g);
  item.invalidateTexture();
  offsetX = (offsetX + 1) % width;
}

void checker() {
  final int w = width / 10;
  final int h = height / 10;
  
  g.loadPixels();
  
  final int len = g.pixels.length;
  for (int i = 0; i < len; i++) {
    final int x = (i + offsetX) % width;
    final int y = i / width;
    final int xx = int(x / w);
    final int yy = int(y / h);
    
    int pix = 0xFF000000;
    if ((xx + yy) % 2 == 1) {
      pix = 0xFFFFFFFF;
    }
    
    g.pixels[i] = pix;
  }
  
  g.updatePixels();
}
