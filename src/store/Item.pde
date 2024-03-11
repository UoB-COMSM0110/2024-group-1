package store;

import cards.Card;
import cards.Deck;
import entities.Player;
import store.exceptions.DeckFullException;
import store.exceptions.ItemNotAvailable;
import store.exceptions.NotEnoughGoldException;

public class Item {
    private final Card card;
    private final int cost;
    private boolean available;

    public Item(Card card, int cost, boolean available) {
        this.card = card;
        this.cost = cost;
        this.available = available;
    }

    public Card getCard() {
        return card;
    }

    public int getCost() {
        return cost;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Card buy(Player player) throws ItemNotAvailable, NotEnoughGoldException, DeckFullException {
        if (!available) {
            throw new ItemNotAvailable();
        }

        if (player.getGoldOnHand() < cost) {
            throw new NotEnoughGoldException();
        }

        if (player.getDeck().isFull()) {
            throw new DeckFullException();
        }

        player.decrementGold(cost);

        return card;
    }
}
