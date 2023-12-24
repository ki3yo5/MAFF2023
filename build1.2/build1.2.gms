$title  Nutrition-Cropping Optimization Model

$onText
Build 1.2 Dec 23 2023

Cropping model with 16 crops but without livestock and processing foods.
Objective function is calorie deficit and nutrient intake balance only.
Contstraints on land size by each type and 250% margin for each cropiing area.
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
   pwheat
   barley
   pbarley
   naked
   corn
   sorghum
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
   paddy(c)   /
   rice
   pwheat
   psoy/
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
   mis_veges/
   pasture(c) /
   pbarley
   corn
   sorghum/
   orchard(c) /
   mandarin
   apple
   mis_fruits/
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
   land       'total land size (1000ha)'         /  4325  /
   lpaddy     'paddy field (1000ha)'             /  2352  /
   lupland    'total upland field (1000ha)'      /  1973  /
   lfield     'cropping field (1000ha)'          /  1123  /
   lorchard   'orchard (1000ha)'                 /   259  /
   lpasture   'pasture (1000ha)'                 /   591  /
   aweight    'constraint on cropping area'      /   5    /
   nweight    'weight on calorie balance'        /   .75  /
   fweight    'weight on change in diet'         /   .25  /
   item       'number of food items'             /    16  /;
   


$sTitle Agents for calculation
Set
   nn         'nutrition'         /calorie, protein, fat, carbonhydrate/;

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
   nbal(nn)      'Nutrients balance      (kcal grams/capita)'
   cbal          'Calorie balance        (kcal      /capita)'
   dbal(c)       'Change in diet         (     grams/capita)'
   objective     'Objective function' ;

ybal(t)..   sum(c, xcrop(c)*landreq(c,t) $ paddy(c)) =l= lpaddy;

fbal(t)..   sum(c, xcrop(c)*landreq(c,t) $ field(c)) =l= lfield;

pbal(t)..   sum(c, xcrop(c)*landreq(c,t) $ pasture(c)) =l= lpasture;

obal(t)..   sum(c, xcrop(c)*landreq(c,t) $ orchard(c)) =l= lorchard;

aybal(c)..   xcrop(c) $ paddy(c) =l= aweight*data(c,"area") $ paddy(c);

afbal(c)..   xcrop(c) $ field(c) =l= aweight*data(c,"area") $ field(c);

apbal(c)..   xcrop(c) $ pasture(c) =l= (10**6)*data(c,"area") $ pasture(c);

aobal(c)..   xcrop(c) $ orchard(c) =l= data(c,"area") $ orchard(c);
                                      
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
   dietrep      'Nutrient summary';

paddyrep(t,c) = xcrop.l(c)*landreq(c,t) $ paddy(c);
paddyrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ paddy(c));
fieldrep(t,c) = xcrop.l(c)*landreq(c,t) $ field(c);
fieldrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ field(c));
pasturerep(t,c) = xcrop.l(c)*landreq(c,t) $ pasture(c);
pasturerep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ pasture(c));
orchardrep(t,c) = xcrop.l(c)*landreq(c,t) $ orchard(c);
orchardrep(t,"total") = sum(c,xcrop.l(c)*landreq(c,t) $ orchard(c));

croprep(c,"landuse")   = xcrop.l(c);
croprep(c,"supply")    = xcrop.l(c)*data(c,"yield");
croprep(c,"grossfood") = xcrop.l(c)*data(c,"yield")*(t2g(c)/100);
croprep(c,"netfood")   = xcrop.l(c)*data(c,"yield")*(t2g(c)/100)*(g2n(c)/100);
croprep(c,"current")   = nnpc(c);
croprep(c,"potential") = croprep(c,"netfood")*(10**9)/(tpop*(10**6)*365);
croprep(c,"change")    = croprep(c,"netfood")*(10**9)/(tpop*(10**6)*365)-nnpc(c);
croprep("total",crep)  = sum(c, croprep(c,crep));

dietrep(nn,"required") = sum((a,g),pintake(a,g,nn))/tpop;
dietrep(nn,"intake")   = sum(c,croprep(c,"netfood")*nnvalue(c,nn)*(10**7)/(tpop*(10**6)*365));
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
        paddyrep, fieldrep, pasturerep, orchardrep, croprep, dietrep;



$sTitle Export Report
Execute_Unload '%gdx_results%', paddyrep, fieldrep, pasturerep, orchardrep, croprep, dietrep;

execute 'gdxxrw %gdx_results% o=%excel_results% par=paddyrep rng=paddyrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=fieldrep rng=fieldrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pasturerep rng=pasturerep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=orchardrep rng=orchardrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=croprep rng=croprep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=dietrep rng=dietrep!A1 rdim=1 cdim=1'

