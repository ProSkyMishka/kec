:- use_module(library(odbc)).

get_fact(Key, Value) :-
    concat("SELECT value FROM environment WHERE key = ",Key,Rest),
    odbc_query(facts, Rest, row(Value)).

home_status(Value) :-
    get_fact("'home_status'", Value).

time_status(Value) :-
    get_fact("'time_status'", Value).

light_status(Value) :-
    get_fact("'light_status'", Value).

update_fact(Key, Value) :-
    concat("UPDATE environment SET value = ",Value,Rest1),
    concat(" WHERE key = ",Key,Rest2),
    concat(Rest1,Rest2,Rest),
    odbc_query(facts, Rest).

toggle_time :-
    Key = "'time_status'",
    time_status(Value),
    (Value = 'day' ->
        update_fact(Key, "'night'")
    ;
        update_fact(Key, "'day'")
    ).

toggle_home :-
    Key = "'home_status'",
    home_status(Value),
    (Value = 'home' ->
        update_fact(Key, "'out'")
    ;
        update_fact(Key, "'home'")
    ).

toggle_light :-
    Key = "'light_status'",
    light_status(Value),
    (Value = 'dark' ->
        update_fact(Key, "'light'")
    ;
        update_fact(Key, "'dark'")
    ).