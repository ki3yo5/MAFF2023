$title  Food Supply Simulation in Japan applying the SWISSfoodSys Model

$onText
Build 2.3 Feb 16 2025
Simultaneous simulation for croping and animal production models with 16 crops, 6 processing foods,
13 feeds, 7 livestocks, 5 animal products and 2 marine products.
The objective function consists of calorie deficit and food intake balance of 8 food groups.
The contstraints on cropping are arable land endowments by total acreage and month, and expansion margin for each crop.
The contstraints on livestock production are total feed supply and TDN and CP balance.
Besides baseline scenario (no food and feed import), optional import decline scenario is avialable.
MAFF Open Lab.(2024) Food Supply Simulation in Japan applying the SWISSfoodSys Model. 
$offText

* set build version name:
$if not setglobal build   $setglobal build 2.3
* set import decline scenario:
$if not setglobal idc_scn $setglobal idc_scn 4

* evaluate calorie deficit and nutrient intake as rate (not as difference):
$if not setglobal rate    $setglobal rate 1
* generate land usage report:
$if not setglobal landrep $setglobal landrep 1

* set scenario by upper limit for cropping area expansion:
$if not setglobal scn_exp $setglobal scn_exp 0
* set first-year cropping scenario:
$if not setglobal scn_fyr $setglobal scn_fyr 0
* set grain stockpile release scenario:
$if not setglobal scn_gsp $setglobal scn_gsp 0
* set feed stockpile release scenario:
$if not setglobal scn_fsp $setglobal scn_fsp 0

$if not setglobal gdx_results   $setglobal gdx_results   .\results\%build%_%idc_scn%_results.gdx
$if not setglobal excel_results $setglobal excel_results .\results\%build%_%idc_scn%_results.xlsx



$sTitle Sets
* item classification
Set
    c crops   /
    rice
    wheat
    pwheat         'cropped in paddy'
    barley
    pbarley        'cropped in paddy'
    naked
    corn           'feed use, cropped in pasture'
    sorghum        'feed use, cropped in pasture'
    mis_grains   
    sweetp       
    potato
    soy
    psoy           'cropped in paddy'
    mis_beans    
    green_veges  
    mis_veges    
    mandarin     
    apple
    mis_fruits   
    scane        
    sbeat        
    rapeseed
    fish
    seaweed
    starch         'made of corn, potato, sweetp'
    sugar          'made of scane,sbeat '
    oil            'made of rapeseed'
    miso           'made of soy'
    soysource      'made of soy'
    mis_foods    /
    ap animal products /
    beef
    pork
    chicken
    egg
    milk               /
    g  item of goods   /set.c, set.ap/
    fe feeds   /
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
    meatbonemeal   'constant'
    fishmeal       'constant'
    corn           'import only'
    sorghum        'import only'
    wheat          'no import stock only'
    barley         'no import stock only'
    rice           'no import stock only'/
    ls livestocks /
    dairycow       '> 2 years'
    dairyox        '> 2 years'
    heifer         '1 - 2 years'
    calves         '< 12 months'
    swine
    broiler
    layinghens    /
    
* crop classification 
    paddy(c)
    /rice,pwheat,pbarley,psoy/
    field(c)
    /wheat,barley,naked,mis_grains,sweetp,potato,soy,mis_beans,green_veges,mis_veges,scane,sbeat,rapeseed/
    pasture(c)
    /corn,sorghum/
    orchard(c)
    /mandarin,apple,mis_fruits/
    local(c)
    /scane,sbeat/
   
* food groups
    edible(c)
    /rice,wheat,pwheat,barley,pbarley,naked,mis_grains,sweetp,potato,soy,psoy,mis_beans,green_veges,mis_veges,mandarin,apple,mis_fruits/  
    marine(c)
    /fish,seaweed/
    processed(c)
    /starch,sugar,oil,miso,soysource,mis_foods/   
    import(g)
    /rice,wheat,barley,naked,mis_grains,sweetp,potato,soy,mis_beans,green_veges,mis_veges,
    apple,mis_fruits,rapeseed,starch,fish,seaweed,sugar,oil,soysource,mis_foods,
    beef,pork,chicken,egg,milk/
    cg crop groups /
    grain         'grains'
    tuber         'tuber'
    pulse         'pulse and legume'
    veget         'vegetables'
    fruit         'fruits'
    starch        'processed starch'
    sugar         'processed sugar'
    other         'other processed foods'/
    ag animal product groups /
    meat          'meats'
    egg_dairy     'egg and dairy'/

* model arguments
    t cropping month
    /jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec/
    n nutrient values   /
    calorie       'kcal'
    protein       'grams'
    fat           'grams'
    carbonhydrate 'grams'
    pop           'population (million)'
    supplypy      'supply per year (kg)'
    supplypd      'supply per day (grams)'/
    nn  nutrition /
    calorie
    protein
    fat
    carbonhydrate /
    nf feed nutrients /
    tdn           'total digestable nutrients (MT per head)'
    cp            'crude protain              (% of tdn)'
    cp_low
    cp_mid
    cp_high       /
    a age
    /0-1,1-2,3-5,6-7,8-9,10-11,12-14,15-17,18-29,30-49,50-64,65-74,75-/
    p production  /
    area         '1000ha'
    yield        'MT per ha (crops)'
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
    q feed quantity
    /stock,import,presupply,const/
    s sex
    /male,female/
    v value       /
    pc           'percapita per day'
    value        'nutrients in net food 100g'/

