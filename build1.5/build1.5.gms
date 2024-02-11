$title  Nutrition-Cropping Optimization Model

$onText
Build 1.5 Jan 13 2024

Cropping model with 16 crops, 2 marine products, 6 processing foods.
Objective function is calorie deficit and nutrient intake balance by 8 food groups.
The two components are weighted with 4 patterns of weights.
Contstraints on land size by each type, each month and expansion margins for each crops.
Calorie and nutrient balance is optimized for per capita per day.

Ishikawa K., Pre-simulation for DSS-ESSA Model. The MAFF Open Lab, 2024.
$offText

$if not setglobal build $setglobal build 1.5
$if not setglobal rate $setglobal rate 0

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
   processed(c)  /
   starch
   sugar
   oil
   miso
   soysource
   mis_foods     /

   t 'period'    /
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
   dec           /
   n 'nutrients' /
   calorie       'kcal'
   protein       'grams'
   fat           'grams'
   carbonhydrate 'grams'
   pop           'population (million)'
   supplypy      'supply per year (kg)'
   supplypd      'supply per day (grams)'/
   a 'age'       /
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
   p 'production'/
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
   g 'gender'    /
   male
   female        /
   v 'value'     /
   pc           'percapita per day'
   value        'nutrients in net food 100g'/
   f 'food group'/
   grain
   tuber
   pulse
   veget
   fruit
   starch
   sugar
   other         /
   l 'upper limit for area expansion' /l2, l3, l4, l5/
   w 'weight on calorie balance'      /w100, w75, w50, w25/;

* i for ingredient crops in food processing 
alias (c,i);

* m for month by commencement of shock
alias (t,m);

set
   mmap(m,c) 'month-crop mapping for fixed cropping area'  /
   jan.(wheat,pwheat,barley,pbarley,naked,mis_grains)
   feb.(wheat,pwheat,barley,pbarley,naked,mis_grains)
   mar.(wheat,pwheat,barley,pbarley,naked,mis_grains)
   apr.(wheat,pwheat,barley,pbarley,naked,mis_grains,potato)
   may.(rice,corn,mis_grains,sweetp,potato,soy,psoy,sbeat)
   jun.(rice,corn,mis_grains,sweetp,potato,soy,psoy,sbeat)
   jul.(rice,corn,sorghum,sweetp,potato,soy,psoy,mis_beans,sbeat)
   aug.(rice,corn,sorghum,sweetp,potato,soy,psoy,mis_beans,scane,sbeat)
   sep.(rice,corn,sweetp,potato,soy,psoy,mis_beans,scane,sbeat)
   oct.(rice,corn,potato,soy,psoy,mis_beans,scane,sbeat)
   nov.(wheat,pwheat,barley,pbarley,naked,mis_beans,scane)
   dec.(wheat,pwheat,barley,pbarley,naked,mis_beans,scane) /
   fmap(f,c) 'fgroup-crop mapping'         /
   grain.(rice,wheat,pwheat,barley,naked,mis_grains)
   tuber.(sweetp,potato)
   pulse.(soy,psoy,mis_beans)
   veget.(green_veges,mis_veges)
   fruit.(mandarin,apple,mis_fruits)
   starch.(starch)
   sugar.(sugar)
   other.(oil,miso,soysource,mis_foods)    /;

parameter
   k(f) 'Number of crops in fgroup' /
   grain  = 5 ,
   tuber  = 2 ,
   pulse  = 2 ,
   veget  = 2 ,
   fruit  = 3 ,
   starch = 1 ,
   sugar  = 1 ,
   other  = 3 /
   s(c)  'Government stock (1000t)' /
   rice   = 1000 ,
   wheat  = 900  / ;

parameter
   data(c,p)      'Production data'
   landreq(c,t)   'Months of land occupation by crop (hectares)'
   intake(a,g,n)  'Required daily intake of nutrients'
   nvalue(c,v,n)  'Nutritive supply and value of foods';
  
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
   limit      'upper limit for area expansion'
   weight     'weight on calorie balance';
   
Table
   coefficient(c,i)   'Output processed food by 1 unit input crop'
                  corn   sweetp   potato   soy   scane   sbeat   rapeseed
   starch         0.52    0.77     0.77     
   sugar                                          0.17    0.17             
   oil                                                             0.37
   miso                                    5.0
   soysource                               3.3                            ;



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
   x2fn(c,i,nn)          'Cropping area(1000ha) to nutritive value(kcal grams)   (ratio)';

