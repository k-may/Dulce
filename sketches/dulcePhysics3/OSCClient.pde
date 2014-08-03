class OSCClient {

  OscP5 oscClient;
  NetAddress myBroadcastLocation; 

  OSCClient(PApplet parent) {
    oscClient = new OscP5(parent, 8000);
    myBroadcastLocation = new NetAddress("192.168.2.13", 8000);
  }

  void send() {
    println("pressed : ");
    /* create a new OscMessage with an address pattern, in this case /test. */
    OscMessage myOscMessage = new OscMessage("/keyz");
    /* add a value (an integer) to the OscMessage */
    myOscMessage.add(0);
    myOscMessage.add(1);
    /* send the OscMessage to a remote location specified in myNetAddress */
    oscClient.send(myOscMessage, myBroadcastLocation);
  }
  
  void sendPan(float val){
        println("pressed : ");
    /* create a new OscMessage with an address pattern, in this case /test. */
    OscMessage myOscMessage = new OscMessage("/keyz/pan");
    /* add a value (an integer) to the OscMessage */
    myOscMessage.add(val);
    /* send the OscMessage to a remote location specified in myNetAddress */
    oscClient.send(myOscMessage, myBroadcastLocation);
  }
}

