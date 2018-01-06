/* FALTA:
 * - cambio de turno gradual: reticula y aparición de O u X.
 * - efectos de sonido- no estoy segura como hacer eso pero
 *   te averiguo. Debe ser fácil.
 * - hay una orillita blanca que se queda cuando la retícula
 *   cambia a azul, no se porque pero me molesta mucho.
 * - encontrar forma de que se voltee a vertical mas facil.
 *
 * Notas sobre pantalla de victoria:
 *  Texto es negro, pero se puede cambiar, y obviamente aun le
 *  falta las frases que quieres. Creo que si hay forma de tener
 *  varias y hacerlas aparecer de manera aleatoria, pero igual
 *  tengo que averiguar como se hace.
 */

 
//Variables:
//Tamaños:
int scale = 90;//tamaño de gato define tamaño de todo lo demás
int div = scale/3;
int x = 2*div;//coordenadas de la esquina superior izquierda
int y = x/10;
//Colores
color fondo = color(20,180,70);//verde claro
color colorX = color(255); //blanco
color colorO = color(59,89,152);//azul facebook
color sombra = color(10,30); //gris transparente
color reticula = color(colorX);//empieza la X
color ganaX = color(85,140,255,210);//azul pastel transparente
color ganaO = color(255,210);//blanco transparente
//Turno
boolean turnX = true;

//construye 9 secciones con diferencte número, todas vacías
Section sect0 = new Section(0,false);
Section sect1 = new Section(1,false);
Section sect2 = new Section(2,false);
Section sect3 = new Section(3,false);
Section sect4 = new Section(4,false);
Section sect5 = new Section(5,false);
Section sect6 = new Section(6,false);
Section sect7 = new Section(7,false);
Section sect8 = new Section(8,false);
//y una para todo lo que esta afuera
Section out_win = new Section(9,false);

void setup(){
  size((2*x)+scale),scale+div+y;
  background(fondo);
}

void draw(){
  strokeWeight(scale/100);
  if(turnX) reticula = colorX;
  else reticula = colorO;
  stroke(reticula);
  smooth();
  //horizontales
  line(x,y+div,x+scale,y+div);
  line(x,y+x,x+scale,y+x);
  //verticales
  line(x+div,y,x+div,y+scale);
  line(2*x,y,2*x,y+scale);
}

void mousePressed(){
  Section sect = checkSection(mouseX, mouseY);
  if(sect != out_win){
    if(turnX) {drawX(sect);}
      else {drawO(sect);}
    if(checkWin()){
      noLoop();
      victoria(turnX);//el valor de este turno se "invierte"
    }  
  }
}

Section checkSection(int xpos, int ypos){
  if(xpos>x && xpos<x+div){
    if(ypos>y && ypos<y+div) return sect0;
    if(ypos>y+div && ypos<y+x) return sect3;
    if(ypos>y+x && ypos<y+scale) return sect6;
  } else if(xpos>x+div && xpos<2*x){
      if(ypos>y && ypos<y+div) return sect1;
      if(ypos>y+div && ypos<y+x) return sect4;
      if(ypos>y+x && ypos<y+scale) return sect7;
    } else if(xpos>2*x && xpos<x+scale){
        if(ypos>y && ypos<y+div) return sect2;
        if(ypos>y+div && ypos<y+x) return sect5;
        if(ypos>y+x && ypos<y+scale) return sect8;
      } 
  return out_win;
}

void drawX(Section sect){
  if(!sect.holdsO && !sect.holdsX){
    //calcular posición:
    int left = sect.sectX+y;
    int right = sect.sectX+(4*y);
    int top = sect.sectY+y;
    int bottom = sect.sectY+(4*y);
    //FALTA: hacer que aparezca gradual
    //sombra:
    strokeWeight(y);
    stroke(sombra);
    strokeCap(PROJECT);
    line(left+(y/2),top+(y/3),right+(y/2),bottom+(y/3));
    line(left+(y/2),bottom+(y/3),right+(y/2),top+(y/3));
    //cruz:
    strokeWeight(scale/20);
    stroke(colorX);
    strokeCap(SQUARE);
    line(left,top,right,bottom);
    line(left,bottom,right,top);
    //cambio de turno:
    reticula = colorO;//FALTA: que el cambio sea gradual
    sect.holdsX = true;
    turnX = false;
  } 
}

void drawO(Section sect){
  if(!sect.holdsO && !sect.holdsX){
    //calcular posición
    int xpos = sect.sectX + (div/2);
    int ypos = sect.sectY + (div/2);
    //FALTA: hacer que aparezca gradual
    //sombra:
    noFill();
    strokeWeight(y);
    stroke(sombra);
    ellipse(xpos+(y/2),ypos+(y/3),3*y,3*y);
    //círculo:
    strokeWeight(scale/20);
    stroke(colorO);
    ellipse(xpos,ypos,3*y,3*y);
    //cambio de turno:
    reticula = colorX;
    sect.holdsO = true;
    turnX = true;
  }
}

boolean checkWin(){
  if((sect4.holdsX && sect3.holdsX && sect5.holdsX) ||
       (sect4.holdsO && sect3.holdsO && sect5.holdsO)){
    return true;  
  }
  if((sect4.holdsX && sect1.holdsX && sect7.holdsX) ||
       (sect4.holdsO && sect1.holdsO && sect7.holdsO)){
    return true;  
  }
  if((sect4.holdsX && sect0.holdsX && sect8.holdsX) ||
       (sect4.holdsO && sect0.holdsO && sect8.holdsO)){ 
    return true; 
  }
  if((sect4.holdsX && sect2.holdsX && sect6.holdsX) ||
       (sect4.holdsO && sect2.holdsO && sect6.holdsO)){
    return true;
  }
  if((sect0.holdsX && sect1.holdsX && sect2.holdsX) ||
       (sect0.holdsO && sect1.holdsO && sect2.holdsO)){
    return true;
  }
  if((sect6.holdsX && sect7.holdsX && sect8.holdsX) ||
       (sect6.holdsO && sect7.holdsO && sect8.holdsO)){
    return true;
  }
  if((sect0.holdsX && sect3.holdsX && sect6.holdsX) ||
       (sect0.holdsO && sect3.holdsO && sect6.holdsO)){
    return true;
  }
  if((sect2.holdsX && sect5.holdsX && sect8.holdsX) ||
       (sect2.holdsO && sect5.holdsO && sect8.holdsO)){
    return true;
  }
  return false;
}

void victoria(boolean ganoO){
  if(ganoO){
    fill(ganaO);
    noStroke();
    rect(div,y/2, 2*scale-div, scale+(div/2));
    drawO(out_win);
  } else {
      fill(ganaX);
      noStroke();
      rect(div,y/2, 2*scale-div, scale+(div/2));
      drawX(out_win);
  }
  textSize(y);
  fill(0);//texto negro
  text("\"se me ocurre poner un\naforismo cagado\"\n       - Intton Godelg (2015)", 
              div+y,y*2);
  text("Nuevo Juego", div+y, 2*div);
}

class Section {
  public int sectNum;
  public int sectX;
  public int sectY;
  int addY = 0;
  public boolean holdsX;
  public boolean holdsO;
    
  Section(int num, boolean init){
    sectNum = num;
    if(num == 9){
      sectX = (2*x)+y;
      sectY = 2*y;
    } else {
        sectX = x + ((num%3)*div);
        if(num >= 3 && num <= 5) addY = div;
        if(num >= 6) addY = x;
         sectY = y + addY;
         holdsX = init;
         holdsO = init;
      }
  }
}