tpop = sum((a,g), intake(a,g,"pop"));

pintake(a,g,"calorie")       = intake(a,g,"pop") * intake(a,g,"calorie");
pintake(a,g,"protein")       = intake(a,g,"pop") * intake(a,g,"protein");
pintake(a,g,"fat")           = intake(a,g,"pop") * intake(a,g,"fat");
pintake(a,g,"carbonhydrate") = intake(a,g,"pop") * intake(a,g,"carbonhydrate");

nreq(nn) = sum((a,g),pintake(a,g,nn))/tpop;

nnvalue(c,"calorie")         = nvalue(c,"value","calorie");
nnvalue(c,"protein")         = nvalue(c,"value","protein");
nnvalue(c,"fat")             = nvalue(c,"value","fat");
nnvalue(c,"carbonhydrate")   = nvalue(c,"value","carbonhydrate");
nnpc(c)                      = nvalue(c,"pc","supplypd");

t2g(c)       = data(c,"gross")/data(c,"total");
t2p(c)       = data(c,"processing")/data(c,"total");
t2p("soy")   = 18/data("soy","prod");
t2p("psoy")  = 18/data("psoy","prod");
t2f(c)       = data(c,"feed")/data(c,"total");
g2n(c)       = data(c,"g2n")/100;
x2n(c)       = data(c,"yield")*t2g(c)*g2n(c)*(10**9);
x2nn(c,nn)   = data(c,"yield")*t2g(c)*g2n(c)*(10**7)*nnvalue(c,nn);
x2f(c,i)     = data(i,"yield")*t2p(i)*coefficient(c,i)*(10**9);
x2fn(c,i,nn) = data(i,"yield")*t2p(i)*coefficient(c,i)*(10**7)*nnvalue(c,nn);

Display mmap, fmap, k, tpop, pintake, nreq, nnvalue, nnpc, x2f, x2n;



$sTitle Endogenous Variables and Equations
Variable
   xcrop(c)      'Cropping area                     (1000ha)'
   ndeficit(nn)
   cdeficit
   crate
   x(c)
   r(c)
   delta(f)
   deltasq(f)
   deltamn(f)
   deltamnsq(f)
   target        ;

Positive Variable xcrop;

Equation
   ybal(t)       'Land balance on          paddy    (1000ha)'
   fbal(t)       '                         upland   (1000ha)'
   pbal(t)       '                         pasture  (1000ha)'
   obal(t)       '                         orchard  (1000ha)'
   aybal(c)      'Cropping area balance on paddy    (1000ha)'
   afbal(c)      '                         upland   (1000ha)'
   apbal(c)      '                         pasture  (1000ha)'
   aobal(c)      '                         orchard  (1000ha)'
   albal(c)      '                         local    (1000ha)'
   jan(c)        'Cropping area balance by month    (1000ha)'
   feb(c)
   mar(c)
   apr(c)
   may(c)
   jun(c)
   jul(c)
   aug(c)
   sep(c)
   oct(c)
   nov(c)
   dec(c)
   nbal(nn)      'Nutrients balance         (kcal grams/capita)'
   cbal          'Calorie balance           (kcal      /capita)'
   croc          'Rate                                         '
   xbal(c)       'Net food supply balance        (grams/capita)'
   xroc(c)       'Rate                                         '
   dbal(f)       'Sum of diet balance by fgroup  (grams/capita)'
   dbalsq(f)     'Squared                                      '
   droc(f)       'Mean rate                                    '
   drocsq(f)     'Squared mean rate                            '
   obj       
   alt           ;

ybal(t)..    sum(c, xcrop(c)*landreq(c,t) $ paddy(c))   =l= lpaddy;
fbal(t)..    sum(c, xcrop(c)*landreq(c,t) $ field(c))   =l= lfield;
pbal(t)..    sum(c, xcrop(c)*landreq(c,t) $ pasture(c)) =l= lpasture;
obal(t)..    sum(c, xcrop(c)*landreq(c,t) $ orchard(c)) =l= lorchard;

