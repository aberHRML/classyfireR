# classyfireR

> __R Interface to the [ClassyFire REST API](http://classyfire.wishartlab.com)__


### Installation & Usage

```R
devtools::install_github('wilsontom/classyfireR')

library(classyfireR)
```

> __For retrival of classifications already available; a InChI Key is supplied to the  `entity_classification` function.__

```
> inchi_keys <- c('BRMWTNUJHUMWMS-LURJTMIESA-N', 'MDHYEMXUFSJLGV-UHFFFAOYSA-N')

> entity_classification(inchi_keys[1])

✔ classification retrieved
$ClassyFire
# A tibble: 4 x 3
  Level      Classification                       CHEMONT          
  <chr>      <chr>                                <chr>            
1 kingdom    Organic compounds                    CHEMONTID:0000000
2 superclass Organic acids and derivatives        CHEMONTID:0000264
3 class      Carboxylic acids and derivatives     CHEMONTID:0000265
4 subclass   Amino acids, peptides, and analogues CHEMONTID:0000013

$Meta
# A tibble: 1 x 3
  Query                                Version Date      
  <chr>                                <chr>   <date>    
1 InChIKey=BRMWTNUJHUMWMS-LURJTMIESA-N 2.1     2018-03-26

```
