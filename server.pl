:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(odbc)).
:- consult('init_db.pl').
:- consult('agent.pl').
:- consult('facts.pl').

:- http_handler(root(light_status), handle_light_status, []).
:- http_handler(root(update_fact), handle_update_fact, []).

server(Port) :-
    http_server(http_dispatch, [port(Port)]).

stop :-
    http_stop_server(8000, []).

handle_light_status(_) :-
    (should_turn_on_light -> 
        Reply = json([light_status=on])
    ; 
        Reply = json([light_status=off])
    ),
    reply_json(Reply).

handle_update_fact(Request) :-
    http_read_json_dict(Request, Dict),
    ( get_dict(key, Dict, Key) ->
        ( Key = "time_status" ->
            get_response_toggle(toggle_time)
        ; Key = "home_status" ->
            get_response_toggle(toggle_home)
        ; Key = "light_status" ->
            get_response_toggle(toggle_light)
        ;
            reply_json(json([status=error, message="Invalid key"]))
        )
    ;
        reply_json(json([status=error, message="Missing key"]))
    ).

get_response_toggle(Function) :-
    (call(Function) ->
        reply_json(json([status=success]))
    ;
        reply_json(json([status=error, message="Invalid request"]))
    ).

:- initialization(server(8000)).
