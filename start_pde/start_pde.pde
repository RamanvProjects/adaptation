import igeo.*;
import processing.opengl.*;

void setup(){
  size(480,360,IG.GL);
  for(int i=0; i < 100; i++){
    new MyParticle(IRand.pt(-50,-50,0,50,50,0), new IVec(0,0,0));
  }
  IG.bg(0);
}

class MyParticle extends IParticle{
  int state = 0; // initial state
  
  MyParticle(IVec p, IVec v){
    super(p, v);
    fric(0.05); // 5% friction
  }
  
  void interact(ArrayList < IDynamics > agents){
    for(int i=0; i < agents.size(); i++){
      if(agents.get(i) instanceof MyParticle){
        MyParticle ptcl = (MyParticle)agents.get(i);
        if(ptcl != this){
          if(ptcl.pos().dist(pos()) < 15){ // closer than 15
            IVec dif = pos().dif(ptcl.pos()); //other to this
            dif.len(20); // intensity of force
            if(state==1){ // attraction
              ptcl.push(dif);
            }
            else if(state==2){ // repulsion
              ptcl.pull(dif);
            }
          }
        }
      }
    }
  }
  
  void update(){
    if (IRand.pct(10)) {
        push(IRand.pt(-500, -500, 0, 500, 500, 0));
    }
    
    if(IRand.pct(1)){ // switch state
      if(state==0){ // state 0 -> 1
        state = 1; // attraction
        clr(1.0,0,1.0);
      }
      else if(state==1){ // state 1 -> 2
        state = 2; // repulsion
        clr(0,0,1.0);
      }
      else{ // state 2 -> 0
        state = 0; // random walk only
        clr(0.5);
      }
    }
    
    if(time()%20 == 0){
      new Anchor(pos().cp());
    }
  }
}

class Anchor extends IAgent{
  IVec pos;
  IPoint point;
  Anchor(IVec p){ 
    pos = p; 
    point = new IPoint(pos).clr(1.0,0,0).size(2);
  }
  
  void interact(ArrayList < IDynamics > agents){
    if(time()==0){ // only when the first time
      for(int i=0; i < agents.size(); i++){
        if(agents.get(i) instanceof Anchor){
          Anchor a = (Anchor)agents.get(i);
          if(a!=this && a.time() > 0){ // exclude anchors just created
            if(a.pos.dist(pos) < 10){ // closer than 10
              new ICurve(a.pos, pos).clr(1.0,0.1);
            }
          }
        }
      }
    }
  }
  void update(){
    if(time()==100){ // delete after 100 time frame
      point.del();
      del();
    }
  }
}
