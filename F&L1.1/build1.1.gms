$title  Livestock Optimization Model

$onText
Build 1.1

Simple model with 13 feeds, 7 livestocks, 5 animal products.
Objective function for calorie deficit weighted with 0,75 and diet balance.
Contstraints on feed distribution and TDN and CP balance.
Stock release scenario added.

Ishikawa K., Pre-simulation for Suiss Model. The MAFF Open Lab, 2024.
$offText

$if not setglobal build $setglobal build 1.1
$if not setglobal rate $setglobal rate 0

$setglobal gdx_results .\results\%build%_results.gdx
$setglobal excel_results .\results\%build%_results.xlsx

$sTitle Input Data
set
    i animal products /
      beef
      pork
      chicken
      egg
      milk /
    j feeds /
      fodder         'timothy (1st heading)'
      ricestraw      'rice'
      ricebran       'rice'
      wheatstraw     'wheat'
      wheatbran      'wheat'
      potatovines    'sweetpotato'
      soybeancake    'soy'
      rapeseedcake   'rapeseed'
      beetpulp       'sugarbeat'
      molasses       'sugarbeat'
      bagasse        'sugarcane'
      meatbonemeal
      fishmeal
      corn           'stock only'
      sorghum        'stock only'
      wheat          'stock only'
      barley         'stock only'
      rice           'stock only'/
    k feed nutrients /
      tdn            'total digestable nutrients (MT per head)'
      cp             'crude protain              (%)'
      cp_low
      cp_mid
      cp_high /
    l livestocks /
      dairycow       '> 2 years'
      dairyox        '> 2 years'
      heifer         '1 - 2 years'
      calves         '< 12 months'
      swine
      broiler
      layinghens /
    n nutrients /
      calorie        'kcal'
      protein        'grams'
      fat            'grams'
      carbonhydrate  'grams'
      pop            'population (million)'
      supplypy       'supply per year (kg)'
      supplypd       'supply per day (grams)'/
    p production /
      prod           '1000t'
      import         '1000t'
      export         '1000t'
      stock          '1000t'
      total          '1000t'
      feed           '1000t'
      seed           '1000t'
      processing     '1000t'
      passenger      '1000t'
      wear           '1000t'
      gross          '1000t'
      g2n            'percent'
      net            '1000t' /
    q quantity /
      stock
      pre
      post /
    a age /
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
    g gender  /
      male
      female /
    v value /
      pc             'percapita per day'
      value          'nutrients in net food 100g'/ ;

parameter
    yield(i,l)      'product yield          (kilograms per head)'
    fdemand(l,k)    'feed nutrient demand   (TDN:kilograms per head, CP:%)'
    fsupply(l,k,j)  'feed nutrient supply   (%) '
    fconst(j,q)     'feed constraints       (t)'
    data(i,p)       'current production     (1000t,%)'
    intake(a,g,n)   'Required daily intake of nutrients'
    nvalue(i,v,n)   'nutritional value      (kcal grams/netfood 100grams)'
    head(l)         'number of animals      (head)'/
      dairycow      861700
      dairyox       237760
      heifer        62300
      calves        447200
      swine         8949000
      broiler       139230000
      layinghens    182661000 /;

$gdxin yield.gdx
$load  yield
$gdxin
$gdxin fdemand.gdx
$load  fdemand
$gdxin
$gdxin fsupply.gdx
$load  fsupply
$gdxin
$gdxin fconst.gdx
$load  fconst
$gdxin
$gdxin prod.gdx
$load  data
$gdxin
$gdxin intake.gdx
$load intake
$gdxin
$gdxin nvalue.gdx
$load  nvalue
$gdxin

Display yield,fdemand,fsupply,fconst,data,nvalue,head;

Scalar
    weight          'weight on calorie balance'
    limit           'limit on feed production capacity'
    spent           'rate of dairycow spent for beef production'
    culled          'rate of layinghens culled for chicken prodution'
    lactating       'rate of dairycow lactating for milk production';
    
    weight    = 0.75;
    limit     = 3;
    spent     = (447200/2) / 861700;
    culled    = 83304000 / 182661000;
    lactating = 736500 / 861800;
    
    yield("beef","dairycow") = yield("beef","dairycow")*spent;
    yield("milk","dairycow") = yield("milk","dairycow")*lactating;
    yield("chicken","layinghens") = yield("chicken","layinghens")*culled;
    
    fconst("ricestraw","post")   = limit*fconst("ricestraw","pre");
    fconst("wheatstraw","post")  = limit*fconst("wheatstraw","pre");
    fconst("potatovines","post") = limit*fconst("potatovines","pre");