aybal(c)..   xcrop(c) $ paddy(c)   =l= limit    *data(c,"area") $ paddy(c);
afbal(c)..   xcrop(c) $ field(c)   =l= limit    *data(c,"area") $ field(c);
apbal(c)..   xcrop(c) $ pasture(c) =l= (10**6)  *data(c,"area") $ pasture(c);
aobal(c)..   xcrop(c) $ orchard(c) =l= 1        *data(c,"area") $ orchard(c);
albal(c)..   xcrop(c) $ local(c)   =l= (limit/2)*data(c,"area") $ local(c);

jan(c)..     xcrop(c) $ mmap("jan",c) =l= data(c,"area") $ mmap("jan",c);
feb(c)..     xcrop(c) $ mmap("feb",c) =l= data(c,"area") $ mmap("feb",c);
mar(c)..     xcrop(c) $ mmap("mar",c) =l= data(c,"area") $ mmap("mar",c);
apr(c)..     xcrop(c) $ mmap("apr",c) =l= data(c,"area") $ mmap("apr",c);
may(c)..     xcrop(c) $ mmap("may",c) =l= data(c,"area") $ mmap("may",c);
jun(c)..     xcrop(c) $ mmap("jun",c) =l= data(c,"area") $ mmap("jun",c);
jul(c)..     xcrop(c) $ mmap("jul",c) =l= data(c,"area") $ mmap("jul",c);
aug(c)..     xcrop(c) $ mmap("aug",c) =l= data(c,"area") $ mmap("aug",c);
sep(c)..     xcrop(c) $ mmap("sep",c) =l= data(c,"area") $ mmap("sep",c);
oct(c)..     xcrop(c) $ mmap("oct",c) =l= data(c,"area") $ mmap("oct",c);
nov(c)..     xcrop(c) $ mmap("nov",c) =l= data(c,"area") $ mmap("nov",c);
dec(c)..     xcrop(c) $ mmap("dec",c) =l= data(c,"area") $ mmap("dec",c);
                                      
nbal(nn)..   ndeficit(nn) =e= nreq(nn) - sum(c,xcrop(c)*x2nn(c,nn))/(tpop*(10**6)*365)
                                       - sum((i,c),xcrop(i)*x2fn(c,i,nn))/(tpop*(10**6)*365);
                                       
cbal..       cdeficit     =e= ndeficit("calorie");

croc..       crate        =e= cdeficit/nreq("calorie");

xbal(c)..    x(c)         =e= nnpc(c) - xcrop(c)*x2n(c)/(tpop*(10**6)*365)
                                      - sum(i,xcrop(i)*x2f(c,i))/(tpop*(10**6)*365);
                                      
xroc(c)..    r(c)         =e= x(c) / (nnpc(c) + 10**(-6)) ;

dbal(f)..    delta(f)     =e= sum(c $fmap(f,c), x(c));

dbalsq(f)..  deltasq(f)   =e= sqr(delta(f));

droc(f)..    deltamn(f)   =e= sum(c $fmap(f,c), r(c)) / k(f);

drocsq(f)..  deltamnsq(f) =e= sqr(deltamn(f));

obj..        target       =e= weight*cdeficit + sum(f,((1-weight)/8)*deltasq(f));

alt..        target       =e= weight*crate    + sum(f,((1-weight)/8)*deltamnsq(f));

Model constraint  / ybal,fbal,pbal,obal,aybal,afbal,apbal,aobal,albal /;

Model balance     / nbal,cbal,croc,xbal,xroc,dbal,dbalsq,droc,drocsq /;

Model sol_dif     / constraint+balance+obj /;

Model sol_rat     / constraint+balance+alt /;

Model sol_dif_jan  / sol_dif+jan /;
Model sol_dif_feb  / sol_dif+feb /;
Model sol_dif_mar  / sol_dif+mar /;
Model sol_dif_apr  / sol_dif+apr /;
Model sol_dif_may  / sol_dif+may /;
Model sol_dif_jun  / sol_dif+jun /;
Model sol_dif_jul  / sol_dif+jul /;
Model sol_dif_aug  / sol_dif+aug /;
Model sol_dif_sep  / sol_dif+sep /;
Model sol_dif_oct  / sol_dif+oct /;
Model sol_dif_nov  / sol_dif+nov /;
Model sol_dif_dec  / sol_dif+dec /;

