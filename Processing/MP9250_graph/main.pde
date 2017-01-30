Serial serialPort;

float deltaT   =  0.1; // secondes

// Filtering
float DATA_FILTER_MIN_EDGE = 0.0f;
float DATA_FILTER_MAX_EDGE = 1000.0f;
float kFilteringFactor = 0.33;

float posX = 0.0;
float posY = 0.0;
float posZ = 0.0;

float oldSpeedX = 0.0;
float oldSpeedY = 0.0;
float oldSpeedZ = 0.0;

float accelX;
float accelY;
float accelZ;

float pitch;
float yaw;
float roll;

// Transform

float M00,M01,M02,M10,M11,M12,M20,M21,M22;
                       
float gravity[] = {0.0,0.0,0.0};

boolean DEBUG = true;
int ARRAY_SIZE = 5;

// 3D Reprensentation of the IMU
ViewObject3D viewObject3D;
SecondApplet plot;

void setup() {
  surface.setVisible(false); //<>// //<>// //<>// //<>//

 // *********** Vue object 3D ************* 
  String[] args = {"3D View"};
  viewObject3D = new ViewObject3D();
  PApplet.runSketch(args, viewObject3D);
  
  // ********** Plot window ***************
  String[] plotName = {"Plot"};
  plot = new SecondApplet();
  PApplet.runSketch(plotName,plot);
   
  // ********** Serial data ***************
  //pitch = new SensorData(ARRAY_SIZE);
  //roll  = new SensorData(ARRAY_SIZE);
  //yaw   = new SensorData(ARRAY_SIZE);
  
  serialPort = new Serial(this, Serial.list()[1],115200);
  serialPort.bufferUntil('\n');
  
  //********************************
}


void serialEvent(Serial p) {

  String part = p.readStringUntil('\n');
  if(part.length() == 36 ) {
    String array[] = part.split("\t\t"); //<>// //<>// //<>// //<>//
    if(array.length == 6) {
       accelX = lowPassFilter(ByteBuffer.wrap(array[0].getBytes()).order(ByteOrder.LITTLE_ENDIAN).getFloat(),0.01,accelX);
       accelY = lowPassFilter(ByteBuffer.wrap(array[1].getBytes()).order(ByteOrder.LITTLE_ENDIAN).getFloat(),0.01,accelY);
       accelZ = lowPassFilter(ByteBuffer.wrap(array[2].getBytes()).order(ByteOrder.LITTLE_ENDIAN).getFloat(),0.01,accelZ);
  
       pitch  = lowPassFilter(ByteBuffer.wrap(array[3].getBytes()).order(ByteOrder.LITTLE_ENDIAN).getFloat(),0.4,pitch);
       yaw    = lowPassFilter(ByteBuffer.wrap(array[4].getBytes()).order(ByteOrder.LITTLE_ENDIAN).getFloat(),0.4,yaw); //<>// //<>// //<>// //<>//
       roll   = lowPassFilter(ByteBuffer.wrap(array[5].getBytes()).order(ByteOrder.LITTLE_ENDIAN).getFloat(),0.4,roll);


    // Rotation matrix
    //gravity[0] =  -sin(pitch);
    //gravity[1] =   cos(pitch) * sin(roll);
    //gravity[2] =   cos(pitch) * cos(roll);
    
    float cx, cy, cz, sx, sy, sz;
    
    // roll => x
    // yaw   => y
    // pitch => z
    cx = cos(-roll);
    cy = cos(yaw);
    cz = cos(pitch);
    sx = sin(-roll);
    sy = sin(yaw);
    sz = sin(pitch);
    
    gravity[0] =  -sz;
    gravity[1] =  -cz * sx;
    gravity[2] =  cz * cx;
    //  println( " accelX     " + accelX     + " accelY     " + accelY     + " accelZ     " + accelZ);

    accelX = accelX - gravity[0];
    accelY = accelY - gravity[1];
    accelZ = accelZ - gravity[2];
    
    }
  }

}

final float alpha = 0.1;

// **** Send data to views *****
  void draw() {
    
    // Set angles
    setPitch(pitch);
    setYaw(yaw);
    setRoll(roll);
    
    
    plot.setPosX(accelX);
    plot.setPosY(accelY);
    plot.setPosZ(accelZ);
    
    // Integrate to speed
    oldSpeedX = getNewSpeed(oldSpeedX,accelX);
    oldSpeedY = getNewSpeed(oldSpeedY,accelY);
    oldSpeedZ = getNewSpeed(oldSpeedZ,accelZ);
    // Integrate to position
    posX = getNewPos(posX,oldSpeedX);
    posY = getNewPos(posY,oldSpeedY);
    posZ = getNewPos(posZ,oldSpeedZ);
    
    if (DEBUG) {
      //print("p " + degrees(pitch) + " y " + degrees(yaw) + " r " + degrees(roll));
      //print (" posX " + posX + " posY " + posY + " posZ " + posZ); 
      //print( " speedX " + oldSpeedX + " speedY " + oldSpeedY + " speedZ " + oldSpeedZ);
      //println( " gravity[0] " + gravity[0] + " gravity[1] " + gravity[1] + " gravity[2] " + gravity[2]);
      println( " accelX     " + accelX     + " accelY     " + accelY     + " accelZ     " + accelZ);
      //print( " X " + gravity[0] + " Y " + gravity[1] + " z " + gravity[2]); //<>//
      println();
    }
      //<>// //<>// //<>//
  }


   public float getNewPos(float oldPos,float newSpeed) {
      return oldPos + newSpeed*deltaT;
   }
   
   public float getNewSpeed(float oldSpeed,float accel) {
      return oldSpeed + accel*deltaT;
   }


  float lowPassFilter(float data, float filterVal, float smoothedVal){
      return data * (1.0 - filterVal) + (smoothedVal  *  filterVal);
  }


// **************************************************
// ********** Set attribut for graphics *************
// **************************************************

    //public void setPosX(float p_posX) {
    //  viewObject3D.setPosX(p_posX);
    //  plot.setPosX(p_posX);
    //}
    
    // public void setPosY(float p_posY) {
    //  viewObject3D.setPosY(p_posY);
    //  plot.setPosY(p_posY);
    //}
    //public void setPosZ(float p_posZ) {
    //  viewObject3D.setPosZ(p_posZ);
    //  plot.setPosZ(p_posZ);
    //}
    public void setPitch(float p_Pitch) {
      
      viewObject3D.setPitch(p_Pitch);
      plot.setPitch(p_Pitch);
    }
    public void setRoll(float p_Roll) {
      viewObject3D.setRoll(p_Roll);
      plot.setRoll(p_Roll);
    }
    public void setYaw(float p_Yaw) {
      viewObject3D.setYaw(p_Yaw);
      plot.setYaw(p_Yaw);
    }

// ****************************************************
// ** Update object parameters with data from serial **
// ****************************************************
float getFloatFromSerial() {
  byte[] s = new byte[4];
  serialPort.readBytes(s);
  return ByteBuffer.wrap(s).order(ByteOrder.LITTLE_ENDIAN).getFloat();
}