* scenario
    u  upper limit for area expansion   /u2, u3, u4, u5/
    w  weight on calorie balance        /w100, w75, w50, w25/
    z  animal production scenario       /low, mid, high, fstock/;

* i for ingredient crops in food processing 
alias (c,i);

* m for month by commencement of shock
alias (t,m);

set
   mmap(m,c)   Monthly cropping calendar mapping  /
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
   cmap(cg,c)   Crop groups to crop mapping  /
   grain.(rice,wheat,pwheat,barley,pbarley,naked,mis_grains)
   tuber.(sweetp,potato)
   pulse.(soy,psoy,mis_beans)
   veget.(green_veges,mis_veges)
   fruit.(mandarin,apple,mis_fruits)
   starch.(starch)
   sugar.(sugar)
   other.(oil,miso,soysource,mis_foods)      /
   amap(ag,ap)  ap groups to animal products mapping  /
   meat.(beef,pork,chicken)
   egg_dairy.(egg,milk)                    /;



$sTitle Parameters
parameter
   k(cg)  Number of crops in cg group /
   grain      4 
   tuber      2 
   pulse      2 
   veget      2 
   fruit      3 
   starch     1 
   sugar      1 
   other      3 /
   j(ag)  Number of animal products in ap group /
   meat       3
   egg_dairy  2 /
   sp(c)  Government grain stockpile (1000t) /
   rice    2500 
   wheat   900  / ;

parameter
    data(*,p)         'Production data'
    landreq(c,t)      'Months of land occupation by crop (hectares)'
    fdemand(ls,nf)    'Feed nutrient demand   (TDN:kilograms per head, CP:%)'
    fsupply(ls,nf,fe) 'Feed nutrient supply   (%)'
    fconst(fe,q)      'Feed constraints       (t)'
    intake(a,s,n)     'Required daily intake of nutrients'
    nvalue(*,v,n)     'Nutritive supply and value of foods';
    
$gdxin prod_alt.gdx
$load data
$gdxin
$gdxin landreq.gdx
$load landreq
$gdxin
$gdxin fdemand.gdx
$load  fdemand
$gdxin
$gdxin fsupply.gdx
$load  fsupply
$gdxin
$gdxin fconst_imp.gdx
$load  fconst
$gdxin
$gdxin intake.gdx
$load intake
$gdxin
$gdxin nvalue.gdx
$load nvalue
$gdxin
$include .\data_idc_scn%idc_scn%.gms

parameter
    head(ls)   'Number of animals (head)'/
    dairycow     861700
    dairyox      237760
    heifer       62300
    calves       447200
    swine        8949000
    broiler      139230000
    layinghens   182661000 /
    lsu(ls)    'Livestock unit coefficient'/
    dairycow     1
    dairyox      1
    heifer       0.8
    calves       0.4
    swine        0.5
    broiler      0.007
    layinghens   0.014  /
    fdm(fe)    'Feed DM coefficient (except fodder)'/
    fodder       1
    ricestraw    0.928
    wheatstraw   0.91
    potatovines  0.289
    ricebran     0.9
    wheatbran    0.87
    soybeancake  0.88
    rapeseedcake 0.89
    beetpulp     0.243
    molasses     0.754
    bagasse      0.46 /;

Scalar
    land       'total land size (1000ha)'         /  4325  /
    lpaddy     'paddy field (1000ha)'             /  2352  /
    lupland    'total upland field (1000ha)'      /  1973  /
    lfield     'cropping field (1000ha)'          /  1123  /
    lorchard   'orchard (1000ha)'                 /   259  /
    lpasture   'pasture (1000ha)'                 /   591  /

    spent      'rate of dairycow spent for beef production'
    culled     'rate of layinghens culled for chicken prodution'
    lactating  'rate of dairycow lactating for milk production'

    limit      'default upper limit for area expansion and feed production'
    weight     'default weight on calorie balance';

    spent     = (447200/2) / 861700;
    culled    = 83304000 / 182661000;
    lactating = 736500 / 861800;
    
    limit     = 3;
    weight    = 0.75;
   
Table
    pcoef(c,i)   'Output of processed food by 1 unit crop'
                   corn   sweetp   potato   soy   scane   sbeat   rapeseed
    starch         0.52    0.77     0.77     
    sugar                                          0.17    0.17             
    oil                                                             0.37
    miso                                    5.0
    soysource                               3.3                            ;
    
Table
    acoef(ap,ls) 'Output of animal product (kg) by 1 unit livestock'
                   dairycow  dairyox  heifer  calves  swine  broiler  layinghens
    beef           220.3     340.9
    pork                                              78.0
    chicken                                                  1.85     1.73
    egg                                                               18.9
    milk           4500                                                         ;
  
    acoef("beef","dairycow") = acoef("beef","dairycow")*spent;
    acoef("milk","dairycow") = acoef("milk","dairycow")*lactating;
    acoef("chicken","layinghens") = acoef("chicken","layinghens")*culled;

