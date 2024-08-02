public class DropsBagSphere extends DropsBag {
  private float _radius;
  
  public DropsBagSphere(PVector p_center, float p_range){
    super(p_center);
    this._radius = p_range;
  }
  
  public float getVolume(){ return 4.f/3.f* PI*_radius*_radius*_radius; }
  
  public void update(PVector p_newPos){
    _positionOld.set(_position);
    _position.set(p_newPos);
  }
  
  public void display(){
    noFill();
    stroke(255);
    strokeWeight(1.f);
    sphereDetail(32,16);
    pushMatrix();
    translate(_position);
    sphere(_radius);
    popMatrix();
  }
  
  public boolean isOutside(PVector p){
    return (_radius<PVector.dist(_position,p));
  }
  
  PVector sampleSurface(PVector p_ray){
    float theta = random(0.f,PI*2.f);
    float phi   = random(0.f,PI*2.f);
    
    PVector res = new PVector(_radius*sin(theta)*cos(phi), _radius*sin(theta)*sin(phi), _radius*cos(theta));
    
    if(PVector.dot(p_ray,res)>0.f) res.mult(-1.f);
    res.add(PVector.mult(p_ray.normalize(),random(0.01f,p_ray.mag())));
    res.add(_position);
    
    return res;
  }
}
