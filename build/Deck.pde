import java.util.ArrayList;
import java.util.Collections;

class Deck {
    private ArrayList<Card> deck;
    int deckLimit;
    private final int CARDS_BASE_X = (width/2)-1050;
    private CardImgLoader cardImages;
    
    Deck(int limit) {
        deck = new ArrayList<Card>();
        cardImages = new CardImgLoader();
        deckLimit = limit;
        initDeck();
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
        int toDraw = min(numCards, deck.size());
        int drawX = CARDS_BASE_X;

        while (toDraw > 0) {
            Card drawn = deck.get(0);
            deck.remove(0);
            drawn.setPos(drawX, (height/2)+250);
            drawn.setImg(cardImages.getImg(drawn.getName()));
            toRet.add(drawn);
            toDraw--;
            drawX = drawX + 350;
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
        deck.clear();
        deck.addAll(newDeck);
    }

    public boolean isEmpty() {
        return deck.isEmpty();
    }

    private void initDeck() {
        deck.add(new StrikeCard());
        deck.add(new StrikeCard());
        deck.add(new StrikeCard());
        deck.add(new StrikeCard());
        deck.add(new StrikeCard());
        deck.add(new DefenceCard());
        deck.add(new DefenceCard());
        deck.add(new DefenceCard());
        deck.add(new DefenceCard());
        deck.add(new DefenceCard());
    }
}