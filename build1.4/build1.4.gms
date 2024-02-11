$title  Nutrition-Cropping Optimization Model

$onText
Build 1.4 Dec 26 2023

Cropping model with 16 crops, 2 marine products, 6 processing foods.
Objective function is calorie deficit and nutrient intake balance in difference or rate.
Contstraints on land size by each type and 300% margin for each cropiing area.
Cropping on pasture, orchard, local plants are exception.
Calorie and nutrient balance is optimized for the total population per day.

Ishikawa K., Pre-simulation for DSS-ESSA Model. The MAFF Open Lab, 2023.
$offText

$if not setglobal build $setglobal build 1.4
$if not setglobal rate $setglobal rate 1

$setglobal gdx_results .\results\%build%_results.gdx
$setglobal excel_results .\results\%build%_results.xlsx


$sTitle Input Data
Set
   c 'crops'  /
   rice
   wheat
   pwheat       'wheat cropped in paddy'
   barley
   pbarley      'feed use'
   naked
   corn         'feed use'
   sorghum      'feed use'
   mis_grains   'miscellaneous grains'
   sweetp       'sweet potato'
   potato
   soy
   psoy         'soy cropped in paddy'
   mis_beans    'miscellaneous beans'
   green_veges  'green vegetables'
   mis_veges    'miscellaneous vegetables'
   mandarin     'manadarin orange'
   apple
   mis_fruits   'miscellaneous fruits'
   scane        'sugar cane'
   sbeat        'sugar beat'
   rapeseed
   fish
   seaweed
   starch       'made of corn potato sweetp'
   sugar        'refined sugar'
   oil          'rapeseed oil'
   miso
   soysource
   mis_foods    'miscellaneous foods' / 
   paddy(c)   /
   rice
   pwheat
   psoy       /
   field(c)   /
   wheat
   barley
   naked
   mis_grains
   sweetp
   potato
   soy
   mis_beans
   green_veges
   mis_veges
   scane
   sbeat
   rapeseed/
   pasture(c) /
   pbarley
   corn
   sorghum/
   orchard(c) /
   mandarin
   apple
   mis_fruits /
   local(c)   /
   scane
   sbeat
   rapeseed   /
   edible(c)  /
   rice
   wheat
   pwheat 
   barley
   naked
   mis_grains
   sweetp
   potato
   soy
   psoy
   mis_beans
   green_veges
   mis_veges
   mandarin
   apple
   mis_fruits /  
   marine(c)  /
   fish
   seaweed    /
   processed(c) /
   starch
   sugar
   oil
   miso
   soysource
   mis_foods  /   
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

* i for ingredient crops in food processing 
alias (c,i);

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
   land       'total land size (1000ha)'         /  4325  /
   lpaddy     'paddy field (1000ha)'             /  2352  /
   lupland    'total upland field (1000ha)'      /  1973  /
   lfield     'cropping field (1000ha)'          /  1123  /
   lorchard   'orchard (1000ha)'                 /   259  /
   lpasture   'pasture (1000ha)'                 /   591  /
   aweight    'constraint on cropping area'      /   3    /
   cweight    'weight on calorie balance'        /   .75  /;
   
Table
   coefficient(c,i)   'Output processed food by 1 unit input crop'
               corn   sweetp   potato   soy   scane   sbeat   rapeseed
   starch      0.52    0.77     0.77     
   sugar                                       0.17    0.17             
   oil                                                          0.37
   miso                                 5.0
   soysource                            3.3                                                          
;



$sTitle Agents for calculation
Set
   nn         'nutrition'         /calorie, protein, fat, carbonhydrate/;

Parameter
   tpop                  'National population                (million)'
   pintake(a,g,nn)       'Daily intake requirement           (kcal grams/million)'
   nreq(nn)              'Daily intake requirement           (kcal grams/capita)'
   nnvalue(c,nn)         'Nutritive value of foods           (kcal grams/netfood 100g)'
   nnpc(c)               'Current daily intake of nutrients  (grams/capita)'
   t2g(c)                'Total food to gross food           (ratio)'
   t2p(c)                'Total food to processing use       (ratio)'
   t2f(c)                'Total food to feed use             (ratio)'
   g2n(c)                'Gross food to net food             (ratio)'
   x2n(c)                'Cropping area(1000ha) to net food(grams)               (ratio)'
   x2f(c,i)              'Cropping area(1000ha) to processed food(grams)         (ratio)'
   x2nn(c,nn)            'Cropping area(1000ha) to nutritive value(kcal grams)   (ratio)'
   x2fn(c,i,nn)          'Cropping area(1000ha) to nutritive value(kcal grams)   (ratio)'
;

tpop = sum((a,g), intake(a,g,"pop"));

pintake(a,g,"calorie") = intake(a,g,"pop") * intake(a,g,"calorie");
pintake(a,g,"protein") = intake(a,g,"pop") * intake(a,g,"protein");
pintake(a,g,"fat") = intake(a,g,"pop") * intake(a,g,"fat");
pintake(a,g,"carbonhydrate") = intake(a,g,"pop") * intake(a,g,"carbonhydrate");

