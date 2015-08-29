import javax.swing.JOptionPane;

int[][] ekran = new int[20][20];
int[][] cozum = new int[20][20];
boolean cizime_hazir, oyun_basladi;
int ekran_en , ekran_boy, ekran_kenar;

void setup() {
  size(120,120);
  background(255);
  fill(128);
  rect(2,2,50,30);
  textSize(24);
  fill(255);
  text("AÇ", 12, 25);
  cizime_hazir = false;
  oyun_basladi = false;
}

void draw() {
  int i,j;
  
  if (cizime_hazir) {
    stroke(0);
    for (j = 0 ; j < ekran_en ; j++) {
      int xpos = j*20+ekran_kenar;
      if (j % 5 == 0) {
        strokeWeight(2);
      } else {
        strokeWeight(1);
      }
      line(xpos,0,xpos,height);
    }
    for (j = 0 ; j < ekran_boy ; j++) {
      int ypos = j*20+ekran_kenar;
      if (j % 5 == 0) {
        strokeWeight(2);
      } else {
        strokeWeight(1);
      }
      line(0,ypos,width,ypos);
    }
    
    sayilari_koy();
    cizime_hazir = false;
    oyun_basladi = true;
  }
  
  if (oyun_basladi & mousePressed & mouseX > ekran_kenar & mouseY > ekran_kenar) {
    int satir = (mouseY - ekran_kenar) / 20;
    int sutun = (mouseX - ekran_kenar) / 20;
    //println(satir,sutun);
    
    if (mouseButton == LEFT) {
      if (ekran[satir][sutun] == 2) ekran[satir][sutun] = 1;
      else ekran[satir][sutun] = 2;
    }

    if (mouseButton == RIGHT) {
      if (ekran[satir][sutun] == 2) ekran[satir][sutun] = 0;
      else ekran[satir][sutun] = 2;
    }

    mousePressed = false;
  }
  
  boya();
  
  if (ekran == cozum) {
    println("eşit");
    javax.swing.JOptionPane.showMessageDialog(frame,"what?");
  }
}

void mousePressed() {
  // dosya aç tıklandı
  if (mouseX > 2 & mouseX < 52 & mouseY > 2 & mouseY < 32) {
    selectInput("Bir oyun dosyası seçin", "dosyaSecildi");
    mousePressed = false;
  }
}

void dosyaSecildi(File selection) {
  if (selection == null) {
    surface.setTitle("Dosya seçilmedi");
  } else {
    String fileName = selection.getAbsolutePath();
    surface.setTitle(fileName);
    String lines[] = loadStrings(fileName);
    ekran_en = lines[0].length();
    ekran_boy = lines.length;
    ekran_kenar = 100;
    int yukseklik = ekran_boy * 20 + ekran_kenar;
    int genislik = ekran_en * 20 + ekran_kenar;
    surface.setSize(genislik, yukseklik);
    
    // ekran ve çözüm matrisleri
    int i, j;
    for (i = 0 ; i < 20 ; i++) {
      for (j = 0 ; j < 20 ; j++) {
        ekran[i][j] = 2;                    //boş kare
        cozum[i][j] = 2;
      }
    }
    for (i = 0 ; i < ekran_boy ; i++) {
      for (j = 0 ; j < ekran_en ; j++) {
        cozum[i][j] = int(lines[i].substring(j,j+1));
      }
    }
//    for (i = 0 ; i < ekran_boy; i++) {
//      println(lines[i]);
      //println(ekran[i]);
      //println(cozum[i]);
//    }
  }
  cizime_hazir = true;
}



void sayilari_koy() {
  fill(0);
  textSize(12);
  int x = ekran_kenar + ekran_en*20 - 15;
  int y = ekran_kenar - 5;
  
  int i,j;
  for (i=ekran_en-1;i>=0;i--) {
    int sayi = 0;
    int eski_deger, deger;
    eski_deger = 0;
    for (j=ekran_boy-1;j>=0;j--) {
      deger = cozum[j][i];
      if (deger == 1) sayi++;
      if ((deger == 0 & eski_deger == 1) | j == 0) {
        text(sayi,x,y);
        y -= 20;
        sayi = 0;
      }
      eski_deger = deger;
    }
    y = ekran_kenar - 5;
    x -= 20;
  }
  
  x = ekran_kenar - 20;
  y = ekran_kenar + ekran_boy*20 - 5;
  for (i=ekran_boy-1;i>=0;i--) {
    int sayi = 0;
    int eski_deger, deger;
    eski_deger = 0;
    for (j=ekran_en-1;j>=0;j--) {
      deger = cozum[i][j];
      if (deger == 1) sayi++;
      if ((deger == 0 & eski_deger == 1) | j == 0) {
        text(sayi,x,y);
        x -= 20;
        sayi = 0;
      }
      eski_deger = deger;
    }
    x = ekran_kenar - 20;
    y -= 20;
  }
}


void boya() {
  boolean bitti = true;
  for (int i = 0 ; i<ekran_boy ; i++) {
    for (int j = 0 ; j<ekran_en ; j++) {
      if (ekran[i][j] == 2) fill(220);
      else if (ekran[i][j] == 0) fill(255);
      else fill(0);
      noStroke();
      rect(ekran_kenar + j*20 + 2, ekran_kenar + i*20 + 2,18,18);
      if (ekran[i][j] != cozum[i][j]) bitti = false;
    }
  }
  
  if (bitti & oyun_basladi) {
    fill(0);
    JOptionPane.showMessageDialog(null,"Tebrikler KAZANDINIZ");
    oyun_basladi = false;
    bitti = false;
    setup();
  }
}