Display weight,limit,spent,culled,lactating,fconst;



$sTitle Agents for calculation
Set
    nn         'nutrition'         /calorie, protein, fat, carbonhydrate/;

Parameter
    tpop                  'National population                (million)'
    pintake(a,g,nn)       'Daily intake requirement           (kcal grams/million)'
    nreq(nn)              'Daily intake requirement           (kcal grams/capita)'
    nnvalue(i,nn)         'Nutritive value of foods           (kcal grams/netfood grams)'
    nnpc(i)               'Current daily intake of netfood    (grams/day-capita)'
    x2n(l,i)              'Head to net food                   (grams)'
    x2nn(l,i,nn)          'Head to nutritional value          (kcal grams)';

    tpop = sum((a,g), intake(a,g,"pop"));

    pintake(a,g,"calorie")       = intake(a,g,"pop") * intake(a,g,"calorie") /100;
    pintake(a,g,"protein")       = intake(a,g,"pop") * intake(a,g,"protein") /100;
    pintake(a,g,"fat")           = intake(a,g,"pop") * intake(a,g,"fat") /100;
    pintake(a,g,"carbonhydrate") = intake(a,g,"pop") * intake(a,g,"carbonhydrate") /100;

    nreq(nn) = sum((a,g),pintake(a,g,nn))/tpop;

    nnvalue(i,"calorie")         = nvalue(i,"value","calorie");
    nnvalue(i,"protein")         = nvalue(i,"value","protein");
    nnvalue(i,"fat")             = nvalue(i,"value","fat");
    nnvalue(i,"carbonhydrate")   = nvalue(i,"value","carbonhydrate");
    nnpc(i)                      = nvalue(i,"pc","supplypd");

    x2n(l,i)     = yield(i,l)*(data(i,"g2n")/100)*1000;
    x2nn(l,i,nn) = yield(i,l)*(data(i,"g2n")/100)*1000*nnvalue(i,nn)*0.8;
    


$sTitle Endogenous Variables and Equations
variable
    xlive(l)        'head of animal l'
    yfeed(l,j)      'distribution of feed j to animal l (t)'
    tdnd(l)         'TDN                                (t)'
    tdns(l)         'TDN                                (t)'
    cpd(l)          'CP                                 (t)'
    cps(l)          'CP                                 (t)'
    cal
    delta
    target;
    
Positive Variable xlive, yfeed;

equation
    tdndemand       'TDN demand for animal l'
    tdnsupply       'TDN supply for animal l by feed j'
    tdnbal          'TDN balance'
    cpdemand        'CP demand for animal l'
    cpsupply        'CP supply for animal l'
    cpbal           'CP balance'
    distbal         'distribution balance'
    bredbal         'livestock breeding balance'
    dairyoxrep      'reproduction of dairy ox'
    heiferrep       'reproduction of heifer'
    calfrep         'reproduction of calves'        
    calorie         'calorie balance'
    diet            'diet balance'
    obj             'objective function on calorie deficit amount';

    tdndemand(l)..  tdnd(l) =e= xlive(l)*fdemand(l,"tdn")/1000;
    tdnsupply(l)..  tdns(l) =e= sum(j, yfeed(l,j)*fsupply(l,"tdn",j)/100);
    tdnbal(l)..     tdnd(l) =l= tdns(l);    
    cpdemand(l)..   cpd(l)  =e= tdnd(l)*fdemand(l,"cp_mid")/100;
    cpsupply(l)..   cps(l)  =e= sum(j, yfeed(l,j)*fsupply(l,"cp",j)/100);
    cpbal(l)..      cpd(l)  =l= cps(l);
    
    distbal(j)..    sum(l, yfeed(l,j)) =l= fconst(j,"post");
    bredbal(l)..    xlive(l)           =l= limit*head(l);
    
    dairyoxrep..    head("dairyox")*xlive("dairycow") =l= xlive("dairyox")*head("dairycow");
    heiferrep..     head("heifer")*xlive("dairycow")  =l= xlive("heifer")*head("dairycow");
    calfrep..       head("calves")*xlive("dairycow")  =l= xlive("calves")*head("dairycow");

    calorie..       cal     =e= nreq("calorie") - sum((i,l),xlive(l)*x2nn(l,i,"calorie"))/(tpop*(10**6)*365);
    diet..          delta   =e= sum(i, (nnpc(i) - sum(l,    xlive(l)*x2n(l,i))           /(tpop*(10**6)*365)));
    obj..           target  =e= weight*cal + (1-weight)*delta;