Table
    fcoef(fe,c) 'Forage and Feed yield (MT/ha)'
                   rice   wheat   pwheat   sweetp   potato   soy    psoy   scane   sbeat   rapeseed  
    ricestraw      5.15
    wheatstraw            5.15    5.15
    potatovines                            26.54    26.54
    ricebran       0.38
    wheatbran             0.96    0.96
    soybeancake                                              1.20   1.20
    rapeseedcake                                                                           1.20
    beetpulp                                                                       2.92
    molasses                                                                       2.17
    bagasse                                                                16.39                    ;

Parameter
    tpop                'National population       (million)'
    pintake(a,s,nn)     'Daily intake requirement  (kcal grams/million)'
    nreq(nn)            'Daily intake requirement  (kcal grams/capita)'
    nnvalue(*,nn)       'Nutritive value of foods  (kcal grams/netfood gram)'
    nnpcvalue(*,nn)     'Nutritive value of foods  (kcal grams/capita)'   
    nnpc(*)             'Current daily intake      (grams/capita)'
    
    t2g(*)              'Total food to gross food'
    t2p(*)              'Total food to processing use'
    t2f(*)              'Total food to feed use'
    g2n(*)              'Gross food to net food '
   
    x2n(c)              'Cropping area(1000ha) to net food (grams)'
    x2nn(c,nn)          'Cropping area(1000ha) to nutritive value (kcal grams)'
    x2f(c,i)            'Cropping area(1000ha) to processed food (grams) '
    x2fn(c,i,nn)        'Cropping area(1000ha) to nutritive value (kcal grams)'
    x2a(ap,ls)          'Livestock head to net food (grams)'
    x2an(ap,ls,nn)      'Livestock head to nutritional value (kcal grams)'
    x2fe(fe,c)          'Cropping area(1000ha) to DM base feed (MT)'
    
    im(*)               'Imported food (net food)     (grams)'
    impc(*)             '              (daily intake) (grams/capita)'
    imnn(nn)            '              (nutrients)    (kcal grams/capita)';

    tpop = sum((a,s), intake(a,s,"pop"));

    pintake(a,s,"calorie")       = intake(a,s,"pop") * intake(a,s,"calorie");
    pintake(a,s,"protein")       = intake(a,s,"pop") * intake(a,s,"protein");
    pintake(a,s,"fat")           = intake(a,s,"pop") * intake(a,s,"fat");
    pintake(a,s,"carbonhydrate") = intake(a,s,"pop") * intake(a,s,"carbonhydrate");

    nreq(nn) = sum((a,s),pintake(a,s,nn))/tpop;

    nnvalue(g,"calorie")         = nvalue(g,"value","calorie")/100;
    nnvalue(g,"protein")         = nvalue(g,"value","protein")/100;
    nnvalue(g,"fat")             = nvalue(g,"value","fat")/100;
    nnvalue(g,"carbonhydrate")   = nvalue(g,"value","carbonhydrate")/100;
    nnpcvalue(g,"calorie")       = nvalue(g,"pc","calorie");
    nnpcvalue(g,"protein")       = nvalue(g,"pc","protein");
    nnpcvalue(g,"fat")           = nvalue(g,"pc","fat");
    nnpcvalue(g,"carbonhydrate") = nvalue(g,"pc","carbonhydrate");    
    nnpc(g)                      = nvalue(g,"pc","supplypd");

    t2g(g)       = data(g,"gross")/data(g,"total");
    t2p(g)       = data(g,"processing")/data(g,"total");
    t2p("soy")   = 18/data("soy","prod");
    t2p("psoy")  = 18/data("psoy","prod");
    t2f(g)       = data(g,"feed")/data(g,"total");
    g2n(g)       = data(g,"g2n")/100;
    
    x2n(c)       = data(c,"yield")*t2g(c)*g2n(c)*(10**9);
    x2nn(c,nn)   = x2n(c)*nnvalue(c,nn);
    x2f(c,i)     = data(i,"yield")*t2p(i)*pcoef(c,i)*(10**9);
    x2fn(c,i,nn) = x2f(c,i)*nnvalue(c,nn);
    x2a(ap,ls)     = acoef(ap,ls)*g2n(ap)*1000;
    x2an(ap,ls,nn) = x2a(ap,ls)*nnvalue(ap,nn)*0.8;
    x2fe(fe,c)     = fcoef(fe,c)*fdm(fe)*(10**3);

    im(g) $import(g)   = (1-rdc_rate(g))*data(g,"import")*t2g(g)*g2n(g)*(10**9) $import(g);
    impc(g) $import(g) = im(g)/(tpop*(10**6)*365) $import(g);
    imnn(nn)           = sum(g, impc(g)*nnvalue(g,nn) $import(g));

Display tpop, pintake, nreq, nnvalue, nnpc, im, impc, imnn, x2fe;



$sTitle Variables
Variable
    xcrop(c)      'Cropping area (1000ha)'
    xlive(ls)     'head of animal ls'
    yfeed(ls,fe)  'distribution of feed j to animal ls (MT)'

    tdnd(ls)      'TDN demand by livestock (MT)'
    tdns(ls)      'TDN supply to livestock (MT)'
    cpd(ls)       'CP demand by livestock  (MT)'
    cps(ls)       'CP supply to livestock  (MT)'
    dms(fe)       'DM supply               (MT)'

    cdeficit      'Calorie deficit  (kcal)'
    crate         'Shortage rate'
    
    delta(cg)     'Net food balance by fgroup  (grams/capita)'
    deltamn(cg)   'Net food sufficiency rate by fgroup'
    deltamnsq(cg)
    
    adelta(ag)    'Net food balance by fgroup  (grams/capita)'
    adeltamn(ag)  'Net food sufficiency rate by fgroup'
    adeltamnsq(ag)
    
    target        'Weighted average of Calorie deficit and Net food balance';

