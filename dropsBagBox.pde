public class DropsBagBox extends DropsBag{
  private float _size;
  
  private PVector[] vertex = new PVector[8];
  private PVector[] normales = new PVector[6];
  private int[] faces = new int[24];
  
  public DropsBagBox(PVector p_center, float p_range){
    super(p_center);
    this._size = p_range/sqrt(3.f);
    
    vertex[0] = new PVector( _size, _size, _size);
    vertex[1] = new PVector(-_size, _size, _size);
    vertex[2] = new PVector( _size,-_size, _size);
    vertex[3] = new PVector(-_size,-_size, _size);
    vertex[4] = new PVector( _size, _size,-_size);
    vertex[5] = new PVector(-_size, _size,-_size);
    vertex[6] = new PVector( _size,-_size,-_size);
    vertex[7] = new PVector(-_size,-_size,-_size);
    
    normales[0] = new PVector( 1.f, 0.f, 0.f);
    normales[1] = new PVector(-1.f, 0.f, 0.f);
    normales[2] = new PVector( 0.f, 1.f, 0.f);
    normales[3] = new PVector( 0.f,-1.f, 0.f);
    normales[4] = new PVector( 0.f, 0.f, 1.f);
    normales[5] = new PVector( 0.f, 0.f,-1.f);
    
    faces[ 0] = 1; faces[ 1] = 3; faces[ 2] = 7; faces[ 3] = 5;
    faces[ 4] = 0; faces[ 5] = 2; faces[ 6] = 6; faces[ 7] = 4;
    faces[ 8] = 2; faces[ 9] = 6; faces[10] = 7; faces[11] = 3;
    faces[12] = 1; faces[13] = 0; faces[14] = 4; faces[15] = 5;
    faces[16] = 5; faces[17] = 4; faces[18] = 6; faces[19] = 7;
    faces[20] = 1; faces[21] = 0; faces[22] = 2; faces[23] = 3;
  
    this._updateVertex();
  }
  
  public float getVolume(){ return 8.f*_size*_size*_size; }
  
  public void update(PVector p_newPos){
    _positionOld.set(_position);
    _position.set(p_newPos);
    _updateVertex();
  }
  
  private void _updateVertex(){
    for(PVector vec : vertex) {
      vec.sub(_positionOld);
      vec.add(_position);
    }
  }
  
  public void display(){
    beginShape(QUADS);
    noFill();
    stroke(255);
    
    for(int i=0; i<24 ;i++)
        vertex(vertex[faces[i]]);
        
    endShape(CLOSE);
  }
  
  public boolean isOutside(PVector p){
    for(int i=0; i<6 ;i++){
      PVector mid = new PVector(0.,0.,0.);
      mid.add(vertex[faces[4*i  ]]);
      mid.add(vertex[faces[4*i+1]]);
      mid.add(vertex[faces[4*i+2]]); 
      mid.add(vertex[faces[4*i+3]]);
      mid.mult(0.25f);
      
      if(PVector.dot(PVector.sub(mid,p),normales[i])>0.f) return true;
    }
    return false;
  }
  
  public PVector sampleSurface(PVector vec){
    int i;
    
    PVector dir = vec.copy().normalize();
    
    float r = random(0.f,1.f);
    float u = random(0.f,1.f);
    float v = random(0.f,1.f);
    
    float[] prob = new float[] {max(0.f,PVector.dot(dir,normales[0])),0.f,0.f,0.f,0.f,0.f};
    for(i=1; i<6 ;i++)
      prob[i] = max(0.f,PVector.dot(dir,normales[i])) + prob[i-1];
    
    for(i=0; i<6 ;i++)
      if(prob[i]>=r*prob[5])
        break;
    
    PVector point = new PVector(0.f,0.f,0.f);
    point.add(PVector.mult(vertex[faces[4*i  ]], (1.f-u)*(1.f-v)));
    point.add(PVector.mult(vertex[faces[4*i+1]],       u*(1.f-v)));
    point.add(PVector.mult(vertex[faces[4*i+2]],       u*    v )); 
    point.add(PVector.mult(vertex[faces[4*i+3]], (1.f-u)*v     ));
    point.add(PVector.mult(normales[i],random(0.01,PVector.dot(vec,normales[i]))));
    
    return point;
  }
}
