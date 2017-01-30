
import grafica.*;



public class SecondApplet extends PApplet {
 
  
  
  private float posX   = boxSize/2 + boxWidth/2;
  private float posY   = -3*boxHeight;
  private float posZ   = boxSize/2 + boxDeep/2;
  
  private float pitch  = 0;
  private float roll   = 0;
  private float yaw    = 0;
 
 
 
  private int i = 0; // variable that changes for point calculation
  private int points = 350; // number of points to display at a time
  private int totalPoints = 400; // number of points on x axis

  private  GPlot plot;
  

  public void setPosX(float p_posX){posX = p_posX;}
  public void setPosY(float p_posY){posY = p_posY;}
  public void setPosZ(float p_posZ){posZ = p_posZ;}
  
  public void setPitch(float p_pitch){pitch = p_pitch;}
  public void setRoll(float p_roll){roll = p_roll;}
  public void setYaw(float p_yaw){yaw = p_yaw;}
  
  
  
  public void settings() {
    size(800, 600); //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
  }
  
  
  public void setup() {
      surface.setLocation(0,0); //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
      surface.setAlwaysOnTop(true);
      surface.setAlwaysOnTop(false);

    
    GPointsArray pointsPosX = new GPointsArray(points);
    GPointsArray pointsPosY = new GPointsArray(points);
    GPointsArray pointsPosZ = new GPointsArray(points);


    for(i = 0 ; i < points ; i++ ) {
      pointsPosX.add(i,0);
      pointsPosY.add(i,0);
      pointsPosZ.add(i,0);     
    }
    
    // Create a new plot and set its position on the screen
     plot = new GPlot(this);
     plot.setPos(0,0);
     plot.setDim(800,500);
     
     // Set plot limit
     plot.setXLim(0,totalPoints);
     plot.setYLim(-5,5);
  
    // Set the plot title and the axis labels
    plot.setTitleText("Plot");
    plot.getXAxis().setAxisLabelText("x axis");
    plot.getYAxis().setAxisLabelText("y axis");
  
  
    // Add the points and layers
    plot.addLayer("posX",pointsPosX);
    plot.getLayer("posX").setPointColors(new int[] {color(0,0,204)});
    plot.getLayer("posX").setPointSize(2);
 
    plot.addLayer("posY",pointsPosY);
    plot.getLayer("posY").setPointColors(new int[] {color(0,204,0)});
    plot.getLayer("posY").setPointSize(2);

    plot.addLayer("posZ",pointsPosZ);
    plot.getLayer("posZ").setPointColors(new int[] {color(204,0,0)});
    plot.getLayer("posZ").setPointSize(2);



    // Draw it!
    plot.defaultDraw();
  }
  
  public void draw() {
    //set window background
    background(150);
    
    // draw the plot
    plot.beginDraw(); //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
    plot.drawBackground();
    plot.drawBox();
    plot.drawXAxis();
    plot.drawYAxis();
    plot.drawTopAxis();
    plot.drawRightAxis();
    plot.drawTitle();
    plot.getLayer("posX").drawPoints();
    plot.getLayer("posY").drawPoints();
    plot.getLayer("posZ").drawPoints();

    plot.endDraw();
    
    
    if(i == totalPoints)
      i=0;
    else
      i++;
      
      plot.addPoint(new GPoint(i,posX),plot.getLayer("posX").getId()); //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
      plot.removePoint(0,plot.getLayer("posX").getId());
      
      plot.addPoint(new GPoint(i,-posY),plot.getLayer("posY").getId());
      plot.removePoint(0,plot.getLayer("posY").getId());
      
      plot.addPoint(new GPoint(i,posZ),plot.getLayer("posZ").getId());
      plot.removePoint(0,plot.getLayer("posZ").getId());      
      
  
  }
}