void pureGreen() {

      for (int i = 2; i<lightChannels; i+=chanInterval+chanInterval*1) {
        
        unit1.sendValue(i,green);
        unit2.sendValue(i,green*gP2);
        unit3.sendValue(i,green);
        unit4.sendValue(i,green*gP2);
        
      }
      
      
   
}
