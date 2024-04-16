# COMSM0110 2024 Group 1

## Group member
---

Samuel Arnold-Parra, uq23711@bristol.ac.uk, A-PS1999

Jasmine Thakral, dk23586@bristol.ac.uk, JThakral20

Zhuoli Feng, bx23489@bristol.ac.uk, erer1022

Lanai Huang, kq23993@bristol.ac.uk, Doctor-TOTORO

Ricardo Pu, kc23989@bristol.ac.uk, RicardoMiles

## Team photo
---
![image](https://github.com/UoB-COMSM0110/2024-group-1/blob/main/images/TeamPhoto.jpg)

# Introduction
Our game is a turn-based and card-based game. The player begins at the bottom of a node-based map with a simple deck of cards, with the objective of reaching the top of the map and beating the final boss there. Traversing the map requires the player to engage in other combat encounters, though there are also opportunities to obtain new cards at shop nodes which can be encountered on the way.

The game is inspired by existing card-based video games like <i>Slay the Spire</i> and <i>Hearthstone</i>, with additional aesthetic inspiration coming from fantasy games and dungeon crawler classics like <i>Eye of the Beholder</i>. The game's additional twist comes from the introduction of a system
of action points which enable the player's movement on the map and which can also be spent to save the player from losing the game if they are beaten
in a combat encounter.

The game distinguishes itself in providing emergent strategic gameplay which arises as a result of the range of cards which players can obtain and the
choices made possible by the action point system. In addition, the game's controls are simple given that only mouse or trackpad clicks are required as input, making the game accessible to a broad range of users.

# Requirements

## Ideation
Our team's ideation process began with a group brainstorming session, from which two main game ideas rapidly emerged. The first was the card-based
game idea, whereas the second was a first-person dungeon crawler game in the style of games like <i>Legend of Grimrock</i>. We then went about
creating paper prototypes of both of these ideas in order to flesh out the specifics of these ideas. Creating paper prototypes was also a valuable
exercise as it helped other team members, less familiar with video games and the concepts behind the ideas, to understand them better as well.

![image](https://github.com/UoB-COMSM0110/2024-group-1/blob/main/images/PaperPrototype1.gif)
*The paper prototype for the card-based game concept.*

[![Alt text](https://img.youtube.com/vi/VUtbDt9KXXw/0.jpg)](https://www.youtube.com/watch?v=VUtbDt9KXXw)

*Right-click and select "Open link in new tab" to watch the video without leaving GitHub.*

![IMG_8772 2](https://github.com/UoB-COMSM0110/2024-group-1/assets/120200385/1431ac4d-13f1-4315-8d47-d8e789c5737e)
![IMG_8776 2](https://github.com/UoB-COMSM0110/2024-group-1/assets/120200385/ae396519-d9d0-4ae7-aae0-ebaf6f93ed5c)
*Additional images of the paper prototype for the card-based game*

![prototype2](./images/PaperPrototype2.png)
*The paper prototype for the first person dungeon crawler idea. The nature of this concept made creating the prototype using computer tools like
LibreOffice Impress more appropriate than using literal paper.*

Having decided that we would use one of these two game ideas, we considered some of the challenges which we might face in the development of these
ideas. For the first-person dungeon crawler, the following three key challenges were identified:

1. Getting the game to render appropriately will be a challenge. In the case of 2D, it will be necessary to work out perspective maths so that
the illusion of 3D depth is created. In the case of 3D, creating a functioning camera system will be a challenge.

2. Creating smooth and appropriate transitions between game states (start screen, dungeon
traversal, combat, etc).

3. Creating a combat system with sufficient balance and depth will pose a challenge
in the development of this game idea.

Ultimately, additional research into the first-person dungeon crawler concept, in conjunction with a preliminary attempt to develop an appropriate
camera system for a 3D iteration of the idea, showed that the first-person dungeon crawler concept would likely be overly complicated to implement.
Consequently, our team decided to move forward with the card-based game concept instead. Nonetheless, as will be elaborated later in this report,
the card game concept also ran into the latter two challenges identified for the abandoned dungeon crawler game idea.

## User Stories and Use Case Diagram

Subsequently, we collaborated to create a use case diagram as a further means of solidifying our shared understanding of the game's high-level flow
and features. As our game is a single player concept, the only agent present within our use case diagram is a single player.

![UseCaseDiagram](./docs/UseCaseDiagram.png)

Though the use case diagram was useful for providing a high-level overview and an outline of the player's relationship to facets of the game, we 
found that it was not the best format for mapping out alternative/variable game flows. We found a use case specification (see below) more valuable for that purpose.

|   |Gameplay|
|---|--------|
|Description|A run through of the game, a turn-based card game for players to battle enemies in set encounters and earn action points.</br> Action points are used for movement during the game.|
|Preconditions|The player begins with a few action points.|
|<b>Basic Flow</b>|The aim is to reach and beat the boss encounter at the end, which necessitates beating enemies to collect action points and items, using them to reach the top.|
|1.|At the beginning of the game, the player chooses one of several starting points on the map.|
|2.|There will be enemies or treasures at each spot on the map. If encountering enemies, the player will have to engage in a turn-based card battle in order to obtain action points and proceed.|
|3.|Returning to the map screen, the action points obtained can be used to move to the next map space, with the possibility of spending extra points to move further.|
|4.|This flow repeats from 2 above, until the player reaches the top of the tower and wins the game.|
|<b>Alternative Flow|Illustrates the case where the player loses the game as a result of losing all their health points.|
|1.|At the beginning of the game, the player chooses one of several starting points on the map.|
|2.|In the course of play, the player loses several enemy encounters, choosing to sacrifice some of their movement points rather than health.|
|3.|Over the course of further play, the player loses further encounters. Knowing that they can't afford to lose more movement points, the player takes health damage until their health drops to 0.|
|4.|Having lost all their health points, the player is shown a game over screen and can return to the main menu.|

In addition, at this stage we brainstormed a range of user stories in order for us to keep in mind our key stakeholders and consider what goals
our game should set out to achieve. A selection of the user stories we developed are as follows:

> As a player, I want the game to have enough card variety and
strategic depth so that I feel challenged and entertained.

> As a player, I want to be able to see how much health I and enemies have left so that I can make strategic decisions
and feel a sense of urgency during the game.

> As a player, I want the game to have a variety of different encounters in order to keep the game fresh and provide a challenge.

# Implementation

Three key challenges emerged over the course of development and the brainstorming process which preceded it. Namely, these were:

1. How to most efficiently create, load and display game assets.

2. Flexible and balanced combat/encounter design

3. How to best integrate game states together

The specifics of each challenge and how we dealt with it will be elaborated in turn.

## Game Asset Handling

The card-based nature of our game made it more asset-heavy to implement than an alternative game concept (such as a platformer) may have been.
Broadly speaking, our team's members lacked 2D art skills, posing something of a challenge to creating passable game assets.
A key aspect to how we got around this obstacle was the use of AI image generation tools, which were used to enable the rapid generation of 
assets like the main screen, combat end screen and card illustrations. 

To save time in the creation of cards, our team put together a card template using PhotoShop with layers for different parts of a card,
a move which enabled the quick iteration of new cards while maintaining a consistent format and style.

![CardLayers](./assets/psds/Layer-function-description-1.jpg)

*An image highlighting the different layers of the card template .psd file*

Despite the value of AI tools for quick image generation, difficulty in using them for art direction and flaws in some of the AI generated images
meant that we did not rely exclusively on AI images for the game. Maya was used to create several combat state-related assets. Though the creation process was longer than using AI tools, it allowed the creation of a tailor-made environment which could be easily edited to meet our needs.

![3DEnvironment](./images/3DEnvironmentShot.png)
*A view of the 3D environment created for the battle screen's background from within Maya*

A second dimension of challenge came from loading the images. Originally each card was intended to load its own associated image. However, it became 
clear that this would cause excessive image loading. Instead we created a `CardImgLoader` class which loaded each card image only once and mapped them
to each card's name. A similar class was created for game entities. This choice reduced the previous excessive image loading, though the large number of assets nevertheless meant that some loading times were hard to avoid.

## Encounter Design

When it came to encounter and combat design, the first question our team confronted was around the use of procedural generation. After an 
initial attempt at developing the map screen procedurally, it became evident that using that approach was proving too complicated, prompting our team 
to opt for a hand-crafted map and encounters instead. Besides implementation complications, we also abandoned procedural generation as a consequence of
the difficulty it would have posed for consistent game balance.

Another aspect which proved challenging was how to lay out classes in a way that allowed for certain gameplay features to be implemented. Though our team had, using the class and use case diagrams, developed a good idea of the program's high level structure at an early stage, it was only after the key combat-related classes had been set up that it became clear that features like cards with effects based on the current state of combat would be a challenge to implement, as the `Card` class maintained no awareness of combat state. We were able to implement this feature by extending `CombatEncounter` to process the active card in order to calculate and apply state-related effects using a private function making use of a switch statement.

This experience highlighted the importance of planning out what features should be present in more detail prior to getting too far in
implementation.

## Game State System

As our game required various states to interact, it was important for us to develop a system which would make this possible. We opted for a stack-based
game state system, with each state receiving a reference to the top-level `GameEngine` object. This made it easier to update and pass around the 
player's data while also permitting each member of the team to work on a different state. This assisted us in dividing work and avoiding merge conflicts.
Nonetheless, this approach tested our teamwork abilities given that it required close coordination to have the states we were working on integrate together.

Tying in with encounter design, the use of JSON files for the map and JSON updating functions encapsulated in MapState allowed for maps to be easily updated and persisted between state transitions or even play sessions. This allowed us to easily amend game balance in line with feedback.



# Working as a team
The team used the Software Engineering labs as well as weekly in-person meetings to check in on our progress as a team. We used these meetings to identify anything we needed to clarify or get help with. We decided as a team what the essential game states that needed to be achieved for a minimum viable product were and what other game states could be completed later on for the final version of the game. On reflection, it would have been useful to organize an in-person meeting just before the Easter holidays to ensure we all had a clear idea of what we should working on each week of the holidays.

However, we were still able to communicate this effectively throughout the holidays using WhatsApp and GitHub to ensure we all knew what needed to be achieved. In order to communicate with each other, we set up a WhatsApp group chat where we organized in-person meetings. It was also used to check in with each other to assess our progress as a group. In addition, it was used for suggesting any small tweaks that needed to be made to the project.

## Tools used
We used GitHub to host and collaborate on the project. Each member used different branches for each feature of the game i.e. using a branch specifically for the menu state. This meant we always had a working version of the game on the main branch. We set up GitHub so that nothing could be merged into main without a pull request. This was valuable as it ensured we reviewed each other's code and helped ensure we were all aligned in terms of how we wanted to implement the different features of the game. In addition, using pull requests allowed any merge conflicts to be reviewed and resolved before being pushed to the main branch.

We knew that we potentially had a game that would be relatively complex to create due to the multiple game states we needed to implement. Therefore, it was essential to use a Kanban board to keep track of all the different features we wanted to develop and ensure that they could be completed in the given timeframe of the project. As a team, we divided the workload into different features/game states that needed to be completed. We then delegated different game states to each team member. This meant that each team member had a clear idea of what they should be working on. On reflection, perhaps we could have used the Kanban board more effectively by breaking up the tasks into smaller sub-tasks. For example, creating a task for creating a shop state could have been broken up into smaller sub-tasks within this state. This would have given a greater sense of the progress that had been made.

## Team roles
We divided the workload of the game according to the different game states. Sam worked on the overall structure of the game i.e. implementing the game engine and worked on the combat state in terms of both code and related assets. Ricardo created the map state, created a template for the cards and created other assets like buttons. Lanai worked on the end state of the game. Jasmine created the shop state. Zhuoli created the main menu as well as game assets such as the cards.

## Reflection on working together
Following the project schedule of the unit, we initially concentrated on creating a minimal viable product. One of the challenges we had was getting a minimum viable prototype working. This meant that we were further behind schedule than was ideal, making it challenging to carry out user testing of the game during the software engineering labs. Instead, we resorted to presenting paper prototypes of our game to users. This meant we still received user feedback and a greater understanding of the Think Aloud and Heuristic Evaluation techniques. We were then able to use these tests later on a far more developed version of the game.

## Perhaps we faced challenges with getting the minimum viable product working due to the fact that we were working on features individually. This made it more difficult to ensure smooth transitioning between the different game states. To resolve this issue, we carried out game-jam sessions, which helped us make effective progress on the game. Having an in-person session meant that we could discuss things we were unsure of so that we were more aligned on how we wanted to transition between different game states.
