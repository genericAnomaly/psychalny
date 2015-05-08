import processing.net.*;
import codeanticode.eliza.*;


Client simumech;
Eliza eliza;
String sLine = "Hello.";
String eLine = "Hello.";

//Config variables; fill in the information for your Simumech here.
String sName = "Sbnkalny";
String sHost = "mraof.com";
int sPort = 2932;
int duration = 64;

void setup() {
  readyEliza();
  readySimumech();
  
  println("> This conversation will last " + duration + " exchanges.");
  converse(duration);
  println("> Conversation duration reached. Press any key to continue it or 'q' to terminate the program.");
}

void readyEliza() {
  println("> Initialising ELIZA...");
  eliza = new Eliza(this);
  println("> Hello Doctor.");
  eLine = eliza.processInput("Hello Doctor.");
  println("ELIZA: " + eLine);
}

void readySimumech() {
  println("> Attempting to establish a connection with " + sName + "...");
  try {
    simumech = new Client(this, sHost, sPort);
  } catch (Exception e) {
    println("> Exception occured!");
  }
  if (simumech == null) {
    println("> Could not establish a connection to " + sName + ", aborting.");
    System.exit(1);
  }
  println("> Connection established!");
  
  println("> Requesting that " + sName + " not record this conversation to lines.txt...");
  simumech.write("$forget\n");
  println("> Hello " + sName + ".");
  sLine = send("Hello " + sName + ".");
  println(sName + ": " + sLine);
}



void keyPressed () {
  if (key == 'q') {
    simumech.stop();
    System.exit(0);
  }
  converse(10);
}

void draw() {
  //This needs to be here for the keyPressed method to work.
}

void converse(int duration) {
  for (int i=0; i < duration; i++) {
    sLine = send(eLine);
    println(sName + ": " + sLine);
    eLine = eliza.processInput(sLine);
    println("ELIZA: " + eLine);
  }
}


String send(String m) {
  //Synchronous send/receive method
  if (!m.endsWith("\n")) m = m + "\n";
  simumech.write(m);
  while ( !(simumech.available() > 0) ) {
    delay(100);
  }
  return simumech.readString().trim();
}




