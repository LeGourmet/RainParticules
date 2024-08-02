public class DropsBagFrustum extends DropsBag{
  private float _size;
  private float _s1;
  private float _s2;
  
  private PVector[] vertex = new PVector[8];
  private PVector[] normales = new PVector[6];
  private int[] faces = new int[24];
  
  //, float p_range
  public DropsBagFrustum(PVector p_center, float p_range, float p_length1, float p_length2){
    super(p_center);
    this._s1 = p_length1*0.5f;
    this._s2 = p_length2*0.5f;
    this._size = sqrt(p_range*p_range - max(p_length1*p_length1,p_length2*p_length2)*0.5f);
    
    vertex[0] = new PVector( _s2, _s2, _size);
    vertex[1] = new PVector(-_s2, _s2, _size);
    vertex[2] = new PVector( _s2,-_s2, _size);
    vertex[3] = new PVector(-_s2,-_s2, _size);
    vertex[4] = new PVector( _s1, _s1,-_size);
    vertex[5] = new PVector(-_s1, _s1,-_size);
    vertex[6] = new PVector( _s1,-_s1,-_size);
    vertex[7] = new PVector(-_s1,-_s1,-_size);
    
    normales[0] = PVector.sub(vertex[3],vertex[7]).cross(PVector.sub(vertex[5],vertex[7])).mult(-1.).normalize();
    normales[1] = PVector.sub(vertex[6],vertex[2]).cross(PVector.sub(vertex[0],vertex[2])).mult(-1.).normalize();
    normales[2] = PVector.sub(vertex[2],vertex[6]).cross(PVector.sub(vertex[7],vertex[6])).mult(-1.).normalize();
    normales[3] = PVector.sub(vertex[0],vertex[1]).cross(PVector.sub(vertex[5],vertex[1])).mult(-1.).normalize();
    normales[4] = PVector.sub(vertex[7],vertex[6]).cross(PVector.sub(vertex[4],vertex[6])).mult(-1.).normalize();
    normales[5] = PVector.sub(vertex[2],vertex[3]).cross(PVector.sub(vertex[1],vertex[3])).mult(-1.).normalize();
    
    faces[ 0] = 1; faces[ 1] = 3; faces[ 2] = 7; faces[ 3] = 5;
    faces[ 4] = 0; faces[ 5] = 2; faces[ 6] = 6; faces[ 7] = 4;
    faces[ 8] = 2; faces[ 9] = 6; faces[10] = 7; faces[11] = 3;
    faces[12] = 1; faces[13] = 0; faces[14] = 4; faces[15] = 5;
    faces[16] = 5; faces[17] = 4; faces[18] = 6; faces[19] = 7;
    faces[20] = 1; faces[21] = 0; faces[22] = 2; faces[23] = 3;
  
    this._updateVertex();
  }
  
  public float getVolume(){ return 8.f/3.f * _size * (_s1*_s1+_s2*_s2+_s1*_s2) ; } //  H/3 * (AireBase1+AireBase2+sqrt(AireBase1*AireBase2))
  
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
      mid.mult(0.25);
      
      if(PVector.dot(PVector.sub(mid,p),normales[i])>0.) return true;
    }
    return false;
  }
  
  public PVector sampleSurface(PVector vec){
    int i;
    
    PVector dir = vec.copy().normalize();
    
    float r = random(0,1);
    float u = random(0,1);
    float v = random(0,1);
    
    float[] prob = new float[] {max(0.,PVector.dot(dir,normales[0])),0.,0.,0.,0.,0.};
    for(i=1; i<6 ;i++)
      prob[i] = max(0.,PVector.dot(dir,normales[i])) + prob[i-1];
    
    for(i=0; i<6 ;i++)
      if(prob[i]>=r*prob[5])
        break;
    
    PVector point = new PVector(0.,0.,0.);
    point.add(PVector.mult(vertex[faces[4*i  ]], (1.-u)*(1.-v)));
    point.add(PVector.mult(vertex[faces[4*i+1]],      u*(1.-v)));
    point.add(PVector.mult(vertex[faces[4*i+2]],      u*    v )); 
    point.add(PVector.mult(vertex[faces[4*i+3]], (1.-u)*v     ));
    point.add(PVector.mult(normales[i],random(0.01,PVector.dot(vec,normales[i]))));
    
    return point;
  }
}
