$title  Data export

parameter
  data(*,*)      Production data
  landreq(*,*)   Months of land occupation by crop (hectares)
  intake(*,*,*)  Required daily intake of nutrients
  nvalue(*,*,*)  Nutritive supply and value of foods;

$call gdxxrw prod.xlsx par=data rng=prod!a1:enh3582 Rdim=1 Cdim=1
$call gdxxrw landreq.xlsx par=landreq rng=landreq!a1:enh3582 Rdim=1 Cdim=1
$call gdxxrw intake.xlsx par=intake rng=intake!a1:enh3582 Rdim=1 Cdim=2
$call gdxxrw nvalue.xlsx par=nvalue rng=nvalue!a1:enh3582 Rdim=1 Cdim=2



