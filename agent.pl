should_turn_on_light :-
    home_status(Home),
    time_status(Time),
    light_status(Light),
    Home = 'home',
    Time = 'day',
    Light = 'dark'.
