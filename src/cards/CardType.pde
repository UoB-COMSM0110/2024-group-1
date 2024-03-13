public enum CardType {
    CARDTYPE_ATTACK {
       @Override
       public String toString() { return "Attack"; }
    },
    CARDTYPE_DEFENCE,
    CARDTYPE_STRATEGY;
    
    
    //factory method -> create instances of cardtype based on string representations -> more readable? 
   public static CardType factory(String name) {
     if (name.equals(CARDTYPE_ATTACK.toString())) {
       return CardType.CARDTYPE_ATTACK;
     } else if (name.equals(CARDTYPE_DEFENSE.toString())) {
       return CardType.CARDTYPE_DEFENSE;
     } else if (name.equals(CARDTYPE_STRATEGY.toString())) {
       return CardType.CARDTYPE_STRATEGY;
     } else {
       return null;
     }
   }
}
