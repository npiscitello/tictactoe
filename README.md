# Structure
The board state is stored in a 3x3x2 bit array: we need at least 3 bits (blank, X, O) for each cell.
I tried to follow object oriented design principles as closely as possible here, specifically
encapsulation. Each module ('class' of sorts) fulfills a very specific function; see the code for
a lower level description:

* __main__ *routes signals between modules* - If this code were synchronous, it would also provide
  the system clock, but its asynchronous design obviates that feature.
* __board__ *manages board state* - Canonical state vars: `turn`, `board_state`. This module is the
  one that acutally handles turns. When each player clocks the submit line, this module interprets
  the data on the update location and reset lines and combines that with the turn state and board
  state to decide what's happening on the board.
* __output__ *lets the puny humans know what's up* - This module is completely decoupled from the
  game logic; it just reads the board state and spits it out to the screen. It can easily be adapted
  to a less conventional output, such as LEDs, for a hardware port. Basically, modifying this module
  has absolutely no effect on gameplay.
* __player__ *simulates human input* - Canonical state vars: `update_loc`, `submit`, `reset`. OK, so
  those canonical vars are a little bit of a lie; as mentioned in 'Operation', they're really only
  hooked up half the time. This module represents one player, probably a human but we don't
  descriminate. It's 'blind', in that it doesn't depend on the board state to make a move (more on
  that later). Of course, if this was being driven by a real player, they would choose their move
  based on the board state, but as we're just simulating one, we can predict what the AI is going to
  do and make life easy on ourselves by hard-coding in a pre determined game.
* __ai__ *your friendly neighborhood computer overlord* - Canonical state vars: `update_loc`,
  `submit`, `reset`. Those vars are only hooked up half the time; see 'Operation' for the reason
  why. This is the computer on the other side of the board. The board state is piped into this
  module so that the AI can make its decisions: it always tries to win first, then it tries to block
  a win set up by the player. If neither side has an opportunity to win, it just fills clockwise
  from the top left corner. The only exception to this is the first turn: if the player didn't take
  the center, the AI will.

There is one additional file, __defines__. This is just full of macros useful in the other modules;
mostly magic numbers with a few typedefs and functions thrown in for good measure.

# Operation
There is a 'turn' flag; when it's set, it's the AI's turn and when it's not, it's the player's turn.
The board update regs in both modules are hooked up to the wires through tri state buffers switched
on that turn flag. That's really all there is to it: each turn, the user (player or AI) has to set
the desired move location (or reset) and clock the 'submit' flag once (one rising and one falling
edge). We do this double flip because the board module looks for the falling edge; this guarantees
everything has been set and is stable before we start interpreting the input. It also eliminates
synchronization problems: by ensuring the submit flag in each module is set to zero at the end of
each turn, we don't have to pass state pertaining to it between the modules. I decided that time is
cheap and hardware (connecting wires, input/output definitions, and synchromization logic - thread 
safety, if you will) is expensive in this case. The turn is only flipped if a valid move has been
made. A reset moves it back to the player's turn, regardless of who called it. 

To ease testing and demonstration, a few full games have been preloaded into the player module. You
can choose one at compile time by editing the macro at the top of `player.v` or by specifying `-D
GAME_SELECTION=X` in the compile command. The games are listed below; to use one, plug in its number
for `X` in the command:

* __0__: The player takes the center but the AI wins. This is also the default game if no game is
  selected or the selection is invalid.
* __1__: The player takes the center and ties the AI.
* __2__: The AI takes the center and wins.
* __3__: The AI takes the center and ties the player.

Note that, due to the aggressive blocking, I have not found a game where the AI loses. This could be
considered a flaw in our AI algorithm: its very frustrating to play against someone who never makes
a mistake. We could mitigate this by adding in a random factor in every block and win check. In
other words, we could cause it to sometimes not block or win, even when it was supposed to. However,
this predictability is what allows us to specify these preset games in the first place. Since the AI
will never make a mistake and we know how it thinks, we always know where its next move is going to
be, which could be considered a weakness as well. Since this game is so simple, however, I consider
this somewhat a weakness in the game itself; it's not hard to guess how a human will play either.

# Extensibility
The logic in this game is very specific to a 3x3, 2 player tic tac toe game. The most significant
cause of this is the obscene network of conditionals in the AI and board modules to check the board
status for a pending or existing win. To generalize, we could implement some kind of pattern
matching algorithm to scan the board instead of checking individual cells, but that is both beyond
the scope of the assignment and, frankly, beyond the scope of the language in general (or, at
least, with our current familiarity with it).

# Hardware Port
This should port very nicely to hardware - it was designed to be asynchronous, triggered on the
submit flag. Basically, the user should be able to adjust toggle switches (or another input method)
to indicate his or her desired move and then press the submit button. If nothing happens, it was an
invalid move. The reset button will reset the board and return to the player's turn.
