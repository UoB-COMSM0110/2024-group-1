import processing.data.JSONArray;
import processing.data.JSONObject;
import processing.core.PVector;
import java.util.ArrayList; 

class MapLoader {
    JSONObject mapData;

    public MapLoader() {
    }

    public void loadNodesFromJSON(String jsonString) {
        mapData = parseJSONObject(jsonString);
    }

    public Node[] loadNodes() {
        ArrayList<Node> nodes = new ArrayList<Node>(); // Dynamic Store Nodes

        JSONArray allNodes = mapData.getJSONArray("nodes");
        for (int i = 0; i < allNodes.size(); i++) {
            JSONObject nodeJson = allNodes.getJSONObject(i);

            // load data
            String level = nodeJson.getString("level");
            int id = nodeJson.getInt("id");
            JSONArray connectedIdsJson = nodeJson.getJSONArray("connected_ids");
            int[] connectedIds = new int[connectedIdsJson.size()];
            for (int j = 0; j < connectedIdsJson.size(); j++) {
                connectedIds[j] = connectedIdsJson.getInt(j);
            }
            boolean clickable = nodeJson.getBoolean("clickable");
            int x = nodeJson.getInt("x");
            int y = nodeJson.getInt("y");
            String type = nodeJson.getString("type");

            // create node 
            Node node = createNode(id, connectedIds, clickable, new PVector(x, y), x, y, level, type);
            
            if (type.equals("ShopNode")) {
              ArrayList<Card> cards = new ArrayList<>();
//              System.out.println("[DEBUG] 
              
              JSONArray jsonCards = nodeJson.getJSONArray("cards");
              
              for (int j = 0; j < jsonCards.size(); j++) {
                JSONObject cardJson = jsonCards.getJSONObject(j);
                String cardName = cardJson.getString("name");
                
                if (cardName.equals("AngerCard")) {
                  cards.add(new AngerCard());
                } else if (cardName.equals("Poison")) {
                  cards.add(new PoisonCard());
                } else if (cardName.equals("Bash")) {
                  cards.add(new BashCard());
                } else if (cardName.equals("Strike")) {
                  cards.add(new StrikeCard());
                }
              }
              
              ((ShopNode)node).setCards(cards);
            }
            
            nodes.add(node);
            //System.out.println("[DEBUG] Added node: " + node.toString());
        }

        return nodes.toArray(new Node[nodes.size()]);
    }

    private Node createNode(int id, int[] connectedIds, boolean clickable, PVector position, int x, int y, String level, String type) {
        switch (type) {
            case "CombatNode":
                return new CombatNode(id, connectedIds, clickable, position, x, y, level);
            case "ShopNode":
                return new ShopNode(id, connectedIds, clickable, position, x, y, level);
            default:
                return null;// new Node(id, connectedIds, clickable, position, x, y, level);
        }
    }
}
