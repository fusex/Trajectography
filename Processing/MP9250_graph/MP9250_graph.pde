import g4p_controls.*;
import processing.serial.*;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;

import java.awt.*;

// Global variables

int gridScale = 10;
int boxSize    = 500;
int boxWidth   = boxSize/5;
int boxHeight  = boxSize/10;
int boxDeep    = boxSize/7;

char cameraSelection = '"';

public class ViewObject3D extends PApplet {

  // Objects parameters
  private float posX   = boxSize/2 + boxWidth/2;
  private float posY   = -3*boxHeight;
  private float posZ   = boxSize/2 + boxDeep/2;
  
  private float pitch  = 0;
  private float roll   = 0;
  private float yaw    = 0;
  
  private float pitchCorrect  = 0;
  private float rollCorrect   = 0;
  private float yawCorrect    = radians(-38);
  
 
  public void setPosX(float p_posX){posX = p_posX;}
  public void setPosY(float p_posY){posY = p_posY;}
  public void setPosZ(float p_posZ){posZ = p_posZ;}
  
  public void setPitch(float p_pitch){pitch = normalize(p_pitch) + pitchCorrect;} //<>// //<>// //<>// //<>//
  public void setRoll(float p_roll)  {roll = normalize(p_roll) + rollCorrect;}
  public void setYaw(float p_yaw)    {yaw = normalize(p_yaw) + yawCorrect;}
  

  public void settings(){
      size(800, 600, P3D);
  }
  
  public void setup() { 
    surface.setLocation(width,0);
    surface.setAlwaysOnTop(true);
    surface.setAlwaysOnTop(false);

    // *** 3D object window ***
    textSize(25);
    textMode(MODEL);    
  }
  
  public void draw() {

    background(0);
    //****************** Camera Selection *************************
    if (keyPressed) {
      cameraSelection = key;
    }
    
    if(cameraSelection == '&')   
        camera(500, -500, 800, 0, 4, 0, 0, 1, 0);
    else if (cameraSelection == 'é')
        camera(500, -250, 800, 0, 4, 0, 0, 1, 0);
    else if (cameraSelection == '"')
        camera(700, -250, 600, 0, 4, 0, 0, 1, 0);
    else if (cameraSelection == '\'')
        camera(700, -150, 600, 0, 3, 0, 0, 1, 0);
      
    
    translate(0,0,boxSize);
    rotateY(PI/2);
      dataStatus();
    rotateY(-PI/2);
    translate(0,0,-boxSize);
  
    // ************************ Coordinate system Axes ***************************
    strokeWeight(4);  
  
    stroke(color(0, 204, 0));
    line(0, 0, 0, boxSize, 0, 0);
  
    stroke(color(204, 0, 0));
    line(0, 0, 0, 0, -boxSize, 0);
  
    stroke(color(0, 0, 204));
    line(0, 0, 0, 0, 0, boxSize);
  
  
    // **************************** Coordinate Grid ******************************
    stroke(154);
    strokeWeight(2); 
    for (int i=1; i < gridScale; i++)
    {
  
      // X by Z plane
      line(boxSize*i/gridScale, 0, 0, boxSize*i/gridScale, 0, boxSize);
  
      line(0, 0, boxSize*i/gridScale, boxSize, 0, boxSize*i/gridScale);    
  
      // Y by Z plane
      line(0, 0, boxSize*i/gridScale, 0, -boxSize, boxSize*i/gridScale);
      line(0, -boxSize*i/gridScale, 0, 0, -boxSize*i/gridScale, boxSize);
  
      // X by Z 
      line(boxSize*i/gridScale, 0, 0, boxSize*i/gridScale, -boxSize, 0);
      line(0, -boxSize*i/gridScale, 0, boxSize, -boxSize*i/gridScale, 0);
    }
  
    // *********************** Coordinate of the object **************************
    // Lines
    stroke(color(0, 204, 0));
    line(0, posY, posZ, posX, posY, posZ);
  
    stroke(color(0, 0, 204));
    line(posX , posY , 0 , posX, posY, posZ);
  
    stroke(color(204, 0, 0));
    line(posX , 0 , posZ , posX, posY, posZ);
  
    stroke(154);
  
    
    // ******************************** Object ********************************
    translate(posX, posY, posZ);
    
    // println("delta pitch " + degrees(pitch - o_pitch));
   
    rotateXYZ(-roll,  yaw ,  pitch );
  
    // Build the object
    displayBox();  
    // ****************************** ACTION *********************************
  }




void displayBox() {
  //Front
  beginShape(QUADS);
  fill(255, 0, 0);
  vertex(-boxWidth/2, -boxHeight/2, boxDeep/2);
  vertex( boxWidth/2, -boxHeight/2, boxDeep/2);
  vertex( boxWidth/2, boxHeight/2, boxDeep/2);
  vertex(-boxWidth/2, boxHeight/2, boxDeep/2);
  endShape();
  // Back
  beginShape(QUADS);
  fill(255, 255, 0);
  vertex( boxWidth/2, -boxHeight/2, -boxDeep/2);
  vertex(-boxWidth/2, -boxHeight/2, -boxDeep/2);
  vertex(-boxWidth/2, boxHeight/2, -boxDeep/2);
  vertex( boxWidth/2, boxHeight/2, -boxDeep/2);
  endShape();
  // Bottom
  beginShape(QUADS);
  fill( 255, 0, 255);
  vertex(-boxWidth/2, boxHeight/2, boxDeep/2);
  vertex( boxWidth/2, boxHeight/2, boxDeep/2);
  vertex( boxWidth/2, boxHeight/2, -boxDeep/2);
  vertex(-boxWidth/2, boxHeight/2, -boxDeep/2);
  endShape();
  // Top
  beginShape(QUADS);
  fill(0, 255, 0);
  vertex(-boxWidth/2, -boxHeight/2, -boxDeep/2);
  vertex( boxWidth/2, -boxHeight/2, -boxDeep/2);
  vertex( boxWidth/2, -boxHeight/2, boxDeep/2);
  vertex(-boxWidth/2, -boxHeight/2, boxDeep/2);
  endShape();
  // Right
  beginShape(QUADS);
  fill(0, 0, 255);
  vertex( boxWidth/2, -boxHeight/2, boxDeep/2);
  vertex( boxWidth/2, -boxHeight/2, -boxDeep/2);
  vertex( boxWidth/2, boxHeight/2, -boxDeep/2);
  vertex( boxWidth/2, boxHeight/2, boxDeep/2);
  endShape();
  // Left
  beginShape(QUADS);
  fill(0, 255, 255);
  vertex(-boxWidth/2, -boxHeight/2, -boxDeep/2);
  vertex(-boxWidth/2, -boxHeight/2, boxDeep/2);
  vertex(-boxWidth/2, boxHeight/2, boxDeep/2);
  vertex(-boxWidth/2, boxHeight/2, -boxDeep/2);
  endShape();
}
  
