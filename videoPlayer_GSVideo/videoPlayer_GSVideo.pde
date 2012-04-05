import codeanticode.gsvideo.*;
import fullscreen.*; 

GSMovie video;
FullScreen fs;

PFont font;

// Setta la il percorso della cartella in cui sono contenuti i video
String videoPath = "C:/Users/Federico/Videos/videoProcessing/";
// Scaletta dei video possibili da riprodurre
String [] videoTitle = {
  "video-2012-03-29-15-53-44.mp4", 
  "Video0001.avi"
};

boolean loadVideo = true;
int nowPlaying;

void setup()
{
  size(screenWidth, screenHeight);
  background(0); // sfondo nero

  font = loadFont("Calibri-Bold-48.vlw");
  textFont(font, 32);

  fs = new FullScreen(this);
}

// Questa funzione viene richiamata in automatico ogni volta che un frame è disponibile
void movieEvent(GSMovie video) {
  video.read();
}

void draw()
{
  background(0);
  if ( loadVideo == true ) {
    video = new GSMovie(this, videoPath+videoTitle[nowPlaying]);
    video.play();
    // metodo per mettere un video in loop:
    // video.loop();
    loadVideo = false;
  }
  int videoHeight = video.getSourceHeight();
  int videoWidth  = video.getSourceWidth();
  image(video, (screenWidth-videoWidth)/2, 100);
  text("H: "+videoHeight, 150, height-20);
  text("W: "+videoWidth, 10, height-20);

  secondToHMS((int)video.duration(), 350, height-20);
  secondToHMS((int)video.time(), 550, height-20);
}

void keyPressed()
{
  switch (key) {
  case '1':  // seleziono il terzo video
    video.stop();
    nowPlaying = 0;
    loadVideo = true;
    break;
  case '2':  // seleziono il secondo video
    video.stop();
    nowPlaying = 1;
    loadVideo = true;
    break;
  case 's':  // metto il video in Stop
    video.stop();
    break;
  case 'p':  // metto il video in Play
    video.play();
    break;
  case 'x':  // metto il video in Pausa
    video.pause();
    break;
  case 'f':  // modalita' Full Screen
    fs.enter();
    break;
  }

  if (keyCode == LEFT)
    video.jump(video.time()-0.25);
  else if (keyCode == RIGHT)
    video.jump(video.time()+0.25); 
}

void secondToHMS(int seconds, int w, int h) {
  String Hours = "", Minutes = "", Seconds = "";

  int hours = seconds/3600;
  int minutes = (seconds%3600)/60;
  seconds = (seconds%3600)%60;

  if (hours < 10)
    Hours ="0"+hours;
  else
    Hours += hours;

  if (minutes < 10)
    Minutes ="0"+minutes;
  else
    Minutes += minutes;

  if (seconds < 10)
    Seconds ="0"+seconds;
  else
    Seconds += seconds;

  text(Hours+":"+Minutes+":"+Seconds, w, h);
}

