import java.util.ArrayList;
import java.util.Collections;

class Deck {
    private ArrayList<Card> deck;
    int deckLimit;
    
    Deck(int limit) {
        deckLimit = limit;
        // Todo: add initialization of starting deck here
    }

    public void shuffle() {
        Collections.shuffle(deck);
    }

    public boolean setLimit(int limit) {
        if (limit < deck.size()) {
            return false;
        }
        deckLimit = limit;
        return true;
    }

    public int getLimit() {
        return deckLimit;
    }

    public Card drawSingleCard() {
        Card toRet = deck.get(0);
        deck.remove(0);
        return toRet;
    }

    public ArrayList<Card> drawNCards(int numCards) {
        if (numCards <= 0) {
            return new ArrayList<Card>();
        }

        ArrayList<Card> toRet = new ArrayList<Card>();
        int toDraw = Math.min(numCards, deck.size());

        while (toDraw > 0) {
            Card drawn = deck.get(0);
            deck.remove(0);
            toRet.add(drawn);
            toDraw--;
        }

        return toRet;
    }

    public boolean addCard(Card newCard) {
        if (deck.size() >= deckLimit) return false;

        deck.add(newCard);
        return true;
    }

    public ArrayList<Card> getDeck() {
        return deck;
    }

    public void setDeck(ArrayList<Card> newDeck) {
        deck = newDeck;
    }

    public boolean isEmpty() {
        return deck.isEmpty();
    }
}