Positive Variable xcrop, xlive, yfeed, cdeficit;



$sTitle Equations
Equation
    ybal          'Land balance on          paddy    (1000ha)'
    fbal                                    upland   (1000ha)'
    pbal                                    pasture  (1000ha)'
    obal                                    orchard  (1000ha)'
   
    aybal         'Cropping area balance on paddy    (1000ha)'
    afbal                                   upland   (1000ha)'
    apbal                                   pasture  (1000ha)'
    aobal                                   orchard  (1000ha)'
    albal                                   local    (1000ha)'
   
    jan           'Cropping area balance by month    (1000ha)'
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
    dec

    tdndemand     'TDN demand by animal ls'
    tdnsupply     'TDN supply for animal ls by feed fe'
    tdnbal        'TDN balance'    
    cpdemand      'CP demand by animal ls'
    cpdemand_low  'CP demand by animal ls (underestimate)'
    cpdemand_high 'CP demand by animal ls (overestimate)'
    cpsupply      'CP supply for animal ls'
    cpbal         'CP balance'
    dmsupply      'Feed supply (constant + import + crop byproducts) (dry matter MT)'
    distbal       'Feed distribution balance'
    distbal_stock 'Feed distribution balance with feed grain stockpile'

    bredbal       'Livestock breeding balance'
    dairyoxrep    'Reproduction rate of dairy ox per mother dairycow'
    heiferrep     'Reproduction rate of heifer per mother dairycow'
    calfrep       'Reproduction rate of calves per mother dairycow'
   
    cbal          'Calorie balance (kca/capita)'
    croc          'Calorie shortage rate'
    dbal          'Net food balance by fgroup (grams/capita)'
    droc          'Net food shortage rate by fgroup'
    drocsq
    adbal         'Net food balance by fgroup (grams/capita)'
    adroc         'Net food shortage rate by fgroup'
    adrocsq
    
    dif           'Objective function evaluated as difference value'
    rat           'Objective function evaluated as rate of shortage';

    ybal(t)..    sum(c, xcrop(c)*landreq(c,t) $ paddy(c))   =l= lpaddy;
    fbal(t)..    sum(c, xcrop(c)*landreq(c,t) $ field(c))   =l= lfield;
    pbal(t)..    sum(c, xcrop(c)*landreq(c,t) $ pasture(c)) =l= lpasture;
    obal(t)..    sum(c, xcrop(c)*landreq(c,t) $ orchard(c)) =l= lorchard;

    aybal(c)..   xcrop(c) $ paddy(c)   =l= limit    *data(c,"area") $ paddy(c);
    afbal(c)..   xcrop(c) $ field(c)   =l= limit    *data(c,"area") $ field(c);
    apbal(c)..   xcrop(c) $ pasture(c) =l= 1        *data(c,"area") $ pasture(c);
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

    tdndemand(ls)..       tdnd(ls) =e= xlive(ls)*fdemand(ls,"tdn")/1000;
    tdnsupply(ls)..       tdns(ls) =e= sum(fe, yfeed(ls,fe)*fsupply(ls,"tdn",fe)/100);
    tdnbal(ls)..          tdnd(ls) =l= tdns(ls);    
    cpdemand(ls)..        cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_mid")/100;
    cpdemand_low(ls)..    cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_low")/100;
    cpdemand_high(ls)..   cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_high")/100;
    cpsupply(ls)..        cps(ls)  =e= sum(fe, yfeed(ls,fe)*fsupply(ls,"cp",fe)/100);
    cpbal(ls)..           cpd(ls)  =l= cps(ls);
    dmsupply(fe)..        dms(fe)  =e= fconst(fe,"const")+(1-rec_rate_fe(fe))*fconst(fe,"import")+sum(c, xcrop(c)*x2fe(fe,c));
    distbal(fe)..         dms(fe)  =g= sum(ls, yfeed(ls,fe));
    distbal_stock(fe)..   dms(fe)  =g= sum(ls, yfeed(ls,fe))-fconst(fe,"stock");

    bredbal(ls)..                          xlive(ls) =l= limit*head(ls);    
    dairyoxrep..   head("dairyox")*xlive("dairycow") =l= xlive("dairyox")*head("dairycow");
    heiferrep..    head("heifer") *xlive("dairycow") =l= xlive("heifer") *head("dairycow");
    calfrep..      head("calves") *xlive("dairycow") =l= xlive("calves") *head("dairycow");
                                                                           
    cbal..         cdeficit       =e= nreq("calorie")
                                       -(sum(c,xcrop(c)*x2nn(c,"calorie"))
                                        +sum((i,c),xcrop(i)*x2fn(c,i,"calorie"))
                                        +sum((ap,ls),xlive(ls)*x2an(ap,ls,"calorie"))) /(tpop*(10**6)*365);
    croc..         crate          =e= cdeficit/nreq("calorie");                                   
    
    dbal(cg)..     delta(cg)      =e= sum(c $cmap(cg,c), nnpc(c)-impc(c)
                                                         - (xcrop(c)*x2n(c)+sum(i,xcrop(i)*x2f(c,i))) /(tpop*(10**6)*365));

    droc(cg)..     deltamn(cg)    =e= (delta(cg)/sum(c $cmap(cg,c), nnpc(c))) / k(cg);
    drocsq(cg)..   deltamnsq(cg)  =e= sqr(deltamn(cg));
    
    adbal(ag)..    adelta(ag)     =e= sum(ap $amap(ag,ap), nnpc(ap)-impc(ag)
                                                           - sum(ls,xlive(ls)*x2a(ap,ls)) /(tpop*(10**6)*365));

    adroc(ag)..    adeltamn(ag)   =e= (adelta(ag)/sum(ap $amap(ag,ap), nnpc(ap))) / j(ag);
    adrocsq(ag)..  adeltamnsq(ag) =e= sqr(adeltamn(ag));

    dif..          target         =e= weight*cdeficit + (1-weight)*(sum(cg,delta(cg))   +sum(ag,adelta(ag)));
    rat..          target         =e= weight*crate    + (1-weight)*(sum(cg,deltamnsq(cg)) +sum(ag,adeltamnsq(ag)));