Model sol_rat_jan  / sol_rat+jan /;
Model sol_rat_feb  / sol_rat+feb /;
Model sol_rat_mar  / sol_rat+mar /;
Model sol_rat_apr  / sol_rat+apr /;
Model sol_rat_may  / sol_rat+may /;
Model sol_rat_jun  / sol_rat+jun /;
Model sol_rat_jul  / sol_rat+jul /;
Model sol_rat_aug  / sol_rat+aug /;
Model sol_rat_sep  / sol_rat+sep /;
Model sol_rat_oct  / sol_rat+oct /;
Model sol_rat_nov  / sol_rat+nov /;
Model sol_rat_dec  / sol_rat+dec /;



$sTitle Standard Solution (all croping area in the first year are variable)
Set
   crep  /
   landuse     'Area cropped               (1000ha)'
   demand      'Net food demand            (1000t)' 
   supply      'Total food supply          (1000t)'
   grossfood   'Gross food supply          (1000t)'
   netfood     'Net food supply            (1000t)'
   current     'Current intake             (grams/capita)'
   potential   'Potential intake           (grams/capita)'
   change      'Change in diet             (grams/capita)' /
   nrep  /
   required    'Required daily nutrients   (kcal grams/capita)'
   intake      'Intaken nutrients per day  (kcal grams/capita)'
   shortage    'Shortage per day           (kcal grams/capita)'
   ssrate      'Self sufficient rate       (percentage)       '/;

Parameter
   wxcrop(w,c)  'Cropping area by weight   (1000ha)'
   lxcrop(l,c)  'Cropping area by limit    (1000ha)'
   mxcrop(m,c)  'Cropping area by month    (1000ha)'
   paddyrep     'Land report summary on paddy'
   fieldrep     'Land report summary on field'
   pasturerep   'Land report summary on pasture'
   orchardrep   'Land report summary on orchard'
   wcroprep     'Crop report summary'
   wfoodrep     'Processed food summary'
   wdietrep     'Nutrient summary'
   lcroprep     'Crop report summary'
   lfoodrep     'Processed food summary'
   ldietrep     'Nutrient summary'
   mcroprep     'Crop report summary'
   mfoodrep     'Processed food summary'
   mdietrep     'Nutrient summary'
   radar        'Radar chart summary'
   stock        'Stock reserved';

limit = 3;

if(%rate%,
   weight = 1;
   solve sol_rat minimizing target using nlp ;
   wxcrop("w100",c) = xcrop.l(c);
   weight = 0.75;
   solve sol_rat minimizing target using nlp ;
   wxcrop("w75",c) = xcrop.l(c);
   weight = 0.50;
   solve sol_rat minimizing target using nlp ;
   wxcrop("w50",c) = xcrop.l(c);
   weight = 0.25;
   solve sol_rat minimizing target using nlp ;
   wxcrop("w25",c) = xcrop.l(c);
else
   weight = 1;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w100",c) = xcrop.l(c);
   weight = 0.75;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w75",c) = xcrop.l(c);
   weight = 0.50;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w50",c) = xcrop.l(c);
   weight = 0.25;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w25",c) = xcrop.l(c);
);

