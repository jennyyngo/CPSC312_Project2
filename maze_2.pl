/* 
CPSC 312 Project 2 - Maze Game
Jenny Ngo
Chris Ren

Oh no! The power cut off in your house and you are 
currently sitting in the driveway of your house. You realized
you had forgotton to grab your laptop in a room to do your homework.
Now you need to go back in the house and retreive it, then head back out. 

To start the game: start.
To end the game: halt. 

['/Users/iChri/Documents/UBC Studies/5th Semester/CPSC 312/maze.pl'].

*/


:- dynamic located_at/3, my_location/1.
:- retractall(located_at(_, _)), retractall(my_location(_)).

/* Current location of player */
my_location(driveway).

/* Rooms that are connected */
/* MAIN FLOOR */
connected(driveway, s, entrance).

connected(entrance, n, driveway) :- 
    located_at(laptop, my_hand),
    write('Yay! You got your laptop! Time to hit the road again!'), nl,
    finish, !.
connected(entrance, n, driveway) :- 
    \+ located_at(laptop, my_hand), write('Ummm... you forgot the laptop again! Do not leave yet.'), nl, fail.
connected(entrance, s, entryway). %added if had laptop, would still print after winning

connected(entryway, n, entrance) :- located_at(shoes, my_feet).
connected(entryway, n, entrance) :- \+ located_at(shoes, my_feet), write('You are barefeet! Put your shoes on!'), nl, fail. %added if not at feet, going in and out without removing shoes this stil printed
connected(entryway, s, living_room) :- located_at(shoes, entryway).
connected(entryway, s, living_room) :- located_at(shoes, my_feet), write('No shoes in the house!! Please remove them.'), nl, fail. %added if shoes at feet, would still print if removed shoes already
connected(entryway, e, bottom_stairs) :- located_at(shoes, entryway).
connected(entryway, e, bottom_stairs) :- located_at(shoes, my_feet), write('No shoes in the house!! Please remove them.'), nl, fail.
%added located shoes to print error going from entryway to bottom of stairs
connected(bottom_stairs, w, entryway).
connected(bottom_stairs, u, top_stairs) :- located_at(flashlight, my_hand).
connected(bottom_stairs, u, top_stairs) :- 
    \+ located_at(flashlight, my_hand), write('I would not do that if I were you. It is pitch dark up there.'), nl, fail. %added negation

connected(living_room, n, entryway).
connected(living_room, w, game_room) :- located_at(flashlight, my_hand).
connected(living_room, w, game_room) :-
    \+ located_at(flashlight, my_hand), write('The power is out. You cant go anywhere else inside the house without a light.'),
    nl, fail. %added if no flashlight, would still print msg if you had
connected(living_room, e, kitchen) :- located_at(flashlight, my_hand).
connected(living_room, e, kitchen) :- 
    write('The power is out. You cant go anywhere else inside the house without a light.'),
    nl, fail.
connected(living_room, s, main_washroom).

connected(game_room, e, living_room). %changed from N to E. Game room is west to living room, so it should be east to get back

connected(main_washroom, n, living_room).
connected(main_washroom, s, dining_room).

connected(kitchen, w, living_room).
connected(kitchen, e, dining_room).
connected(kitchen, s, pantry).

connected(pantry, n, kitchen).

connected(dining_room, w, kitchen).
connected(dining_room, s, main_washroom).
connected(dining_room, n, living_room).

/* UPSTAIRS */
connected(top_stairs, d, bottom_stairs).
connected(top_stairs, n, hallway).

connected(hallway, s, top_stairs).
connected(hallway, n, room3).
connected(hallway, w, room1).
connected(hallway, e, room2).

connected(room1, s, washroom1).
connected(room1, e, closet1).
connected(room1, n, hallway).

connected(washroom1, n, room1).

connected(closet1, w, room1).

connected(room2, n, hallway).
connected(room2, e, closet2).
connected(room2, s, washroom2).

connected(closet2, w, room2).

connected(room3, n, hallway).
connected(room3, e, closet3).
connected(room3, s, washroom2).

connected(closet3, w, room3).

connected(washroom2, w, room2).
connected(washroom2, e, room3).


/* where objects are located */
located_at(shoes, my_feet).
located_at(flashlight, living_room).
located_at(flashlight, bottom_stairs).
located_at(laptop, room2).


/* pick up objects */
pickup(X) :-
    located_at(X, my_hand),
    write('You are already holding a '),
    write(X), !.

pickup(laptop) :- 
    my_location(Room),
    located_at(laptop, Room),
    retract(located_at(laptop, Room)),
    assert(located_at(laptop, my_hand)),
    write('You got the laptop!! Lets head back out now.'), !.

pickup(X) :-
    my_location(entryway),
    located_at(X, entryway),
    retract(located_at(X, entryway)),
    assert(located_at(X, my_feet)),
    write('You are now wearing your shoes.'), nl,
    write('You can leave the house now.'), !.

pickup(X) :-
    my_location(Room),
    located_at(X, Room),
    retract(located_at(X, Room)),
    assert(located_at(X, my_hand)),
    write('You are now holding the '),
    write(X), !.

pickup(_) :-
    write('It is not located here.'), !.

/* How to remove your shoes */
remove(X) :-
    located_at(X, my_feet),
    my_location(entryway),
    retract(located_at(X, my_feet)),
    assert(located_at(X, entryway)), 
    write('You have successfully removed your shoes.').


/* move */
move(Direction) :-
    my_location(Curr_Location),
    connected(Curr_Location, Direction, New_Location),
    retract(my_location(Curr_Location)),
    assert(my_location(New_Location)),
    observe, !.