$sTitle Model definition and solve
    Model crop_constraint   / ybal,fbal,pbal,obal,aybal,afbal,apbal,aobal,albal /;
    Model animal_constraint / tdndemand,tdnsupply,tdnbal,cpdemand,cpsupply,cpbal,dmsupply,distbal,bredbal,dairyoxrep,heiferrep,calfrep /;
    Model balance           / cbal,croc, dbal,droc,drocsq, adbal,adroc,adrocsq /;

* Standard solution
    Model sol_dif     / crop_constraint + animal_constraint + balance + dif /;
    Model sol_rat     / crop_constraint + animal_constraint + balance + rat /;

* First-year scenario
    Model sol_dif_jan / sol_dif+jan /;
    Model sol_dif_feb / sol_dif+feb /;
    Model sol_dif_mar / sol_dif+mar /;
    Model sol_dif_apr / sol_dif+apr /;
    Model sol_dif_may / sol_dif+may /;
    Model sol_dif_jun / sol_dif+jun /;
    Model sol_dif_jul / sol_dif+jul /;
    Model sol_dif_aug / sol_dif+aug /;
    Model sol_dif_sep / sol_dif+sep /;
    Model sol_dif_oct / sol_dif+oct /;
    Model sol_dif_nov / sol_dif+nov /;
    Model sol_dif_dec / sol_dif+dec /;
    Model sol_rat_jan / sol_rat+jan /;
    Model sol_rat_feb / sol_rat+feb /;
    Model sol_rat_mar / sol_rat+mar /;
    Model sol_rat_apr / sol_rat+apr /;
    Model sol_rat_may / sol_rat+may /;
    Model sol_rat_jun / sol_rat+jun /;
    Model sol_rat_jul / sol_rat+jul /;
    Model sol_rat_aug / sol_rat+aug /;
    Model sol_rat_sep / sol_rat+sep /;
    Model sol_rat_oct / sol_rat+oct /;
    Model sol_rat_nov / sol_rat+nov /;
    Model sol_rat_dec / sol_rat+dec /;



$sTitle Display Solutions
Set
    frep  Net food report /
    netfood     'Net food supply      (grams)'
    current     'Current intake       (grams/day-capita)'
    potential   'Potential intake     (grams/day-capita)'
    import      'Import               (grams/day-capita)'
    change      'Change in diet       (grams/day-capita)'
    ros         'Self sufficiency     (%)'/
    nrep  Nutiritional report /
    required    'Required nutrients   (kcal grams/day-capita)'
    current     'Current intake       (kcal grams/day-capita)'
    potential   'Potential intake     (kcal grams/day-capita)'
    import      'Import               (kcal grams/day-capita)'
    shortage    'Shortage             (kcal grams/day-capita)'
    ros         'Self sufficiency     (%)'/
    rep   Calorie balance on First-year scenario /
    mean
    max
    min   /
    nonzero(ls)  non-zero constraint on zfeedrep /dairycow,dairyox,heifer,calves,layinghens/
    erep /
    tdp_dist    'Potential TDP distribution (kg/year-head)'
    cp_dist     'Potential CP distribution  (kg/year-head)'/
    prep /
    current     'Current animal population  (head)'
    potential   'Potential animal population(head)'
    change      'Change in population       (head)'
    roc         'Rate of change             (%)'
    carcass     'Carcass by early slaughter'/;

