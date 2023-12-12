$title  Nutrition-Cropping Optimization Model

$onText
Build 1.1 Dec 12 2023

Cropping model with 16 crops but without livestock and processing foods.
Objective function is calorie deficit and nutrient intake balance only.
Contstraints on pooled land size and 250% margin for each cropiing area.
Calorie and nutrient balance is optimized for the total population per day.

Ishikawa K., Pre-simulation for DSS-ESSA Model. The MAFF Open Lab, 2023.
$offText

$if not setglobal build $setglobal build 1.1
$setglobal gdx_results .\results\%build%_results.gdx
$setglobal excel_results .\results\%build%_results.xlsx

$sTitle Input Data
Set
   c 'crops'  /
   rice
   wheat
   barley
   naked
   corn
   sorghum
   mis_grains
   sweetp
   potato
   soy
   mis_beans
   green_veges
   mis_veges
   mandarin
   apple
   mis_fruits /
   t 'period' /
   jan
   feb
   mar
   apr
   may
   jun
   jul
   aug
   sep
   oct
   nov
   dec /
   n 'nutrients' /
   calorie       'kcal'
   protein       'grams'
   fat           'grams'
   carbonhydrate 'grams'
   pop           'population (million)'
   supplypy      'supply per year (kg)'
   supplypd      'supply per day (grams)'/
   a 'age' /
   0-1
   1-2
   3-5
   6-7
   8-9
   10-11
   12-14
   15-17
   18-29
   30-49
   50-64
   65-74
   75- /
   p 'production' /
   area         '1000ha'
   yield        't per ha'
   prod         '1000t'
   import       '1000t'
   export       '1000t'
   stock        '1000t'
   total        '1000t'
   feed         '1000t'
   seed         '1000t'
   processing   '1000t'
   passenger    '1000t'
   wear         '1000t'
   gross        '1000t'
   g2n          'percent'
   net          '1000t' /
   g 'gender' /
   male
   female/
   v 'value' /
   pc           'percapita per day'
   value        'nutrients in net food 100g'/;

parameter
  data(c,p)      Production data
  landreq(c,t)   Months of land occupation by crop (hectares)
  intake(a,g,n)  Required daily intake of nutrients
  nvalue(c,v,n)  Nutritive supply and value of foods;
  
$gdxin prod.gdx
$load data
$gdxin

$gdxin landreq.gdx
$load landreq
$gdxin

$gdxin intake.gdx
$load intake
$gdxin

$gdxin nvalue.gdx
$load nvalue
$gdxin

Scalar
   land       'total land size (1000ha)'        /  4325  /
   paddy      'paddy field (1000ha)'            /  2352  /
   upland     'total upland field (1000ha)'     /  1973  /
   cropl      'cropping field (1000ha)'         /  1123  /
   orchard    'orchard (1000ha)'                /   259  /
   pasture    'pasture (1000ha)'                /   591  /
   aweight    'weight on cropping are balance'  /   2.5  /
   nweight    'weight on calorie balance'       /   .75  /
   fweight    'weight on change in diet'        /   .25  /
   item       'number of food items'            /    16  /;
   


$sTitle Agents for calculation
Set
   nn   /calorie, protein, fat, carbonhydrate/;

Parameter
   pintake(a,g,nn)       'Required daily intake of nutrients (kcal grams/million)'
   t2g(c)                'Ratio of total food to gross food (percent)'
   g2n(c)                'Ration of gross food to net food (percent)'
   nnvalue(c,nn)         'Nutritive value of foods (kcal grams/netfood 100g)'
   nnpc(c)               'Current daily intake of nutrients (grams/capita)'
   tpop                  'National population (million)';

pintake(a,g,"calorie") = intake(a,g,"pop") * intake(a,g,"calorie");
pintake(a,g,"protein") = intake(a,g,"pop") * intake(a,g,"protein");
pintake(a,g,"fat") = intake(a,g,"pop") * intake(a,g,"fat");
pintake(a,g,"carbonhydrate") = intake(a,g,"pop") * intake(a,g,"carbonhydrate");

t2g(c) = 100 * data(c,"gross") / data(c,"total");
g2n(c) = data(c,"g2n");

nnvalue(c,"calorie") = nvalue(c,"value","calorie");
nnvalue(c,"protein") = nvalue(c,"value","protein");
nnvalue(c,"fat") = nvalue(c,"value","fat");
nnvalue(c,"carbonhydrate") = nvalue(c,"value","carbonhydrate");

nnpc(c) = nvalue(c,"pc","supplypd");

