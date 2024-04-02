import java.util.HashMap;

class EntityImgLoader {
    private HashMap<String, PImage> entityImgs;

    EntityImgLoader() {
        entityImgs = new HashMap<String, PImage>();
        entityImgs.put("Worm", loadImage("../assets/entities/worm.png"));
        entityImgs.put("Spider", loadImage("../assets/entities/spider.png"));
    }

    public PImage getImg(String entityName) {
        return entityImgs.get(entityName);
    } 
}