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
Once the players filed in any of the battles, game ends and shows the results to the player.

1. At the beginning of the game, the player chooses one of several
starting points on the map.

2. The player has no more action points to move, game ends and back to the menu directly.

3. The player lost all the lifes during combating with the enemies, also game ends and back to the menu directly.

# Extension Points
There can be easy model and hard model, which differs in the players' and monsters' HP and XP. When the players meet treasures, their XP and HP may get updated.