Parameter
    wxcrop(w,*)  'Cropping area by weight   (1000ha)'
    wxlive(w,*)  'Livestock head by weight  (head)'
    lxcrop(u,*)  'Cropping area by limit    (1000ha)'
    mxcrop(m,*)  'Cropping area by month    (1000ha)'
    zyfeed(z,*,*)'Distribution of feed j to animal l'
   
    paddyrep     'Land report summary on paddy'
    fieldrep     'Land report summary on field'
    pasturerep   'Land report summary on pasture'
    orchardrep   'Land report summary on orchard'
    landrep      'Land allocation summary'
   
    wcroprep     'Crop report summary'
    wfoodrep     'Processed food summary'
    wliverep     'Animal product summary'
    wdietrep     'Nutrient summary'
   
    lcroprep     'Crop report summary'
    lfoodrep     'Processed food summary'
    ldietrep     'Nutrient summary'
   
    mcroprep     'Crop report summary'
    mfoodrep     'Processed food summary'
    mdietrep     'Nutrient summary'

    zfeedrep     'Feed distribution report'
    zpoprep      'Animal population report'
   
    radar        'Radar chart summary'
    aradar
    stock        'Grain stockpile reserved'
    xcbal        'Calorie balance on First-year scenario  (kcal/day-capita)'
    period       'Estimated maximum duration of stockpile release    (days)';

* test run
* do not erase
limit = 3;
weight = 0.75;
    solve sol_dif minimizing target using nlp ;

Display xcrop.l, xlive.l, yfeed.l, dms.l;



$sTitle Scenario by weight (weight = 100, 75, 50, 25)
limit = 3;

if(%rate%,
   weight = 1;
   solve sol_rat minimizing target using nlp ;
   display xcrop.l, xlive.l, yfeed.l, dms.l ;
   wxcrop("w100",c) = xcrop.l(c);
   wxlive("w100",ls)= xlive.l(ls);
   weight = 0.75;
   solve sol_rat minimizing target using nlp ;
   display xcrop.l, xlive.l, yfeed.l, dms.l ;
   wxcrop("w75",c) = xcrop.l(c);
   wxlive("w75",ls)= xlive.l(ls);
   weight = 0.50;
   solve sol_rat minimizing target using nlp ;
   display xcrop.l, xlive.l, yfeed.l, dms.l ;
   wxcrop("w50",c) = xcrop.l(c);
   wxlive("w50",ls)= xlive.l(ls);
   weight = 0.25;
   solve sol_rat minimizing target using nlp ;
   display xcrop.l, xlive.l, yfeed.l, dms.l ;
   wxcrop("w25",c) = xcrop.l(c);
   wxlive("w25",ls)= xlive.l(ls);
else
   weight = 1;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w100",c) = xcrop.l(c);
   wxlive("w100",ls)= xlive.l(ls);
   weight = 0.75;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w75",c) = xcrop.l(c);
   wxlive("w75",ls)= xlive.l(ls);
   weight = 0.50;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w50",c) = xcrop.l(c);
   wxlive("w50",ls)= xlive.l(ls);
   weight = 0.25;
   solve sol_dif minimizing target using nlp ;
   wxcrop("w25",c) = xcrop.l(c);
   wxlive("w25",ls)= xlive.l(ls);
);

    wcroprep(w,c,"netfood")   = wxcrop(w,c)*x2n(c) $edible(c);
    wcroprep(w,c,"current")   = nnpc(c)$edible(c);
    wcroprep(w,c,"potential") = wcroprep(w,c,"netfood")/(tpop*(10**6)*365);
    wcroprep(w,c,"import")    = impc(c)$edible(c);
    wcroprep(w,c,"change")    = wcroprep(w,c,"potential")+wcroprep(w,c,"import")-wcroprep(w,c,"current");
    wcroprep(w,"total",frep)  = sum(c, wcroprep(w,c,frep));

    wfoodrep(w,c,"netfood")   = sum(i,wxcrop(w,i)*x2f(c,i) $processed(c));
    wfoodrep(w,c,"current")   = nnpc(c)$processed(c);
    wfoodrep(w,c,"potential") = wfoodrep(w,c,"netfood")/(tpop*(10**6)*365);
    wfoodrep(w,c,"import")    = impc(c)$processed(c);
    wfoodrep(w,c,"change")    = wfoodrep(w,c,"potential")+wfoodrep(w,c,"import")-wfoodrep(w,c,"current");
    wfoodrep(w,"total",frep)  = sum(c, wfoodrep(w,c,frep));

    wliverep(w,ap,"netfood")  = sum(ls,wxlive(w,ls)*x2a(ap,ls));
    wliverep(w,ap,"current")  = nnpc(ap);
    wliverep(w,ap,"potential")= wliverep(w,ap,"netfood")/(tpop*(10**6)*365);
    wliverep(w,ap,"import")   = impc(ap);
    wliverep(w,ap,"change")   = wliverep(w,ap,"potential")+wliverep(w,ap,"import")-wliverep(w,ap,"current");
    wliverep(w,"total",frep)  = sum(ap, wliverep(w,ap,frep));

    wdietrep(w,nn,"required") = nreq(nn);
    wdietrep(w,nn,"current")  = sum(g, nnpcvalue(g,nn));
    wdietrep(w,nn,"potential")= ( sum(c,      wxcrop(w,c) *x2nn(c,nn))
                                + sum((c,i),  wxcrop(w,i) *x2fn(c,i,nn))
                                + sum((ap,ls),wxlive(w,ls)*x2an(ap,ls,nn))
                                + sum(c,data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))) /(tpop*(10**6)*365);
    wdietrep(w,nn,"import")   = imnn(nn);                            
    wdietrep(w,nn,"shortage") = wdietrep(w,nn,"potential")+wdietrep(w,nn,"import")-wdietrep(w,nn,"required");
    wdietrep(w,nn,"ros")      = 100*(wdietrep(w,nn,"potential")+wdietrep(w,nn,"import"))/wdietrep(w,nn,"required");

    radar(w,cg,"netfood")     = sum(c $cmap(cg,c), wcroprep(w,c,"netfood"))
                                + sum(c $cmap(cg,c), wfoodrep(w,c,"netfood"));
    radar(w,cg,"current")     = sum(c $cmap(cg,c), nnpc(c));
    radar(w,cg,"potential")   = radar(w,cg,"netfood")/(tpop*(10**6)*365);
    radar(w,cg,"import")      = sum(c $cmap(cg,c), impc(c));
    radar(w,cg,"change")      = radar(w,cg,"potential") + radar(w,cg,"import") - radar(w,cg,"current");
    radar(w,cg,"ros")         = 100* (radar(w,cg,"potential")+radar(w,cg,"import")) / radar(w,cg,"current");

    aradar(w,ag,"netfood")    = sum(ap $amap(ag,ap), wliverep(w,ap,"netfood"));
    aradar(w,ag,"current")    = sum(ap $amap(ag,ap), nnpc(ap));
    aradar(w,ag,"potential")  = aradar(w,ag,"netfood")/(tpop*(10**6)*365);
    aradar(w,ag,"import")     = sum(ap $amap(ag,ap), impc(ap));
    aradar(w,ag,"change")     = aradar(w,ag,"potential") + aradar(w,ag,"import") - aradar(w,ag,"current");
    aradar(w,ag,"ros")        = 100* (aradar(w,ag,"potential")+aradar(w,ag,"import")) / aradar(w,ag,"current");



