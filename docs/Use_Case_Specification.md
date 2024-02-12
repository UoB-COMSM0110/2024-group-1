# Description
A run through of the game, a turn-based card game for players to battle enemies in set encounters and earn action points.

Action points are used for movement during the game.

# Preconditions
The player begins with a few action points.

# Basic Flow
The aim is to reach the top of the tower, which necessitates
beating enemies to collect action points and items, using them
to reach the top.

1. At the beginning of the game, the player chooses one of several
starting points on the map.

2. There will be enemies or treasures at each spot on the map. If
encountering enemies, the player will have to engage in a turn-based
card battle in order to obtain action points and proceed.

3. Returning to the map screen, the action points obtained can
be used to move to the next map space, with the possibility of
spending extra points to move further.

4. This flow repeats from 2 above, until the player reaches the
top of the tower and wins the game.

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