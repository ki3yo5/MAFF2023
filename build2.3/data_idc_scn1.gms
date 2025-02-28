$title  Optional import decline data

parameter
    rdc_rate(*)       'Import decline rate for goods'
    rec_rate_fe(*)    'Import decline rate for feeds';

rdc_rate("rice")       = 0.2;
rdc_rate("wheat")      = 0.2;
rdc_rate("barley")     = 0.2;
rdc_rate("naked")      = 0.2;
rdc_rate("corn")       = 0.2;
rdc_rate("sorghum")    = 0.2;
rdc_rate("mis_grains") = 0.2;
rdc_rate("sweetp")     = 0;
rdc_rate("potato")     = 0;
rdc_rate("soy")        = 0.2;
rdc_rate("mis_beans")  = 0;
rdc_rate("green_veges")= 0;
rdc_rate("mis_veges")  = 0;
rdc_rate("mandarin")   = 0;
rdc_rate("apple")      = 0;
rdc_rate("mis_fruits") = 0;
rdc_rate("scane")      = 0;
rdc_rate("sbeat")      = 0;
rdc_rate("rapeseed")   = 0.2;
rdc_rate("starch")     = 0;
rdc_rate("fish")       = 0;
rdc_rate("seaweed")    = 0;
rdc_rate("sugar")      = 0;
rdc_rate("oil")        = 0;
rdc_rate("miso")       = 0;
rdc_rate("soysource")  = 0;
rdc_rate("mis_foods")  = 0;
rdc_rate("beef")       = 0;
rdc_rate("pork")       = 0;
rdc_rate("chicken")    = 0;
rdc_rate("egg")        = 0;
rdc_rate("milk")       = 0;

rec_rate_fe("fodder")      = 1;
rec_rate_fe("soybeancake") = 0.2;
rec_rate_fe("fishmeal")    = 1;
rec_rate_fe("corn")        = 0.2;
rec_rate_fe("sorghum")     = 0.2;
rec_rate_fe("wheat")       = 1;
rec_rate_fe("barley")      = 1;
rec_rate_fe("rice")        = 1; 