nreq(nn) = sum((a,g),pintake(a,g,nn))/tpop;

nnvalue(c,"calorie") = nvalue(c,"value","calorie");
nnvalue(c,"protein") = nvalue(c,"value","protein");
nnvalue(c,"fat") = nvalue(c,"value","fat");
nnvalue(c,"carbonhydrate") = nvalue(c,"value","carbonhydrate");

nnpc(c) = nvalue(c,"pc","supplypd");

t2g(c) = data(c,"gross")/data(c,"total");
t2p(c) = data(c,"processing")/data(c,"total");
t2p("soy") = 18/data("soy","prod");
t2p("psoy")= 18/data("psoy","prod");
t2f(c) = data(c,"feed")/data(c,"total");
g2n(c) = data(c,"g2n")/100;
x2n(c)       = data(c,"yield")*t2g(c)*g2n(c)*(10**9);
x2nn(c,nn)   = data(c,"yield")*t2g(c)*g2n(c)*(10**7)*nnvalue(c,nn);
x2f(c,i)     = data(i,"yield")*t2p(i)*coefficient(c,i)*(10**9);
x2fn(c,i,nn) = data(i,"yield")*t2p(i)*coefficient(c,i)*(10**7)*nnvalue(c,nn);

Display tpop, pintake, nreq, nnvalue, nnpc, x2f, x2n;



$sTitle Endogenous Variables and Equations
Variable
   xcrop(c)      'Cropping area                     (1000ha)'
   ndeficit(nn)  'Deficit of nutrients   (kcal grams/capita)'
   cdeficit      'Deficit of calorie     (kcal      /capita)'
   delta(c)      'Change in diet         (     grams/capita)'
   target        'Target value to minimize' ;

Positive Variable xcrop;

Equation
   ybal(t)       'Land balance on paddy             (1000ha)'
   fbal(t)       'Land balance on upland            (1000ha)'
   pbal(t)       'Land balance on pasture           (1000ha)'
   obal(t)       'Land balance on orchard           (1000ha)'
   aybal(c)      'Cropping area balance on paddy    (1000ha)'
   afbal(c)      'Cropping area balance on upland   (1000ha)'
   apbal(c)      'Cropping area balance on pasture  (1000ha)'
   aobal(c)      'Cropping area balance on orchard  (1000ha)'
   albal(c)      'Cropping area balance on local    (1000ha)'
   nbal(nn)       'Nutrients balance      (kcal grams/capita)'
   calorie       'Calorie balance        (kcal      /capita)'
   diet(c)       'Change in diet         (     grams/capita)'
   obj           'Objective function'
   alt           'Alternative objective function';

ybal(t)..    sum(c, xcrop(c)*landreq(c,t) $ paddy(c)) =l= lpaddy;

fbal(t)..    sum(c, xcrop(c)*landreq(c,t) $ field(c)) =l= lfield;

pbal(t)..    sum(c, xcrop(c)*landreq(c,t) $ pasture(c)) =l= lpasture;

obal(t)..    sum(c, xcrop(c)*landreq(c,t) $ orchard(c)) =l= lorchard;

aybal(c)..   xcrop(c) $ paddy(c) =l= aweight*data(c,"area") $ paddy(c);

afbal(c)..   xcrop(c) $ field(c) =l= aweight*data(c,"area") $ field(c);

apbal(c)..   xcrop(c) $ pasture(c) =l= (10**6)*data(c,"area") $ pasture(c);

aobal(c)..   xcrop(c) $ orchard(c) =l= data(c,"area") $ orchard(c);

albal(c)..   xcrop(c) $ local(c) =l= (aweight/2)*data(c,"area") $ local(c);
                                      
nbal(nn)..   ndeficit(nn) =e= nreq(nn) - sum(c,xcrop(c)*x2nn(c,nn))/(tpop*(10**6)*365)
                                       - sum((i,c),xcrop(i)*x2fn(c,i,nn))/(tpop*(10**6)*365)
                                       - sum(c,data(c,"net")*nnvalue(c,nn)*(10**7)$marine(c))/(tpop*(10**6)*365);
                                      
calorie..    cdeficit =e= ndeficit("calorie");

diet(c)..    delta(c) =e= nnpc(c) - xcrop(c)*x2n(c)/(tpop*(10**6)*365)
                                  - sum(i,xcrop(i)*x2f(c,i))/(tpop*(10**6)*365)
                                  - data(c,"net")*(10**9)$marine(c)/(tpop*(10**6)*365);

* denominator for (1-cweight): count items that take non-zero values or 7 food groups

obj..    target =e= cweight*cdeficit + sum(c,((1-cweight)/7)*delta(c));

alt..    target =e= cweight*cdeficit/nreq("calorie") + sum(c,((1-cweight)/7)*delta(c)/(nnpc(c)+0.001));