$sTitle Land use report by land classification
* set limit = 3, weight = 0.75

    paddyrep(t,c) = wxcrop("w75",c)*landreq(c,t) $ paddy(c);
    paddyrep(t,"total") = sum(c,paddyrep(t,c));
    fieldrep(t,c) = wxcrop("w75",c)*landreq(c,t) $ field(c);
    fieldrep(t,"total") = sum(c,fieldrep(t,c));
    pasturerep(t,c) = wxcrop("w75",c)*landreq(c,t) $ pasture(c);
    pasturerep(t,"total") = sum(c,pasturerep(t,c));
    orchardrep(t,c) = wxcrop("w75",c)*landreq(c,t) $ orchard(c);
    orchardrep(t,"total") = sum(c,orchardrep(t,c));
    
    landrep(w,"paddy",c) = wxcrop(w,c)  $ paddy(c);
    landrep(w,"paddy","total") = lpaddy;
    landrep("current","paddy",c) = data(c,"area") $ paddy(c);
    landrep("current","paddy","total") = lpaddy;
    
    landrep(w,"field",c) = wxcrop(w,c)  $ field(c);
    landrep(w,"field","total") = lfield;
    landrep("current","field",c) = data(c,"area") $ field(c);
    landrep("current","field","total") = lfield;

    landrep(w,"orchard",c) = wxcrop(w,c)  $ orchard(c);
    landrep(w,"orchard","total") = lorchard;
    landrep("current","orchard",c) = data(c,"area") $ orchard(c);
    landrep("current","orchard","total") = lorchard;
    


$sTitle Scenario by expansion margin (limit = 2, 3, 4, 5)
weight = 0.75;