/*
move(_) :-
    my_location(Curr_Location),
    \+ connected(Curr_Location, Direction, New_Location),
    write('You cannot go that way').    
    */

/* What players type in order to move*/
n :- move(n).

s :- move(s).

e :- move(e).

w :- move(w).

u :- move(u).

d :- move(d).

/* Explains the current location*/
observe :-
    my_location(Room), nl,
    describe(Room), nl,
    contains_item(Room), nl, !.

/* tells the player what objects are in the room*/
contains_item(Room) :- 
    located_at(X, Room),
    write('There is a '), 
    write(X),
    write(' in here.'), nl, fail.

contains_items(_).

/* beginning instructions */
start :-
    write('Oh no! The power cut off in your house and you are currently'), nl,
    write('sitting in the driveway of your house. You realized you had'), nl,
    write('forgotton to grab your laptop to do your homework.'), nl,
    write('Now you need to go back in the house and retreive it, then head back out.'),nl,
    write('But where did you leave it?'), 
    nl,
    instructions, 
    observe.

/* end of game */
finish :-
        nl,
        write('The game is over. Please enter the halt command.'),
        nl.


instructions :-
        nl,
        write('Enter commands using standard Prolog syntax.'), nl,
        write('Available commands are:'), nl,
        write('start.                        -- to start the game.'), nl,
        write('n.  s.  e.  w.  u.  d.     -- to move in that direction.'), nl,
        write('pickup(object).          -- to pick up an object. Replace object with name of object'), nl,
        write('remove(shoes).          -- to remove your shoes.'), nl,
        write('observe.                    -- to look around you.'), nl,
        write('instructions.              -- to see this message again.'), nl,
        write('halt.                          -- to end the game and quit.'), nl,
        nl.

/* Describes the room */

describe(driveway) :- 
    write('You are currently outside in the driveway of the house.'), nl,
    write('To the south is the entrance to the house.'), nl.
    finish.

describe(entrance) :-
    write('You are at the entrance of the house.'), nl,
    write('Travel north to get to the driveway,'), nl, 
    write('or south to get into the entryway.'), nl.
    /* END OF THE GAME. TODO */

describe(entryway) :-
    located_at(shoes, entryway),
    write('You are inside of the home at the entryway'), nl,
    write('Travel south to get to the living room'), nl, 
    write('Travel east to get to the staircase').

describe(entryway) :-
    located_at(shoes, my_feet), %added this case, printed twice when shoes removed
    write('You are inside of the home at the entryway'), nl,
    write('Please take your shoes off.'), nl,
    write('Travel south to get to the living room'), nl, 
    write('Travel east to get to the staircase').

describe(living_room) :-
    write('You are currently in the living room'), nl,
    write('Thankfully the moon is shining through the window so you can kind of see.'), nl, 
    write('To the west is a game room.'), nl,
    write('To the south is the main washroom.'), nl,
    write('To the east is the kitchen.').

describe(main_washroom) :-
    write('You are currently in the washroom of the main floor'), nl,
    write('There is a candle lit in here so you can see.'),
    write('To the north is the living room.'), nl,
    write('To the south is the dining room.').

describe(kitchen) :-
    write('You are now in the kitchen.'),
    write('To the west is the living room.'), nl, 
    write('To the south is the pantry.'), nl, 
    write('To the east is the dining room.').

describe(pantry) :-
    write('You are in the pantry of the washroom'),
    write('To the north is the kitchen.').

describe(dining_room) :-
    write('You are in the dining room of the house. Dinner is not ready'), nl, 
    write('To the west is the kitchen.'), nl,
    write('To the south is the main washroom'), nl.

describe(game_room) :-
    write('You are in the game room, but there is no time to play'), nl,
    write('To the east is the living room.'), nl.

describe(bottom_stairs) :-
    write('You are at the bottom of the staircase.'),nl,
    write('To the east is the entryway.'), nl,
    write('Go up to climb the stairs.'), nl. 

describe(top_stairs) :-
    write('You are at the top of the stairs.'), nl,
    write('Go down to go down the stairs.'), nl,
    write('Go north to go to the hallway.'), nl.

describe(hallway) :-
    write('You are in the hallway upstairs. It connects to all the bedrooms'), nl,
    write('There are three rooms at east, north, and west.'),nl,
    write('Go south to go back to the stairs.'), nl.

describe(room1) :- 
    write('You are in room1. It has its own washrooom and closet'), nl,
    write('North is to the hallway.'), nl,
    write('The closet is to the east, and to the south is the washroom.'), nl.

describe(washroom1) :-
    write('You\'re in washroom 1'), nl,
    write('Go north to reenter the bedroom.'), nl.
    

describe(closet1) :-
    write('You\'re in closet 1'), nl,
    write('Go west to reenter the bedroom.'), nl.

describe(room2) :-
    write('You are in room2. It has its own washrooom and closet'), nl,
    write('Go north to exit the room.'), nl,
    write('To the east is the closet, and south is to the washroom.'), nl.

describe(washroom2) :-
    write('You are in washroom 2. It also connects to room 3'), nl,
    write('Go west to reenter bedroom2.'), nl,
    write('Go east to reenter  bedroom3.'), nl.

describe(closet2) :-
    write('You\'re in closet 2'), nl,
    write('Go west to reenter the bedroom.'), nl.

describe(room3) :-
    write('You are in room 3. It has its own closet and also connects to washroom 2.'), nl,
    write('To the east there is a closet.'), nl, 
    write('Go north to exit the room.'), nl, 
    write('There is a washroom to the south.'), nl.

describe(closet3) :-
    write('You\'re in closet 3'), nl, 
    write('Go west to reenter the bedroom.'), nl.