Model presim_dif 'difference' / ybal,fbal,pbal,obal,aybal,afbal,apbal,aobal,albal,nbal,calorie,diet,obj /;
Model presim_rat 'rate'       / ybal,fbal,pbal,obal,aybal,afbal,apbal,aobal,albal,nbal,calorie,diet,alt /;

if(%rate%,
solve presim_rat minimizing target using nlp ;
else
solve presim_dif minimizing target using nlp ;)



$sTitle Report on Solution
Set
   crep  /
   landuse     'Area cropped               (1000ha)'
   supply      'Total food supply          (1000t)'
   grossfood   'Gross food supply          (1000t)'
   netfood     'Net food supply            (1000t)'
   current     'Current intake             (grams/capita)'
   potential   'Potential intake           (grams/capita)'
   change      'Change in diet             (grams/capita)'/
   nrep  /
   required    'Required daily nutrients   (kcal grams/capita)'
   intake      'Intaken nutrients per day  (kcal grams/capita)'
   shortage    'Shortage per day           (kcal grams/capita)'
   ssrate      'Self sufficient rate       (percentage)       '/;

Parameter
   paddyrep     'Land report summary on paddy'
   fieldrep     'Land report summary on field'
   pasturerep   'Land report summary on pasture'
   orchardrep   'Land report summary on orchard'   
   croprep      'Crop report summary'
   foodrep      'Processed food summary'
   dietrep      'Nutrient summary';

paddyrep(t,c) = xcrop.l(c)*landreq(c,t) $ paddy(c);
paddyrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ paddy(c));
fieldrep(t,c) = xcrop.l(c)*landreq(c,t) $ field(c);
fieldrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ field(c));
pasturerep(t,c) = xcrop.l(c)*landreq(c,t) $ pasture(c);
pasturerep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ pasture(c));
orchardrep(t,c) = xcrop.l(c)*landreq(c,t) $ orchard(c);
orchardrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ orchard(c));

croprep(c,"landuse")   = xcrop.l(c) $edible(c);
croprep(c,"supply")    = xcrop.l(c)*data(c,"yield") $edible(c);
croprep(c,"grossfood") = xcrop.l(c)*data(c,"yield")*t2g(c) $edible(c);
croprep(c,"netfood")   = xcrop.l(c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
croprep(c,"current")   = nnpc(c)$edible(c);
croprep(c,"potential") = croprep(c,"netfood")*(10**9)/(tpop*(10**6)*365);
croprep(c,"change")    = croprep(c,"potential")-croprep(c,"current");
croprep("total",crep)  = sum(c, croprep(c,crep));

foodrep(c,"netfood")   = sum(i,xcrop.l(i)*data(i,"yield")*t2p(i)*coefficient(c,i));
foodrep(c,"current")   = nnpc(c)$processed(c);
foodrep(c,"potential") = foodrep(c,"netfood")*(10**9)/(tpop*(10**6)*365);
foodrep(c,"change")    = foodrep(c,"potential")-foodrep(c,"current");
foodrep("total",crep)  = sum(c, foodrep(c,crep));

dietrep(nn,"required") = nreq(nn);
dietrep(nn,"intake")   = sum(c,croprep(c,"netfood")*nnvalue(c,nn)*(10**7))   /(tpop*(10**6)*365)
                       + sum(c,foodrep(c,"netfood")*nnvalue(c,nn)*(10**7))   /(tpop*(10**6)*365)
                       + sum(c,data(c,"net")*nnvalue(c,nn)*(10**7)$marine(c))/(tpop*(10**6)*365);
dietrep(nn,"shortage") = dietrep(nn,"intake") - dietrep(nn,"required");
dietrep(nn,"ssrate")   = 100*dietrep(nn,"intake") / dietrep(nn,"required");

display "landuse   -- Cropped area              (1000ha)"
        "supply    -- Total food supply         (1000t)"
        "grossfood -- Gross food supply         (1000t)"
        "netfood   -- Net food supply           (1000t)"
        "current   -- Current intake            (grams/capita)"
        "potential -- Potential intake          (grams/capita)"
        "change    -- Change in daily diet      (grams/capita)"
        "required  -- Required daily nutrients  (kcal grams/capita)"
        "intake    -- Intaken nutrients per day (kcal grams/capita)"
        "shortage  -- Shortage per day          (kcal grams/capita)"
        "ssrate    -- Self sufficient rate      (percentage)"
        paddyrep, fieldrep, pasturerep, orchardrep, croprep, foodrep, dietrep;



$sTitle Export Report
Execute_Unload '%gdx_results%', paddyrep, fieldrep, pasturerep, orchardrep, croprep, foodrep, dietrep;

execute 'gdxxrw %gdx_results% o=%excel_results% par=paddyrep rng=paddyrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=fieldrep rng=fieldrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pasturerep rng=pasturerep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=orchardrep rng=orchardrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=croprep rng=croprep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=foodrep rng=foodrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=dietrep rng=dietrep!A1 rdim=1 cdim=1'

