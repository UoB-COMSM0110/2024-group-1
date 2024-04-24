import javax.sound.sampled.*;
import java.io.*;


public class MusicLoader{
    Clip clip;

    public MusicLoader(){
    }

    void musicLoad(String path) {
        try {
            // Open audio file 
            AudioInputStream audioInputStream = AudioSystem.getAudioInputStream(new File(path).getAbsoluteFile());
            // Get a clip
            clip = AudioSystem.getClip();
            // Load it
            clip.open(audioInputStream);
        } catch (UnsupportedAudioFileException | IOException | LineUnavailableException e) {
            System.out.println("Error with playing sound.");
            e.printStackTrace();
        }
    }

    void musicPlay() {
        if (clip != null) {
            clip.start();
            clip.loop(Clip.LOOP_CONTINUOUSLY);
        }
    }

    void musicStop() {
        if (clip != null) {
            clip.stop();
        }
    }

    void pause() {
        if (clip != null && clip.isRunning()) {
            clip.stop();
        }
    }

    void resume() {
        if (clip != null && !clip.isRunning()) {
            clip.start();
        }
    }


}
