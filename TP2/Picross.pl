print_nonogram(N) :-
    nl,write(’Found nonogram:’),nl,
    print_nonogram1(N).

print_nonogram1([]).

print_nonogram1([Line | Lines]) :-
    print_line(Line),nl,
    print_nonogram1(Lines).

print_line([]).
print_line([Head | Tail]) :-
    Head = 1,
    write(’# ’),
    print_line(Tail).

print_line([Head | Tail]) :-
    Head = 0,
    write(’. ’),
    print_line(Tail).


