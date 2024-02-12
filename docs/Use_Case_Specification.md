# Description
    A turn-based card game for players to battle enemies in random encounters and earn action points.

# Preconditions
    Few action points and cards will be given to the players at first.

# Basic Flow
    Win the battle to collect action points and items, use these action pointes to climb the tower to the top.

    1. At the beginning of the game, choose one of the entries to enter the tower.

    2. There will be enemies or treasures at each spot. The players need to choose a card to defeat the enemies so that can the player gets action points.

    3. The action points can be used to move to the next spot.

# Alternative Flow
    The game provides map interface and tutorial/helo interface. Once the players filed in any of the battles, game ends and shows the results to the player.

    1. If it's the first time to get into the game, there will be a tutorial/help interface to show how to play the game.

    2. When get lost in the maze, the players are allowed to look at the map to find where they are.

    3. After winning a battle, the players will get few action points, they can decide how many steps they want to move based on the points they have.

    4. After battle, the lost lives would  be implemented and all the cards would be reset.

    5. There are 2 types of cards: general cards and wasty cards. The general cards can be reused in a battle, but the wasty cards can only be used once.

    6. Whenever the battle is failed, game will end and show an ending interface to the players, including cards and action points they have, scores they get and the routine they have experienced. Then back to the main interface.

# Extension Points
    There can be easy model and hard model, which differs in the players' and monsters' HP and XP. When the players meet treasures, their XP and HP may get updated.