if(%scn_exp%,
if(%rate%,
   limit = 2;
   solve sol_rat minimizing target using nlp ;
   lxcrop("u2",c) = xcrop.l(c);
   limit = 3;
   solve sol_rat minimizing target using nlp ;
   lxcrop("u3",c) = xcrop.l(c);
   limit = 4;
   solve sol_rat minimizing target using nlp ;
   lxcrop("u4",c) = xcrop.l(c);
   limit = 5;
   solve sol_rat minimizing target using nlp ;
   lxcrop("u5",c) = xcrop.l(c);
else
   limit = 2;
   solve sol_dif minimizing target using nlp ;
   lxcrop("u2",c) = xcrop.l(c);
   limit = 3;
   solve sol_dif minimizing target using nlp ;
   lxcrop("u3",c) = xcrop.l(c);
   limit = 4;
   solve sol_dif minimizing target using nlp ;
   lxcrop("u4",c) = xcrop.l(c);
   limit = 5;
   solve sol_dif minimizing target using nlp ;
   lxcrop("u5",c) = xcrop.l(c);
);
else
);

    lcroprep(u,c,"supply")    = lxcrop(u,c)*data(c,"yield") $edible(c);
    lcroprep(u,c,"grossfood") = lxcrop(u,c)*data(c,"yield")*t2g(c) $edible(c);
    lcroprep(u,c,"netfood")   = lxcrop(u,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
    lcroprep(u,c,"current")   = nnpc(c)$edible(c);
    lcroprep(u,c,"potential") = lcroprep(u,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    lcroprep(u,c,"change")    = lcroprep(u,c,"potential")-lcroprep(u,c,"current");
    lcroprep(u,"total",frep)  = sum(c, lcroprep(u,c,frep));

    lfoodrep(u,c,"netfood")   = sum(i,lxcrop(u,i)*data(i,"yield")*t2p(i)*pcoef(c,i) $processed(c));
    lfoodrep(u,c,"current")   = nnpc(c)$processed(c);
    lfoodrep(u,c,"potential") = lfoodrep(u,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    lfoodrep(u,c,"change")    = lfoodrep(u,c,"potential")-lfoodrep(u,c,"current");
    lfoodrep(u,"total",frep)  = sum(c, lfoodrep(u,c,frep));

    ldietrep(u,nn,"required") = nreq(nn);
    ldietrep(u,nn,"potential")   = sum(c,lcroprep(u,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                              + sum(c,lfoodrep(u,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                              + sum(c,data(c,"net")*nnvalue(c,nn)*(10**9)$marine(c)) /(tpop*(10**6)*365);
    ldietrep(u,nn,"shortage") = ldietrep(u,nn,"potential") - ldietrep(u,nn,"required");
    ldietrep(u,nn,"ros")   = 100*ldietrep(u,nn,"potential") / ldietrep(u,nn,"required");



$sTitle First-year scenario (some cropping area is fixed)
limit = 3;
weight = 0.75;

if(%scn_fyr%,
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
else );

    mcroprep(m,c,"supply")    = mxcrop(m,c)*data(c,"yield") $edible(c);
    mcroprep(m,c,"grossfood") = mxcrop(m,c)*data(c,"yield")*t2g(c) $edible(c);
    mcroprep(m,c,"netfood")   = mxcrop(m,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
    mcroprep(m,c,"current")   = nnpc(c)$edible(c);
    mcroprep(m,c,"potential") = mcroprep(m,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    mcroprep(m,c,"change")    = mcroprep(m,c,"potential")-mcroprep(m,c,"current");
    mcroprep(m,"total",frep)  = sum(c, mcroprep(m,c,frep));

    mfoodrep(m,c,"netfood")   = sum(i, mxcrop(m,i)*data(i,"yield")*t2p(i)*pcoef(c,i) $processed(c));
    mfoodrep(m,c,"current")   = nnpc(c)$processed(c);
    mfoodrep(m,c,"potential") = mfoodrep(m,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    mfoodrep(m,c,"change")    = mfoodrep(m,c,"potential")-mfoodrep(m,c,"current");
    mfoodrep(m,"total",frep)  = sum(c, mfoodrep(m,c,frep));

    mdietrep(m,nn,"required") = nreq(nn);
    mdietrep(m,nn,"potential")   = sum(c,mcroprep(m,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                          + sum(c,mfoodrep(m,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                          + sum(c,data(c,"net")*nnvalue(c,nn)*(10**9)$marine(c)) /(tpop*(10**6)*365);
    mdietrep(m,nn,"shortage") = mdietrep(m,nn,"potential") - mdietrep(m,nn,"required");
    mdietrep(m,nn,"ros")   = 100*mdietrep(m,nn,"potential") / mdietrep(m,nn,"required");



$sTitle Grain stockpile release scenario
    stock("grossfood",c)      = sp(c); 
    stock("netfood",c)        = sp(c)*g2n(c);
    stock("netfood","total")  = sum(c,stock("netfood",c));
    stock("netfoodpc",c)      = stock("netfood",c)*(10**9)/(tpop*(10**6)*365);
    stock("netfoodpc","total")= sum(c,stock("netfoodpc",c));
    stock("calorie",c)        = stock("netfood",c)*nnvalue(c,"calorie")*(10**9)/(tpop*(10**6)*365);
    stock("calorie","total")  = sum(c,stock("calorie",c));

    xcbal("mean")             = (-1)*sum(m,mdietrep(m,"calorie","shortage"))/12;
    xcbal("max")              = (-1)*smax(m,mdietrep(m,"calorie","shortage"));
    xcbal("min")              = (-1)*smin(m,mdietrep(m,"calorie","shortage"));

    period("100%",rep)        = 365*stock("calorie","total")/xcbal(rep);
    period("90%",rep)         = 365*stock("calorie","total")/(xcbal(rep)-2158*0.1);
    period("80%",rep)         = 365*stock("calorie","total")/(xcbal(rep)-2158*0.2);



$sTitle Feed stockpile release scenario



$sTitle Export Results
Execute_Unload '%gdx_results%',
wcroprep, wfoodrep, wliverep, wdietrep, radar, aradar, landrep,
lcroprep, lfoodrep, ldietrep, mcroprep, mfoodrep, mdietrep, stock, period;

execute 'gdxxrw %gdx_results% o=%excel_results% par=wcroprep rng=wcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wfoodrep rng=wfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wliverep rng=wliverep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wdietrep rng=wdietrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=radar rng=radar!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=aradar rng=radar!A35 rdim=2 cdim=1'

if(%landrep%,
execute 'gdxxrw %gdx_results% o=%excel_results% par=landrep rng=landrep!A1 rdim=1 cdim=2'
else
);

if(%scn_exp%,
execute 'gdxxrw %gdx_results% o=%excel_results% par=lcroprep rng=lcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=lfoodrep rng=lfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=ldietrep rng=ldietrep!A1 rdim=2 cdim=1'
else
);

if(%scn_fyr%,
execute 'gdxxrw %gdx_results% o=%excel_results% par=mcroprep rng=mcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=mfoodrep rng=mfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=mdietrep rng=mdietrep!A1 rdim=2 cdim=1'
else
);

if(%scn_gsp%,
execute 'gdxxrw %gdx_results% o=%excel_results% par=stock rng=stock!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=period rng=period!A1 rdim=1 cdim=1'
else
);