model sol_cp_mid /all/;
solve sol_cp_mid using lp minimizing target;
Display xlive.l;

equation
    cpdemand_low
    cpdemand_high
    distbal_stock;
    
    cpdemand_low(l)..    cpd(l)  =e= tdnd(l)*fdemand(l,"cp_low")/100;
    cpdemand_high(l)..   cpd(l)  =e= tdnd(l)*fdemand(l,"cp_high")/100;
    distbal_stock(J)..   sum(l, yfeed(l,j)) =l= fconst(j,"post")+fconst(j,"stock");

model sol_cp_low  /sol_cp_mid - cpdemand + cpdemand_low/;
model sol_cp_high /sol_cp_mid - cpdemand + cpdemand_high/;
model sol_stock   /sol_cp_mid - distbal  + distbal_stock/;



$sTitle Report on Solution
Set
    z scenario               /low, mid, high, fstock/
    nonzero(l)               /dairycow,dairyox,heifer,calves,layinghens/
    carcass(i)               /beef,pork,chicken/
    erep /
      tdp_dist               'Potential TDP distribution (kg/year-capita)'
      cp_dist                'Potential CP distribution  (kg/year-capita)'/
    prep /
      current_head           'Current animal population'
      potential_head         'Potential animal population'
      change                 'Change in population'
      roc                    'Rate of change (%)'
      carcass                'Carcass by early slaughter'/
    frep /
      current_kg_pypc        'Current food supply        (kg/year-capita)'
      potential_kg_pypc      'Potential net food supply  (kg/year-capita)'
      current_g_pdpc         'Current daily intake       (grams/day-capita)'
      potential_g_pdpc       'Potential daily intake     (grams/day-capita)'
      change                 'Change in diet             (grams/day-capita)'
      roc                    'Rate of change (%)'
      carcass_g_pdpc         'Carcass daily intake       (grams/day-capita)'/
    nrep /
      current_kcal_pdpc      'Current nutrient intake    (kcal grams/day-capita)'
      potential_kcal_pdpc    'Potential nutrient intake  (kcal grams/day-capita)'
      change                 'Change in nutrition'
      roc                    'Rate of change (%)'
      carcass_kcal_pdpc      'Carcass nutrient intake    (kcal grams/day-capita)'/;

Parameter
    lsu(l)          'Livestock unit coefficient'
      /dairycow 1, dairyox 1, heifer 0.8, calves 0.4, swine 0.5, broiler 0.007, layinghens 0.014/   
    zxlive(z,l)     'Head of animal l'
    zyfeed(z,l,j)   'Distribution of feed j to animal l'
    zfeedrep        'Feed distribution report'
    zpoprep         'Animal population report'
    zliverep        'Animal product report'
    zdietrep        'Diet report';
    
solve sol_cp_low using lp minimizing target;
    zxlive("low",l) = xlive.l(l);
    zyfeed("low",l,j) = yfeed.l(l,j);
    
solve sol_cp_mid using lp minimizing target;
    zxlive("mid",l) = xlive.l(l);
    zyfeed("mid",l,j) = yfeed.l(l,j);

solve sol_cp_high using lp minimizing target;
    zxlive("high",l) = xlive.l(l);
    zyfeed("high",l,j) = yfeed.l(l,j);
    