wcroprep(w,c,"landuse")   = wxcrop(w,c) $edible(c);
wcroprep(w,c,"supply")    = wxcrop(w,c)*data(c,"yield") $edible(c);
wcroprep(w,c,"grossfood") = wxcrop(w,c)*data(c,"yield")*t2g(c) $edible(c);
wcroprep(w,c,"netfood")   = wxcrop(w,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
wcroprep(w,c,"current")   = nnpc(c)$edible(c);
wcroprep(w,c,"potential") = wcroprep(w,c,"netfood")*(10**9)/(tpop*(10**6)*365);
wcroprep(w,c,"change")    = wcroprep(w,c,"potential")-wcroprep(w,c,"current");
wcroprep(w,"total",crep)  = sum(c, wcroprep(w,c,crep));

wfoodrep(w,c,"netfood")   = sum(i,wxcrop(w,i)*data(i,"yield")*t2p(i)*coefficient(c,i) $processed(c));
wfoodrep(w,c,"current")   = nnpc(c)$processed(c);
wfoodrep(w,c,"potential") = wfoodrep(w,c,"netfood")*(10**9)/(tpop*(10**6)*365);
wfoodrep(w,c,"change")    = wfoodrep(w,c,"potential")-wfoodrep(w,c,"current");
wfoodrep(w,"total",crep)  = sum(c, wfoodrep(w,c,crep));

wdietrep(w,nn,"required") = nreq(nn);
wdietrep(w,nn,"intake")   = sum(c,wcroprep(w,c,"netfood")*nnvalue(c,nn)*(10**7)) /(tpop*(10**6)*365)
                          + sum(c,wfoodrep(w,c,"netfood")*nnvalue(c,nn)*(10**7)) /(tpop*(10**6)*365)
                          + sum(c,data(c,"net")*nnvalue(c,nn)*(10**7)$marine(c)) /(tpop*(10**6)*365);
wdietrep(w,nn,"shortage") = wdietrep(w,nn,"intake") - wdietrep(w,nn,"required");
wdietrep(w,nn,"ssrate")   = 100*wdietrep(w,nn,"intake") / wdietrep(w,nn,"required");

radar(w,f,"netfood")      = sum(c $fmap(f,c), wxcrop(w,c)*data(c,"yield")*t2g(c)*g2n(c));
radar(w,"starch","netfood") = wfoodrep(w,"starch","netfood");
radar(w,"sugar","netfood")  = wfoodrep(w,"sugar","netfood");
radar(w,"other","netfood")  = sum(c $fmap("other",c), wfoodrep(w,c,"netfood"));
radar(w,f,"current")      = sum(c $fmap(f,c), nnpc(c));
radar(w,f,"potential")    = radar(w,f,"netfood")*(10**9)/(tpop*(10**6)*365);
radar(w,f,"change")       = radar(w,f,"potential") - radar(w,f,"current");
radar(w,f,"ssrate")       = 100*radar(w,f,"potential") / radar(w,f,"current");

weight = 0.75;

if(%rate%,
   limit = 2;
   solve sol_rat minimizing target using nlp ;
   lxcrop("l2",c) = xcrop.l(c);
   limit = 3;
   solve sol_rat minimizing target using nlp ;
   lxcrop("l3",c) = xcrop.l(c);
   limit = 4;
   solve sol_rat minimizing target using nlp ;
   lxcrop("l4",c) = xcrop.l(c);
   limit = 5;
   solve sol_rat minimizing target using nlp ;
   lxcrop("l5",c) = xcrop.l(c);
else
   limit = 2;
   solve sol_dif minimizing target using nlp ;
   lxcrop("l2",c) = xcrop.l(c);
   limit = 3;
   solve sol_dif minimizing target using nlp ;
   lxcrop("l3",c) = xcrop.l(c);
   limit = 4;
   solve sol_dif minimizing target using nlp ;
   lxcrop("l4",c) = xcrop.l(c);
   limit = 5;
   solve sol_dif minimizing target using nlp ;
   lxcrop("l5",c) = xcrop.l(c);
);

lcroprep(l,c,"landuse")   = lxcrop(l,c) $edible(c);
lcroprep(l,c,"supply")    = lxcrop(l,c)*data(c,"yield") $edible(c);
lcroprep(l,c,"grossfood") = lxcrop(l,c)*data(c,"yield")*t2g(c) $edible(c);
lcroprep(l,c,"netfood")   = lxcrop(l,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
lcroprep(l,c,"current")   = nnpc(c)$edible(c);
lcroprep(l,c,"potential") = lcroprep(l,c,"netfood")*(10**9)/(tpop*(10**6)*365);
lcroprep(l,c,"change")    = lcroprep(l,c,"potential")-lcroprep(l,c,"current");
lcroprep(l,"total",crep)  = sum(c, lcroprep(l,c,crep));

lfoodrep(l,c,"netfood")   = sum(i,lxcrop(l,i)*data(i,"yield")*t2p(i)*coefficient(c,i) $processed(c));
lfoodrep(l,c,"current")   = nnpc(c)$processed(c);
lfoodrep(l,c,"potential") = lfoodrep(l,c,"netfood")*(10**9)/(tpop*(10**6)*365);
lfoodrep(l,c,"change")    = lfoodrep(l,c,"potential")-lfoodrep(l,c,"current");
lfoodrep(l,"total",crep)  = sum(c, lfoodrep(l,c,crep));

ldietrep(l,nn,"required") = nreq(nn);
ldietrep(l,nn,"intake")   = sum(c,lcroprep(l,c,"netfood")*nnvalue(c,nn)*(10**7)) /(tpop*(10**6)*365)
                          + sum(c,lfoodrep(l,c,"netfood")*nnvalue(c,nn)*(10**7)) /(tpop*(10**6)*365)
                          + sum(c,data(c,"net")*nnvalue(c,nn)*(10**7)$marine(c)) /(tpop*(10**6)*365);
ldietrep(l,nn,"shortage") = ldietrep(l,nn,"intake") - ldietrep(l,nn,"required");
ldietrep(l,nn,"ssrate")   = 100*ldietrep(l,nn,"intake") / ldietrep(l,nn,"required");

* limit = 3, weight = 0.75 for landuse report

paddyrep(t,c) = wxcrop("w75",c)*landreq(c,t) $ paddy(c);
paddyrep(t,"total") = sum(c,paddyrep(t,c));
fieldrep(t,c) = wxcrop("w75",c)*landreq(c,t) $ field(c);
fieldrep(t,"total") = sum(c,fieldrep(t,c));
pasturerep(t,c) = wxcrop("w75",c)*landreq(c,t) $ pasture(c);
pasturerep(t,"total") = sum(c,pasturerep(t,c));
orchardrep(t,c) = wxcrop("w75",c)*landreq(c,t) $ orchard(c);
orchardrep(t,"total") = sum(c,orchardrep(t,c));



$sTitle First-year Solutions (cropping area is fixed each month)
limit = 3;
weight = 0.75;
if(%rate%,
   solve sol_rat_jan minimizing target using nlp ;
   mxcrop("jan",c) = xcrop.l(c);
   solve sol_rat_feb minimizing target using nlp ;
   mxcrop("feb",c) = xcrop.l(c);
   solve sol_rat_mar minimizing target using nlp ;
   mxcrop("mar",c) = xcrop.l(c);
   solve sol_rat_apr minimizing target using nlp ;
   mxcrop("apr",c) = xcrop.l(c);
   solve sol_rat_may minimizing target using nlp ;
   mxcrop("may",c) = xcrop.l(c);
   solve sol_rat_jun minimizing target using nlp ;
   mxcrop("jun",c) = xcrop.l(c);
   solve sol_rat_jul minimizing target using nlp ;
   mxcrop("jul",c) = xcrop.l(c);
   solve sol_rat_aug minimizing target using nlp ;
   mxcrop("aug",c) = xcrop.l(c);
   solve sol_rat_sep minimizing target using nlp ;
   mxcrop("sep",c) = xcrop.l(c);
   solve sol_rat_oct minimizing target using nlp ;
   mxcrop("oct",c) = xcrop.l(c);
   solve sol_rat_nov minimizing target using nlp ;
   mxcrop("nov",c) = xcrop.l(c);
   solve sol_rat_dec minimizing target using nlp ;
   mxcrop("dec",c) = xcrop.l(c);
else
   solve sol_dif_jan minimizing target using nlp ;
   mxcrop("jan",c) = xcrop.l(c);
   solve sol_dif_feb minimizing target using nlp ;
   mxcrop("feb",c) = xcrop.l(c);
   solve sol_dif_mar minimizing target using nlp ;
   mxcrop("mar",c) = xcrop.l(c);
   solve sol_dif_apr minimizing target using nlp ;
   mxcrop("apr",c) = xcrop.l(c);
   solve sol_dif_may minimizing target using nlp ;
   mxcrop("may",c) = xcrop.l(c);
   solve sol_dif_jun minimizing target using nlp ;
   mxcrop("jun",c) = xcrop.l(c);
   solve sol_dif_jul minimizing target using nlp ;
   mxcrop("jul",c) = xcrop.l(c);
   solve sol_dif_aug minimizing target using nlp ;
   mxcrop("aug",c) = xcrop.l(c);
   solve sol_dif_sep minimizing target using nlp ;
   mxcrop("sep",c) = xcrop.l(c);
   solve sol_dif_oct minimizing target using nlp ;
   mxcrop("oct",c) = xcrop.l(c);
   solve sol_dif_nov minimizing target using nlp ;
   mxcrop("nov",c) = xcrop.l(c);
   solve sol_dif_dec minimizing target using nlp ;
   mxcrop("dec",c) = xcrop.l(c);
   );

* limit = 3, weight = 0.75 for first-year report

mcroprep(m,c,"landuse")   = mxcrop(m,c) $edible(c);
mcroprep(m,c,"supply")    = mxcrop(m,c)*data(c,"yield") $edible(c);
mcroprep(m,c,"grossfood") = mxcrop(m,c)*data(c,"yield")*t2g(c) $edible(c);
mcroprep(m,c,"netfood")   = mxcrop(m,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
mcroprep(m,c,"current")   = nnpc(c)$edible(c);
mcroprep(m,c,"potential") = mcroprep(m,c,"netfood")*(10**9)/(tpop*(10**6)*365);
mcroprep(m,c,"change")    = mcroprep(m,c,"potential")-mcroprep(m,c,"current");
mcroprep(m,"total",crep)  = sum(c, mcroprep(m,c,crep));

mfoodrep(m,c,"netfood")   = sum(i, mxcrop(m,i)*data(i,"yield")*t2p(i)*coefficient(c,i) $processed(c));
mfoodrep(m,c,"current")   = nnpc(c)$processed(c);
mfoodrep(m,c,"potential") = mfoodrep(m,c,"netfood")*(10**9)/(tpop*(10**6)*365);
mfoodrep(m,c,"change")    = mfoodrep(m,c,"potential")-mfoodrep(m,c,"current");
mfoodrep(m,"total",crep)  = sum(c, mfoodrep(m,c,crep));

mdietrep(m,nn,"required") = nreq(nn);
mdietrep(m,nn,"intake")   = sum(c,mcroprep(m,c,"netfood")*nnvalue(c,nn)*(10**7)) /(tpop*(10**6)*365)
                          + sum(c,mfoodrep(m,c,"netfood")*nnvalue(c,nn)*(10**7)) /(tpop*(10**6)*365)
                          + sum(c,data(c,"net")*nnvalue(c,nn)*(10**7)$marine(c)) /(tpop*(10**6)*365);
mdietrep(m,nn,"shortage") = mdietrep(m,nn,"intake") - mdietrep(m,nn,"required");
mdietrep(m,nn,"ssrate")   = 100*mdietrep(m,nn,"intake") / mdietrep(m,nn,"required");

stock("netfood",c)        = s(c)*g2n(c);
stock("netfood","total")  = sum(c,stock("netfood",c));
stock("netfoodpc",c)      = stock("netfood",c)*(10**9)/(tpop*(10**6)*365);
stock("netfoodpc","total")= sum(c,stock("netfoodpc",c));
stock("calorie",c)        = stock("netfood",c)*nnvalue(c,"calorie")*(10**7)/(tpop*(10**6)*365);
stock("calorie","total")  = sum(c,stock("calorie",c));

display wcroprep, wfoodrep, wdietrep, radar, stock;



$sTitle Export Report
Execute_Unload '%gdx_results%',
paddyrep, fieldrep, pasturerep, orchardrep,
wcroprep, wfoodrep, wdietrep, lcroprep, lfoodrep, ldietrep, mcroprep, mfoodrep, mdietrep,
radar, stock;

execute 'gdxxrw %gdx_results% o=%excel_results% par=paddyrep   rng=paddyrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=fieldrep   rng=fieldrep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pasturerep rng=pasturerep!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=orchardrep rng=orchardrep!A1 rdim=1 cdim=1'

execute 'gdxxrw %gdx_results% o=%excel_results% par=wcroprep rng=wcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wfoodrep rng=wfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wdietrep rng=wdietrep!A1 rdim=2 cdim=1'

execute 'gdxxrw %gdx_results% o=%excel_results% par=lcroprep rng=lcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=lfoodrep rng=lfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=ldietrep rng=ldietrep!A1 rdim=2 cdim=1'

execute 'gdxxrw %gdx_results% o=%excel_results% par=mcroprep rng=mcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=mfoodrep rng=mfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=mdietrep rng=mdietrep!A1 rdim=2 cdim=1'

execute 'gdxxrw %gdx_results% o=%excel_results% par=radar rng=radar!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=stock rng=stock!A1 rdim=1 cdim=1'
