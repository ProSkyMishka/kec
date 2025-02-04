:- use_module(library(odbc)).

init :-
    odbc_connect('PostgreSQL_facts_db', _,
        [
            user(prolog_user),
            password(prolog_pass),
            alias(facts),
            open(once)
        ]
    ).

fact_exists(Lemmas) :-
    findall((Key, Value),
            odbc_query(facts,
            'SELECT * FROM environment',
            row(Key, Value)),
        Lemmas),
    writeln(Lemmas).

run :-
    init,
    fact_exists(_).

:- initialization(run).