tpop = sum((a,g), intake(a,g,"pop"));

Display pintake, t2g, nnvalue, nnpc, tpop;



$sTitle Endogenous Variables and Equations
Variable
   xcrop(c)      'Cropping area          (1000ha)'
   ndeficit(nn)  'Deficit of nutrients   (kcal grams/capita)'
   cdeficit      'Deficit of calorie     (kcal      /capita)'
   delta(c)      'Change in diet         (     grams/capita)'
   target        'Target value to minimize' ;

Positive Variable xcrop;

Equation
   lbal(t)       'Land balance           (1000ha)'
   abal(c)       'Cropping area balance  (1000ha)'
   nbal(nn)      'Nutrients balance      (kcal grams/capita)'
   cbal          'Calorie balance        (kcal      /capita)'
   dbal(c)       'Change in diet         (     grams/capita)'
   objective     'Objective function' ;

lbal(t)..   sum(c,xcrop(c)*landreq(c,t)) =l= land;

abal(c)..   xcrop(c) =l= aweight*data(c,"area");
                                      
nbal(nn)..  ndeficit(nn) =e=  sum((a,g),pintake(a,g,nn))/tpop
            - sum(c,xcrop(c)*data(c,"yield")*(t2g(c)/100)*(g2n(c)/100)*nnvalue(c,nn)*(10**7)/(tpop*(10**6)*365));
                                      
cbal..      cdeficit =e= ndeficit("calorie");

dbal(c)..   delta(c) =e= nnpc(c)-xcrop(c)*data(c,"yield")*(t2g(c)/100)*(g2n(c)/100)*(10**9)/(tpop*(10**6)*365);

objective..   target =e= nweight*cdeficit + sum(c,(fweight/item)*delta(c));

Model presim 'Nutrition-Cropping Optimization Model' / all /;

solve presim minimizing target using nlp ;



$sTitle Report on Solution
Set
   lrep  /
   landcul     'Land use by month          (1000ha)'/
   crep  /
   landuse     'Area cropped               (1000ha)'
   supply      'Total food supply          (1000t)'
   grossfood   'Gross food supply          (1000t)'
   netfood     'Net food supply            (1000t)'
   change      'Change in diet             (grams/capita)'/
   nrep  /
   required    'Required daily nutrients   (kcal grams/capita)'
   intake      'Intaken nutrients per day  (kcal grams/capita)'
   shortage    'Shortage per day           (kcal grams/capita)'
   ssrate      'Self sufficient rate       (percentage)       '/;

Parameter
   landrep      'Land report summary'
   croprep      'Crop report summary'
   dietrep      'Nutrient summary';

landrep(t,c) = xcrop.l(c)*landreq(c,t);
landrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t));

croprep(c,"landuse")   = xcrop.l(c);
croprep(c,"supply")    = xcrop.l(c)*data(c,"yield");
croprep(c,"grossfood") = xcrop.l(c)*data(c,"yield")*(t2g(c)/100);
croprep(c,"netfood")   = xcrop.l(c)*data(c,"yield")*(t2g(c)/100)*(g2n(c)/100);
croprep(c,"change")    = croprep(c,"netfood")*(10**9)/(tpop*(10**6)*365)-nnpc(c);
croprep("total",crep)  = sum(c, croprep(c,crep));

dietrep(nn,"required") = sum((a,g),pintake(a,g,nn))/tpop;
dietrep(nn,"intake")   = sum(c,croprep(c,"netfood")*nnvalue(c,nn)*(10**7)/(tpop*(10**6)*365));
dietrep(nn,"shortage") = dietrep(nn,"intake") - dietrep(nn,"required");
dietrep(nn,"ssrate")   = 100*dietrep(nn,"intake") / dietrep(nn,"required");

display "landuse   -- Cropped area (1000ha)"
        "supply    -- Total food supply (1000t)"
        "grossfood -- Gross food supply (1000t)"
        "netfood   -- Net food supply (1000t)"
        "change    -- Change in daily diet (grams/capita)"
        "required  -- Required daily nutrients (kcal grams/capita)"
        "intake    -- Intaken nutrients per day (kcal grams/capita)"
        "shortage  -- Shortage per day (kcal grams/capita)"
        "ssrate    -- Self sufficient rate (percentage)"
        landrep, croprep, dietrep;



$sTitle Export Report
Execute_Unload '%gdx_results%', landrep, croprep, dietrep;

execute 'gdxxrw %gdx_results% o=%excel_results% par=landrep rng=landrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=croprep rng=croprep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=dietrep rng=dietrep!A1 rdim=1 cdim=1'

