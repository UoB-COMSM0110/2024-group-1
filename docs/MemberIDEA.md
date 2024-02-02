# Document for team members to suggest game ideas

## Idea about Implementing a 3D Card Game with Java and Processing

---

author: Ricardo Pu

date: 2024-02-01

last_modified_at: 

modified_by:

---

When creating a 3D card game using Java and the Processing library, here's a detailed implementation plan:

## 1. Setting Up the Basic Environment

- Install Processing and create a new project.
- Create a subclass of Processing's PApplet to serve as the game's main class.

```java
import processing.core.PApplet;

public class CardGame extends PApplet {
  public static void main(String[] args) {
    PApplet.main("CardGame");
  }

  // Write game code here
}
```


## 2. Creating Card Objects

- Use `PShape` or another appropriate method to create the 3D models for the cards.
- Use Java classes to represent the properties and effects of cards, such as attack power, health, etc.

```java
class Card {
  PShape cardModel;
  String name;
  int attack;
  int health;

  // Constructor and other methods
}
```

## 3. Card Collection and Management

Create a card library containing cards of different types and rarities. Allow players to build decks by selecting cards from the card library.

```java
ArrayList<Card> cardLibrary = new ArrayList<>();
ArrayList<Card> playerDeck = new ArrayList<>();

// Initialize card library and player deck
```

## 4. Game Map and Battles

- Design a 3D game map where players can move their characters or units.
- Implement the logic for battles between players and opponents, including attacks, defense, and card effects.

    ```java
    class GameMap {
      PShape mapModel;

      // Map properties and methods
    }

    class Opponent {
      String name;
      int health;
      ArrayList<Card> hand;

      // Opponent properties and methods
    }
    ```

## 5. Card Effects and Upgrades

- Write methods for each card to execute its effects, such as attacking opponents or healing.
- Implement card upgrading and evolution functions, possibly using Java classes and methods to manage changes in card properties.

## 6. User Interface (UI)

- Create an interactive user interface that allows players to manage their decks, view card information, and perform actions.
- Use Processing's drawing functions to render UI elements, such as buttons, text, and card images.

    ```java
    void drawUI() {
      // Draw UI elements
    }
    ```

## Dungeon Crawler Game Idea

---

author: Samuel Arnold-Parra

date: 2024-02-01

last_modified_at: 

modified_by:

---

I'd like to suggest a first person dungeon crawler game, which could be implemented in either 2D or 3D.
This game would involve the player traversing a dungeon environment, fighting enemies in random
encounters. The player would aim to collect treasure and get deeper in the dungeon, as well as
obtain items which could make them stronger or which provide healing effects.

Three challenges I can think of for this project include:

1. Whether the game is implemented using 2D or 3D, getting the game to render appropriately will
be a challenge. In the case of 2D, it will be necessary to work out perspective maths so that
the illusion of 3D depth is created. In the case of 3D, creating a functioning camera system will
be a challenge.

2. Creating smooth and appropriate transitions between game states (start screen, dungeon
traversal, combat, etc).

3. Creating a combat system with sufficient balance and depth will pose a challenge
in the development of this game idea.
