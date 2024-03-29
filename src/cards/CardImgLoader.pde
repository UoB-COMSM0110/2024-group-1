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
        // Todo: Add Defence Card here once asset is ready
    }

    public PImage getImg(String cardName) {
        return cardImgs.get(cardName);
    } 
}