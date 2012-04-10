/* Video Player with GSVideo library
 *
 * You can load multiple videos from and select wich play by
 * typing different numbers on your keyboard
 * Other keyboard controls:
 * - 'f' enter or leave full screen mode
 * - 'p' play or pause the video
 * - 's' stop the video
 * - 'l' enter o leave loop mode
 * - LEFT_ARROW go forward with 0.25s steps
 * - RIGHT_ARROW go backwaes with 0.25s steps
 *
 * created on 4/4/12
 * by Federico Vanzati (f.vanzati@arduino.cc) ~ Officine Arduino
 * 
 */
import codeanticode.gsvideo.*;
import fullscreen.*; 

GSMovie video;
FullScreen fs;

PFont font;

// Sets the path to the folder where the videos are contained 
String videoPath = "C:/Users/Federico/Videos/videoProcessing/";
// Compose the playlist of the video to reproduce
String [] videoTitle = {
  "LottieLemonAtMonza480p.mp4", 
  "giroAlFablab720p.mp4"
};

boolean loadVideo = true;
boolean wantLooping = false;
boolean fullScreen = true, playStop_switch = true, setLoop = true;
int nowPlaying;

void setup()
{
  size(screenWidth, screenHeight);
  background(0); // sfondo nero

  font = loadFont("Calibri-Bold-48.vlw");
  textFont(font, 32);

  fs = new FullScreen(this);
  // Allow keyboard shortcuts to enter/leave full screen mode
  // Windows, Linux: CTRL+F
  // OS X: ⌘+F  
  fs.setShortcutsEnabled(true);
}

// every time a frame is available this function is called automatically
void movieEvent(GSMovie video) {
  video.read();
}

void draw()
{
  background(0);  // black background
  // Every time you change the video you want to play, the video
  // must be loaded
  if ( loadVideo == true ) {
    video = new GSMovie(this, videoPath+videoTitle[nowPlaying]);
    if (wantLooping == true)
      video.loop();
    else
      video.play();

    loadVideo = false;
  }
  int videoHeight = video.getSourceHeight(); // read from the video its frame height (pixel) 
  int videoWidth  = video.getSourceWidth(); // read from the video its frame width (pixel)
  int verticalGap;
  if (videoHeight <= 480)
    verticalGap = 100;
  else 
    verticalGap = 0;
  image(video, (screenWidth-videoWidth)/2, verticalGap); // display the current frame on the screen
  text("H: "+videoHeight, 150, height-20); // print the video height
  text("W: "+videoWidth, 10, height-20); // print the video width

  // print the video duration time
  secondToHMS((int)video.duration(), 350, height-20);
  // print the current video playing time
  secondToHMS((int)video.time(), 550, height-20);

  if (wantLooping == true)
    text("in Loop", width-100, height-20);
}

// This function trigger the keyboard strokes and read the keys
void keyPressed()
{
  switch (key) {
  case '1':  // select the first video
    video.stop();
    nowPlaying = 0;
    loadVideo = true;
    break;
  case '2':  // select the second video
    video.stop();
    nowPlaying = 1;
    loadVideo = true;
    break;
  case 'p':  // Play or Pause the video
    if (playStop_switch == true) {
      video.play();
      playStop_switch = false;
    } 
    else {
      video.pause();
      playStop_switch = true;
    }
    break;
  case 's':  // Stop the video
    video.stop();
    break;
  case 'f':  // Full Screen Mode
    if (fullScreen == true) {
      fs.enter();
      fullScreen = false;
    } 
    else {
      fs.leave();
      fullScreen = true;
    }
    break;
  case 'l':
    if (setLoop == true) {
      wantLooping = true;
      setLoop = false;
      loadVideo = true;
    } 
    else {
      wantLooping = false;
      setLoop = true;
      loadVideo = true;
    }
    break;
  }

  // by typing the keyboard left arrow to jump 0.25 seconds forward
  if (keyCode == LEFT)
    video.jump(video.time()-0.25);
  // by typing the keyboard left arrow to jump 0.25 seconds backward
  else if (keyCode == RIGHT)
    video.jump(video.time()+0.25);
}

// This function transform time expressend in seconds in the 
// common format: HH:MM:SS
void secondToHMS(int seconds, int w, int h) {
  String Hours = "", Minutes = "", Seconds = "";

  int hours = seconds/3600;
  int minutes = (seconds%3600)/60;
  seconds = (seconds%3600)%60;

  // if the number is less than two digit, put a "0" before
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

  // compose the text to be displayed
  text(Hours+":"+Minutes+":"+Seconds, w, h);
}

