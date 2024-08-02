import peasy.*;
import java.util.Collections;

// -------------------- Variables --------------------
float   RAIN_INTENSITY        = 0.2f;   // mm/h

int     DROPS_NB_MAX          = 50000;  // uniteless
float   DROPS_SIZE_MIN        = 2.f;    // mm
float   DROPS_SIZE_MAX        = 8.f;    // mm
float   DROPS_CX              = 0.47f;

// -------------------- Constants --------------------
PVector WIND                  = new PVector(-50.f, 25.f,5.f);  // m/s
PVector GRAVITY               = new PVector(  0.f,9.81f,0.f);  // m/s 
float   DELTA_TIME            = 0.02f;  // s

// -------------------- Drops bag parametters --------------------
float DROP_BAG_RANGE          = 100.f; // m (length maximum between center and border of drop bag)

PeasyCam camera;
Drop[] drops = new Drop[DROPS_NB_MAX];
ArrayList<Object> obstacles = new ArrayList<>();
//DropsBag dropsBag = new DropsBagSphere(new PVector(0.f,0.f,0.f), DROP_BAG_RANGE);
DropsBag dropsBag = new DropsBagBox(new PVector(0.f,0.f,0.f), DROP_BAG_RANGE);
//DropsBag dropsBag = new DropsBagFrustum(new PVector(0.f,0.f,0.f), DROP_BAG_RANGE, 25.f, 100.f);

void setup(){
  size(1200,800,P3D);
  
  textSize(50.);
  textAlign(CENTER);
  
  camera = new PeasyCam(this,2.2*DROP_BAG_RANGE);
  camera.setMinimumDistance(0.001f);
  camera.setMaximumDistance(1000.f);
  
  //obstacles.add(new Object(new PVector(0.f,0.f,0.f),color(0,127,127),500.f ,"./assets/plane.obj"));
  //obstacles.add(new Object(new PVector(0.f,0.f,0.f),color(0,127,127),DROP_BAG_RANGE*0.1f ,"./assets/cube.obj"));

  for(int i=0; i<DROPS_NB_MAX ;i++) drops[i] = new Drop();
}


void draw(){  
  float lambda = getLambda();
  float dropsNeed = min((RAIN_INTENSITY < 0.01f) ? 0 : floor(dropsBag.getVolume() * 8000.f/lambda * exp(-lambda*DROPS_SIZE_MIN)),DROPS_NB_MAX);
  //WIND = PVector.mult(new PVector(10.f,0.f,0.f),3.*cos(frameCount*0.01));
  
  /*****************************************************************************************
   *****************                        DISPLAY                        *****************
   *****************************************************************************************/
  background(0.);
  lights();
  
  // ------ DISPLAY DROPS SPHERE ------
  dropsBag.display();
  
  // ------ DISPLAY OBSTACLES ------
  beginShape(TRIANGLES);
  noStroke();
  obstacles.forEach(o -> o.vertices());
  endShape(CLOSE);
  
  // ------ DISPLAY DROPS ------
  stroke(0,0,255);
  for(int i=0; i<DROPS_NB_MAX ;i++) drops[i].display();
  
  // ------ DISPLAY HUD ------
  camera.beginHUD();
  fill(255);
  text("Number drops : " + (int) dropsNeed, width*0.5f,height*0.1f,0.f);
  camera.endHUD();
  
  /*****************************************************************************************
   *****************                         UPDATE                        *****************
   *****************************************************************************************/
  for(int i=0; i<dropsNeed ;i++) drops[i].recycle(dropsBag.getMovement());
  
  for(int i=0; i<DROPS_NB_MAX ;i++) {
    drops[i].updatePosition();
    drops[i].updateIntersection();  
  }
  
  //dropsBag.update(new PVector(100.f*cos(0.1*frameCount),0.f,0.f));
}

void keyPressed(){
  switch(key){
    case CODED : switch(keyCode){
      case UP : RAIN_INTENSITY += 0.1; break;
      case DOWN : RAIN_INTENSITY -= 0.1; break; 
      case RIGHT : RAIN_INTENSITY += 0.01; break;
      case LEFT : RAIN_INTENSITY -= 0.01; break;
    } break;
    case 'i' : 
      println("frameRate: "+frameRate);
      println("intensity rain: "+RAIN_INTENSITY); 
      break;
  }
}
