import java.util.HashMap;

class CardImgLoader {
    private HashMap<String, PImage> cardImgs;

    CardImgLoader() {
        cardImgs = new HashMap<String, PImage>();
        cardImgs.put("Strike", loadImage("../assets/cards/Attack_Strike.png"));
        cardImgs.put("Deadly Poison", loadImage("../assets/cards/Skill_Deadly Poison.png"));
        cardImgs.put("Anger", loadImage("../assets/cards/Attack_Anger.png"));
        cardImgs.put("Bash", loadImage("../assets/cards/Attack_Bash.png"));
        cardImgs.put("Blizzard", loadImage("../assets/cards/Attack_Blizzard.png"));
        cardImgs.put("After Image", loadImage("../assets/cards/Power_After Image.png"));
        cardImgs.put("Defence", loadImage("../assets/cards/Skill_Defence.png"));
        cardImgs.put("Bludgeon", loadImage("../assets/cards/Attack_Bludgeon.png"));
        cardImgs.put("Cleave", loadImage("../assets/cards/Attack_Cleave.png"));
        cardImgs.put("Bodyslam", loadImage("../assets/cards/Attack_Bodyslam.png"));
        cardImgs.put("Hemokinesis", loadImage("../assets/cards/Attack_Hemokinesis.png"));
        cardImgs.put("Iron Wave", loadImage("../assets/cards/Attack_IronWave.png"));
        cardImgs.put("Shrug It Off", loadImage("../assets/cards/Skill_ShrugItOff.png"));
        cardImgs.put("Thunderclap", loadImage("../assets/cards/Attack_Thunderclap.png"));
        cardImgs.put("Headbutt", loadImage("../assets/cards/Attack_Headbutt.png"));
    }

    public PImage getImg(String cardName) {
        return cardImgs.get(cardName);
    } 
}