package store;

import cards.Card;
import entities.Player;
import store.exceptions.DeckFullException;
import store.exceptions.ItemNotAvailable;
import store.exceptions.NotEnoughGoldException;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;

public class Store {
    private static final String FILE_PATH = "shop.csv";
    private final ArrayList<Item> items;

    public Store() {
        this.items = new ArrayList<>();
        readFile();
    }

    public ArrayList<Item> getItems() {
        return items;
    }

    private void readFile() throws FileNotFoundException {
        File file = new File(FILE_PATH);
        Scanner scanner = new Scanner(file);

    }

    public Card buyCard(Player player, int index) {
        try {
            Item item;

            try {
                item = items.get(index);
            } catch (IndexOutOfBoundsException e) {
                throw new IndexOutOfBoundsException("Item not found");
            }

            Card card = item.buy(player);

            items.remove(index);

            return card;
        } catch (DeckFullException | ItemNotAvailable | NotEnoughGoldException | IndexOutOfBoundsException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
}
