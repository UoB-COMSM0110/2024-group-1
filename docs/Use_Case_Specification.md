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

2. In the course of play, the player loses several enemy encounters,
choosing to sacrifice some of their movement points rather than
health.

3. Over the course of further play, the player loses further
encounters. Knowing that they can't afford to lose more
movement points, the player takes health damage until
their health drops to 0.

4. Having lost all their health points, the player is shown
a game over screen and can return to the main menu.

# Extension Points
There can be easy mode and hard mode, which differs in the players' and monsters' HP and XP. When the player obtains treasures, their XP and HP may get updated.