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
            nodes.add(node);
        }

        return nodes.toArray(new Node[nodes.size()]);
    }

    private Node createNode(int id, int[] connectedIds, boolean clickable, PVector position, int x, int y, String level, String type) {
        switch (type) {
            case "CombatNode":
                return new CombatNode(id, connectedIds, clickable, position, x, y, level);
            // case "ShopNode"
            default:
                return new Node(id, connectedIds, clickable, position, x, y, level);
        }
    }
}
