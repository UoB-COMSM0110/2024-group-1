import java.util.HashMap;

class EntityImgLoader {
    private HashMap<String, PImage> entityImgs;

    EntityImgLoader() {
        entityImgs = new HashMap<String, PImage>();
        entityImgs.put("Worm", loadImage("../assets/entities/worm.png"));
    }

    public PImage getImg(String entityName) {
        return entityImgs.get(entityName);
    } 
}