solve sol_stock using lp minimizing target;
    zxlive("fstock",l) = xlive.l(l);
    zyfeed("fstock",l,j) = yfeed.l(l,j);

    zfeedrep(z,l,"tdp_dist",j) $ nonzero(l)  = zyfeed(z,l,j)*(fsupply(l,"tdn",j)/100)*1000 /zxlive(z,l) $ nonzero(l);
    zfeedrep(z,l,"cp_dist",j) $ nonzero(l)   = zyfeed(z,l,j)*(fsupply(l,"cp",j)/100) *1000 /zxlive(z,l) $ nonzero(l);
    zfeedrep(z,l,"tdp_dist","total")   = sum(j, zfeedrep(z,l,"tdp_dist",j));
    zfeedrep(z,l,"cp_dist","total")    = sum(j, zfeedrep(z,l,"cp_dist",j));
    
    zpoprep(z,l,"current_head")        = head(l);
    zpoprep(z,"total","current_head")  = sum(l, head(l)*lsu(l));
    zpoprep(z,l,"potential_head")      = zxlive(z,l);
    zpoprep(z,"total","potential_head")= sum(l, zxlive(z,l)*lsu(l));
    zpoprep(z,l,"change")              = zpoprep(z,l,"potential_head") - zpoprep(z,l,"current_head");
    zpoprep(z,"total","change")        = zpoprep(z,"total","potential_head") - zpoprep(z,"total","current_head");
    zpoprep(z,l,"roc")                 = 100 * zpoprep(z,l,"change") / zpoprep(z,l,"current_head");
    zpoprep(z,"total","roc")           = 100 * zpoprep(z,"total","change")  / zpoprep(z,"total","current_head");
    zpoprep(z,l,"carcass")               $(zpoprep(z,l,"change")<0)
                                       = (-1)* zpoprep(z,l,"change");

    zliverep(z,i,"current_kg_pypc")    = nvalue(i,"pc","supplypy");
    zliverep(z,i,"potential_kg_pypc")  = sum(l,zxlive(z,l)*yield(i,l)*(data(i,"g2n")/100)) / (tpop*(10**6));  
    zliverep(z,i,"current_g_pdpc")     = nnpc(i);
    zliverep(z,i,"potential_g_pdpc")   = sum(l,zxlive(z,l)*yield(i,l))*1000 / (tpop*(10**6)*365);
    yield("beef","dairycow")           = yield("beef","dairycow")/spent;
    yield("chicken","layinghens")      = yield("chicken","layinghens")/culled;
    zliverep(z,i,"carcass_g_pdpc")       $ carcass(i)
                                       = sum(l,zpoprep(z,l,"carcass")*yield(i,l) $ carcass(i))*1000 / (tpop*(10**6)*365);
    zliverep(z,"total",frep)           = sum(i, zliverep(z,i,frep));
    zliverep(z,i,"change")             = zliverep(z,i,"potential_g_pdpc") - zliverep(z,i,"current_g_pdpc");
    zliverep(z,"total","change")       = zliverep(z,"total","potential_g_pdpc") - zliverep(z,"total","current_g_pdpc");
    zliverep(z,i,"roc")                = 100 * zliverep(z,i,"change") / zliverep(z,i,"current_g_pdpc");
    zliverep(z,"total","roc")          = 100 * zliverep(z,"total","change") / zliverep(z,"total","current_g_pdpc");

    zdietrep(z,nn,"current_kcal_pdpc")   = sum(i, nnpc(i)*nnvalue(i,nn)/100);
    zdietrep(z,nn,"potential_kcal_pdpc") = sum((i,l),zxlive(z,l)*x2nn(l,i,nn)/100)/(tpop*(10**6)*365);
    x2nn(l,i,nn)                         = yield(i,l)*(data(i,"g2n")/100)*1000*nnvalue(i,nn);
    zdietrep(z,nn,"carcass_kcal_pdpc")   = sum((i,l),zpoprep(z,l,"carcass")*x2nn(l,i,nn) $ carcass(i) /100)/(tpop*(10**6)*365);
    zdietrep(z,nn,"change")              = zdietrep(z,nn,"potential_kcal_pdpc") - zdietrep(z,nn,"current_kcal_pdpc");
    zdietrep(z,nn,"roc")                 = 100 * zdietrep(z,nn,"change") / zdietrep(z,nn,"current_kcal_pdpc");


$sTitle Export Report
Execute_Unload '%gdx_results%',zyfeed,zfeedrep,zpoprep,zliverep,zdietrep;

execute 'gdxxrw %gdx_results% o=%excel_results% par=zyfeed   rng=zyfeed!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=zfeedrep rng=zfeedrep!A1 rdim=2 cdim=2'
execute 'gdxxrw %gdx_results% o=%excel_results% par=zpoprep  rng=zpoprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=zliverep rng=zliverep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=zdietrep rng=zdietrep!A1 rdim=2 cdim=1'
