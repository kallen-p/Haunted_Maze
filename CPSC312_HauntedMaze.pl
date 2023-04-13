%Main floor
room(garden, 'Garden', 'You are in the garden. What was once a well kept sanctuary has fallen into disarray...', 'that smells of dirt.').
room(grand_hallway, 'Grand Hallway', 'You are in the grand hallway. Large portraits and suits of armor line the walls, you feel as though their eyes follow you...', 'where you feel watched.').
room(kitchen, 'Kitchen', 'You are in the kitchen. The smell of rotten food fills your nostrils, it makes you sick...', 'somewhere rancid.').
room(library, 'Library', 'You are among many books in the library...', 'full of knowledge.').
room(staircase, 'Staircase', 'You stand at the bottom of a large staircase. You can either take them up or down...', 'that connects heaven and hell').
room(front_entrance, 'Front Entrance', 'You are in the front entrance. The old wooden door behind you doesn''t do much to keep out the howling wind...', 'cold.').
room(pool, 'Pool', 'You stand by the pool. So much grime has built on the surface you can''t see what lurks below...', 'that is slippery when wet.').
room(dining_hall, 'Dining Hall', 'You are in the dining hall. A large rectangular table streches the length of the room, there was once many people who gathered here...', 'where echos of laughter can still be heard.').

%Basement 
room(boiler_room, 'Boiler Room', 'You have found the boiler room. The low rumble of the boiler sounds like the growl of a beast...', 'as hot as hell itself.').
room(basement_landing, 'Basement Landing', 'You are in the basement landing. The light from the top of the stairs reveals the dusty floor littered with mouse droppings...', 'that the rodents run supreme.').
room(servants_quarters, 'Servants Quarters', 'You are in the servants quarters. There are many personal beliongings strewn about, looks like they left in a hurry...', 'that many people called home.').

%Upper Floor
room(mezzanine, 'Mezzanine', 'You stand at the railing of the mezzanine looking over the grand hall. You swear there are less suits of armor than you remember...', 'you can see down upon the household.').
room(master_bedroom, 'Master Bedroom', 'You are in the master bedroom. There are large claw marks through the center of the bed, you hope there was no one sleeping there when that happened...', 'that a terrible "accident" happened.').
room(balcony, 'Balcony', 'You are on the balcony. There is a trellis that runs down the side of the manor to the garden, maybe you could climb down...', 'that someone could profess their love to another.').
room(guest_bedroom, 'Guest Bedroom', 'You are in the guest bedroom. There are brokem chains that are hooked to the wall, was someone kept prisoner here?', 'that housed a dangerous soul.').

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

connected(north_west, pool, garden).
connected(south_east, garden, pool).

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




% Define the dynamic predicates needed for the game.
:- dynamic current_room/1.
:- dynamic treasure_room/1.
:- dynamic treasure_found/0.
:- dynamic connected/3.


% Define a predicate to print the current location
print_location :-
    current_room(Current),
    room(Current, Name, Description, _),
    write(Name), nl,
    write(Description), nl, nl.

% Define a predicate to change the current room
change_room(NewRoom) :-
    retract(current_room(_)),
    assertz(current_room(NewRoom)).

% Define a predicate to handle user input
process_input([quit]) :-
    write('Exiting game...'), throw(0), !.

process_input([help]) :-
    current_room(Current),
    findall(Direction, connected(Direction, Current, _), Directions),
    write('You can write ''go'' then a direction to move to another room. Available directions: '), write(Directions), nl, 
	write('Or you can write "search room" to look for secrets in the current room.'),
	(treasure_found -> nl, write('You can now leave! Get to the front entrance and write ''leave''.'); nl),
	nl, nl, !.

process_input([search, room]) :-
    % Check if the current room is the treasure room
    current_room(Current),
    treasure_room(TreasureRoom),
	(Current = guest_bedroom; Current = library -> 
		assert(connected(passage, guest_bedroom, library)),
		assert(connected(passage, library, guest_bedroom)),
		write('You found a secret passage, type ''go passage'' to see where it goes'), nl;
		nl),
	(Current = servants_quarters; Current = kitchen -> 
		assert(connected(passage, servants_quarters, kitchen)),
		assert(connected(passage, kitchen, servants_quarters)),
		write('You found a secret passage, type ''go passage'' to see where it goes'), nl;
		nl),
    (Current = TreasureRoom ->
        assert(treasure_found),
        write('You have found the treasure, you better get out of here before it''s too late!');
        write('You search the room but find nothing of interest.')), 
	nl, nl,!.
		
process_input([go, Direction]) :-
    current_room(Current),
    connected(Direction, Current, NewRoom),
    change_room(NewRoom),
    write('You have moved to the '), write(NewRoom), nl, nl.
	
process_input([leave]) :-
    current_room(Current),
	(Current = front_entrance, treasure_found -> 
		write('With the treasure in hand you dash out the front door, you hear angry howls as you run down the driveway to your car.'), nl,
		write('You''re lucky to have survived the night but the risk was worth the reward, you could probably live off the money that the treasure is worth for the rest of your life.'), nl,
		write('You win!'), throw(1);
		write('You can''t leave yet! You need to find the treausre first, no matter the risks.'), nl,nl, !).
	
process_input([_]) :-
    write('Huh?'), nl, nl.
	
process_input([go, _]) :-
    write('No exit that direction.'), nl,nl.

process_input([_,_]) :-
	write('Huh?'), nl, nl.

% Define a predicate to read user input and process it
get_input :-
    write('Type a command (or "help"): '),
    readln(Input),
    process_input(Input),
    print_location,
    get_input.

% Define a predicate to start the game
play :-
	(treasure_found -> retract(treasure_found); nl),
	retractall(current_room(_)),
	retractall(treasure_room(_)),
	retractall(connected(passage, _, _)), 
	findall(Room, room(Room, _, _, _), Rooms),
    random_member(TreasureRoom, Rooms),
    assertz(treasure_room(TreasureRoom)),
	room(TreasureRoom, _, _, Hint),
	write('There are rumors that there is treasure hidden somewhere in this old manor but no one has been brave enough to search for it.'),nl,
	write('You figure that since the building has been abandoned for decades there would be no harm checking to see if the rumors are true.'), nl,
	write('You asked around about the treasure and you heard that it was somewhere '), write(Hint),nl, nl,
	assertz(current_room(front_entrance)),
    print_location,
    get_input.