%Main floor
room(garden, 'Garden', 'You are in the garden. What was once a well kept sanctuary has fallen into disarray...').
room(grand_hallway, 'Grand Hallway', 'You are in the grand hallway. Large portraits and suits of armor line the walls, you feel as though their eyes follow you...').
room(kitchen, 'Kitchen', 'You are in the kitchen. The smell of rotten food fills your nostrils, it makes you sick...').
room(library, 'Library', 'You are among many books in the library...').
room(staircase, 'Staircase', 'You stand at the bottom of a large staircase. You can either take them up or down...').
room(front_entrance, 'Front Entrance', 'You are in the front entrance. The old wooden door behind you doesn\'t do much to keep out the howling wind...').
room(pool, 'Pool', 'You stand by the pool. So much grime has built on the surface you can\'t see what lurks below...').
room(dining_hall, 'Dining Hall', 'You are in the dining hall. A large rectangular table streches the length of the room, there was once many people who gathered here...').

%Basement 
room(boiler_room, 'Boiler Room', 'You have found the boiler room. The low rumble of the boiler sounds like the growl of a beast...').
room(basement_landing, 'Basement Landing', 'You are in the basement landing. The light from the top of the stairs reveals the dusty floor littered with mouse droppings...').
room(servants_quarters, 'Servants ', 'You are in the servants quarters. There are many personal beliongings strewn about, looks like they left in a hurry...').

%Upper Floor
room(mezzanine, 'Mezzanine', 'You stand at the railing of the mezzanine looking over the grand hall. You swear there are less suits of armor than you remember...').
room(master_bedroom, 'master_bedroom', 'You are in the master bedroom. There are large claw marks through the center of the bed, you hope there was no one sleeping there when that happend...').
room(balcony, 'Balcony', 'You are on the balcony. There is a trellis that runs down the side of the manor to the garden, maybe you could climb down...').
room(guest_bedroom, 'Guest Bedroom', 'You are in the guest bedroom. There are brokem chains that are hooked to the wall, was someone kept prisoner here?').

%Room Connections
connected(north, front_entrance, grand_hallway).
connected(south, grand_hallway, front_entrance).

connected(north, grand_hallway, staircase).
connected(south, staircase, grand_hallway).

connected(east, grand_hallway, library).
connected(west, library, grand_hallway).

connected(west, grand_hallway, kitchen).
connected(east, kitchen, grand_hallway).

connected(south_west, grand_hallway, dining_hall).
connected(north_east, dining_hall, grand_hallway).

connected(north, kitchen, dining_hall).
connected(south, dining_hall, kitchen).

connected(north_west, grand_hallway, pool).
connected(south_east, pool, grand_hallway).

connected(west, pool, garden).
connected(east, garden, pool).

connected(west, front_entrance, garden).
connected(east, garden, front_entrance).

connected(up, staircase, mezzanine).
connected(down, mezzanine, staircase).

connected(down, staircase, basement_landing).
connected(up, basement_landing, staircase).

connected(north, basement_landing, boiler_room).
connected(south, boiler_room, basement_landing).

connected(south, basement_landing, servants_quarters).
connected(north, servants_quarters, basement_landing).

connected(east, mezzanine, guest_bedroom).
connected(west, guest_bedroom, mezzanine).

connected(west, mezzanine, master_bedroom).
connected(east, master_bedroom, mezzanine).

connected(west, master_bedroom, balcony).
connected(east, balcony, master_bedroom).

connected(down, balcony, garden).
connected(up, garden, balcony).

%Predicate to display room player is currently in
:- dynamic current_room/1.

print_location :-
    current_room(Current),
    room(Current, Name, Description),
    print(Name), nl, print(Description), nl.

%Predicate to change the current room
change_room(NewRoom) :-
    current_room(Current),
    retract(current_room(Current)),
    assertz(current_room(NewRoom)).

%Predicates to take user input using readln library
:- use_module(library(readln)).

%Predicate to make the console prompt the player
:- prompt(_, 'Type a command (or ''help''): ').

%Predicate to strip punctuation from user input
strip_punctuation([], []).

strip_punctuation([Word|Tail], [Word|Result]) :-
    \+(member(Word, ['.', ',', '?', '!'])),
    strip_punctuation(Tail, Result).

strip_punctuation([_|Tail], Result) :-
    strip_punctuation(Tail, Result).

%Predicate to read the users input with readln
read_sentence(Input) :-
    readln(Input1, _, ".!?", "_0123456789", lowercase),
    strip_punctuation(Input1, Input).

%Predicate to take input from the console and process it
get_input :- read_sentence(Input), get_input(Input).
get_input([quit]).
get_input(Input) :-
    process_input(Input), print_location,
    read_sentence(Input1), get_input(Input1).
	
%Predicate to parse user input
process_input([help]) :- print('Type one of the 8 directions on a compass to try to move to a connected room'), nl.

process_input([go, Direction]) :-
    current_room(Current),
    connected(Direction, Current, NewRoom),
    change_room(NewRoom).

process_input([go, _]) :-
    print('No exit that direction.'), nl.

process_input([_]) :-
    print('Huh?'), nl, nl.
	
%Main Predicate to play the game
play :-
    retractall(current_room(_)),
    assertz(current_room(library)),
    print_location,
    get_input.