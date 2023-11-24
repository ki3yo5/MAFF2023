$title  Nutrition-Cropping Optimization Model

$onText
Build 1.0

Simple model with 7 crops and calorie and PCF balance only.
Contstraints on land size (1ha) only.
Nutrient balance per day per family (4 adults) is optimized.

Ishikawa K., Pre-simulation for DSS-ESSA Model. The MAFF Open Lab, 2023.
$offText



$sTitle Input Data
Set
   c 'crops'  / wheat, corn, beans, onions, potatoes, rice, tomato        /
   t 'period' / jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec /
   n 'nutrients' / calorie '1000 cal',  protein 'grams',  fat 'grams',  carbonhydrate 'grams'/ ;

Table landreq(t,c) 'months of land occupation by crop (hectares)'
         wheat   corn   beans  onions  potatoes  rice   tomato
   jan     1.     1.     1.      1.
   feb     1.     1.     1.      1.
   mar     1.      .5    1.      1.       .5
   apr     1.            1.      1.      1.       .25
   may     1.                     .25    1.      1.
   jun                                   1.      1.
   jul                                   1.      1.       .75
   aug                                   1.      1.      1.
   sep                                   1.      1.      1.
   oct                                   1.      1.      1.
   nov      .5     .25    .25     .5      .75     .5      .75
   dec     1.     1.     1.      1.                         ;

Table a(c,n) 'nutritive value of foods (per 100g)'
                calorie   protein     fat    carbonhydrate
*                (1000)       (g)     (g)        (g)
   wheat           329       10.8     3.1        72.1
   corn             89        5.4     2.6        25.2
   beans           372       33.8    19.7        29.5 
   onions           33        1        .1         8.4
   potatoes         59        1.8      .1        17.3
   rice            156        2.5      .3        37.1
   tomato           20         .7      .1         4.7 ;

Parameters
   yield(c)   'crop yield (tons per hectare)'
              / wheat      5,    corn  9,     beans  1.7,  onions  48
                potatoes  33,    rice  5.4,   tomato 64              /
   intake(n)  'required daily intake of nutrients'
              / calorie   2400,   protein   70,  fat   50,  carbonhydrate  300 /;

Scalar
   land       'land size   (hectares)'      /   1.  /
   pop        'population size (head)'      /   4.  /
   weight     'weight on calorie balance'   /  .75  /;
   


$sTitle Endogenous Variables and Equations
Variable
   xcrop(c)      'cropping activity      (hectares)'
   calorie       'calorie deficit        (1000 cal)'
   diet          'change in diet         (grams)'
   target        'nutrient balance               ' ;

Positive Variable xcrop;

Equation
   landbal(t)    'land balance           (hectares)'
   caloriebal    'calorie balance        (1000 cal)'
   dietbal       'diet balance           (grams)'
   objective     'objective function            ' ;

landbal(t)..   sum(c, xcrop(c)*landreq(t,c))  =l= land ;

caloriebal..   calorie =e= sum(c, intake("calorie") - xcrop(c)*yield(c)*a(c,"calorie")*10000/(365*pop)) ;

dietbal..      diet    =e= sum((n,c), intake(n)-xcrop(c)*yield(c)*a(c,n)*10000/(365*pop)) - calorie ;

objective..    target  =e= weight*calorie + (1-weight)*diet ;

Model presim 'Nutrition-Cropping Optimization Model' / all /;

solve presim minimizing target using lp ;



$sTitle Report on Solution
Set
   crep  / landuse, output /
   nrep  / required, intake, deficit /;

Parameter
   croprep      'crop report summary'
   dietrep      'nutrient summary';

croprep("landuse",c)  = xcrop.l(c);
croprep("output",c)   = xcrop.l(c)*yield(c);
croprep(crep,"total") = sum(c, croprep(crep,c));

dietrep("required",n) = intake(n);
dietrep("intake",n)   = sum(c, xcrop.l(c)*yield(c)*a(c,n)*10000/(365*pop));
dietrep("deficit",n)  = intake(n)-dietrep("intake",n);

display "landuse -- hectares "
        "output  -- tons     "
        "diet    -- 1000cal/grams per day"
        , croprep, dietrep;
