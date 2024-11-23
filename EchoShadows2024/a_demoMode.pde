void demoMode() {
  
    println("Demo Mode is on.");
    println("Please select fixture unit.");
    for(int i = rChan; i<lightChannels; i++) {
      unit1.sendValue(i, 0);
      unit2.sendValue(i, 0);
      unit3.sendValue(i, 0);
      unit4.sendValue(i, 0);
    }
}
