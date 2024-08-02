public abstract class DropsBag{
  protected PVector _positionOld;
  protected PVector _position;
  
  public DropsBag(PVector p_center){
    this._positionOld = new PVector(0.f,0.f,0.f);
    this._position = p_center;
  }
  
  public PVector getMovement(){
    return PVector.sub(_position,_positionOld);
  }
  
  public abstract float getVolume();
  public abstract void update(PVector p_newPos);
  public abstract void display();
  public abstract boolean isOutside(PVector p);
  public abstract PVector sampleSurface(PVector p_ray);
}