  float normalize(float toBeNormalized) {
    float normalized = toBeNormalized;
     while (normalized < 0)
        normalized += 2 * PI;
     while (normalized >= 2 * PI)
        normalized -= 2 * PI;
    
        return normalized;
  }

  // ************************************
  // ** print coordinate of the object **
  // ************************************
  void dataStatus() {
    fill(255,255,255);
    textAlign(LEFT,BOTTOM);
    String s = "X  : " + String.format("%.2f", posX  ) + "\n" +
               "Y  : " + String.format("%.2f", -posY ) + "\n" +
               "Z  : " + String.format("%.2f", posZ  ) + "\n" +
               "P  : " + String.format("%.2f", degrees(pitch) ) + "\n" +
               "Y  : " + String.format("%.2f", degrees(yaw)   ) + "\n" +
               "R  : " + String.format("%.2f", degrees(roll)  ) + "\n"
               ;
    text(s,0,0,-250); 
  }

  // BFG function
  void rotateXYZ(float xx, float yy, float zz) {
    float cx, cy, cz, sx, sy, sz;
    
    cx = cos(xx);
    cy = cos(yy);
    cz = cos(zz);
    sx = sin(xx);
    sy = sin(yy);
    sz = sin(zz);

    // Very usefull website !
    // http://www.songho.ca/opengl/gl_anglestoaxes.html
    //applyMatrix(cy*cz, (cz*sx*sy)-(cx*sz), (cx*cz*sy)+(sx*sz) , 0.0,
    //            cy*sz, (cx*cz)+(sx*sy*sz), (-cz*sx)+(cx*sy*sz), 0.0,
    //            -sy  , cy*sx             , cx*cy              , 0.0,
    //            0.0  , 0.0               , 0.0                , 1.0);
                
    applyMatrix( cy*cz + sy*sx*sz  , -cy*sz + sy*sx*cz ,  sy*cx  , 0.0,
                 cx*sz             ,  cx*cz            , -sx     , 0.0,
                -sy*cz + cy*sx*sz  ,  sy*sz + cy*sx*cz ,  cy*cx  , 0.0,
                 0.0               ,  0.0              ,  0.0    , 1.0);
  }


}