# classyfireR
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/wilsontom/classyfireR.svg?branch=master)](https://travis-ci.org/wilsontom/classyfireR) [![Build status](https://ci.appveyor.com/api/projects/status/ua94fiotdmc0ssq5/branch/master?svg=true)](https://ci.appveyor.com/project/wilsontom/classyfirer/branch/master) [![codecov](https://codecov.io/gh/wilsontom/classyfireR/branch/master/graph/badge.svg)](https://codecov.io/gh/wilsontom/classyfireR) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0") [![DOI](https://zenodo.org/badge/118162964.svg)](https://zenodo.org/badge/latestdoi/118162964)

[![CRAN](https://www.r-pkg.org/badges/version/classyfireR)](https://cran.r-project.org/web/packages/classyfireR/index.html) ![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/classyfireR?color=red)
> __R Interface to the [ClassyFire REST API](http://classyfire.wishartlab.com)__ 


### Installation & Usage
`classyfireR` can be installed from CRAN using;

```R
install.packages('classyfireR')
```

Or from GitHub using the `remotes` package

```R
remotes::install_github('wilsontom/classyfireR')
```

* [Get Classification](get-classification)
* [Acknowledgements](#acknowledgements)

### Get Classification

__For retrieval of classifications already available; a InChI Key is supplied to the  `get_classification` function.__

```R
library(classyfireR)

> inchi_keys <- c('BRMWTNUJHUMWMS-LURJTMIESA-N', 'MDHYEMXUFSJLGV-UHFFFAOYSA-N')

> get_classification(inchi_keys[1])

✔ classification retrieved
# A tibble: 7 x 3
  Level      Classification                       CHEMONT          
  <chr>      <chr>                                <chr>            
1 kingdom    Organic compounds                    CHEMONTID:0000000
2 superclass Organic acids and derivatives        CHEMONTID:0000264
3 class      Carboxylic acids and derivatives     CHEMONTID:0000265
4 subclass   Amino acids, peptides, and analogues CHEMONTID:0000013
5 level 5    Amino acids and derivatives          CHEMONTID:0000347
6 level 6    Alpha amino acids and derivatives    CHEMONTID:0000060
7 level 7    Histidine and derivatives            CHEMONTID:0004311
```

__Using the `tidyverse` a vector of InChI Keys can be submitted and easily extracted.__

```R
> library(tidyverse)

> keys <- c(
  'BRMWTNUJHUMWMS-LURJTMIESA-N',
  'XFNJVJPLKCPIBV-UHFFFAOYSA-N',
  'TYEYBOSBBBHJIV-UHFFFAOYSA-N',
  'AFENDNXGAFYKQO-UHFFFAOYSA-N',
  'WHEUWNKSCXYKBU-QPWUGHHJSA-N',
  'WHBMMWSBFZVSSR-GSVOUGTGSA-N'
)

> classification_list <- map(keys, get_classification)

> classification_tibble <-
  map2(classification_list, keys, ~ {
    add_column(.x, ID = rep(.y))
  }) %>% bind_rows()

# To create a table of just the superclass designation

> superclass <-
  classification_tibble %>% filter(Level == 'superclass') %>% select(-c(CHEMONT))

> superclass
# A tibble: 6 x 3
  Level      Classification                  ID                         
  <chr>      <chr>                           <chr>                      
1 superclass Organic acids and derivatives   BRMWTNUJHUMWMS-LURJTMIESA-N
2 superclass Organic nitrogen compounds      XFNJVJPLKCPIBV-UHFFFAOYSA-N
3 superclass Organic acids and derivatives   TYEYBOSBBBHJIV-UHFFFAOYSA-N
4 superclass Organic acids and derivatives   AFENDNXGAFYKQO-UHFFFAOYSA-N
5 superclass Lipids and lipid-like molecules WHEUWNKSCXYKBU-QPWUGHHJSA-N
6 superclass Organic acids and derivatives   WHBMMWSBFZVSSR-GSVOUGTGSA-N



# To create a data.frame of all classification results

classification_list <- map(classification_list, ~{select(.,-CHEMONT)})

spread_tibble <- purrr:::map(classification_list, ~{
  spread(., Level, Classification)  
}) %>% bind_rows() %>% data.frame()

rownames(spread_tibble) <- keys

classification_tibble <-  tibble(
  InChIKey = rownames(spread_tibble),
  Kingdom = spread_tibble$kingdom,
  SuperClass = spread_tibble$superclass,
  Class = spread_tibble$class,
  SubClass = spread_tibble$subclass,
  Level5 = spread_tibble$level.5,
  Level6 = spread_tibble$level.6,
  Level7 = spread_tibble$level.7
)


> classification_tibble
  InChIKey       Kingdom    SuperClass       Class        SubClass         Level5      Level6        Level7     
  <chr>          <chr>      <chr>            <chr>        <chr>            <chr>       <chr>         <chr>      
1 BRMWTNUJHUMWM… Organic c… Organic acids a… Carboxylic … Amino acids, pe… Amino acid… Alpha amino … Histidine …
2 XFNJVJPLKCPIB… Organic c… Organic nitroge… Organonitro… Amines           Primary am… Monoalkylami… NA         
3 TYEYBOSBBBHJI… Organic c… Organic acids a… Keto acids … Short-chain ket… NA          NA            NA         
4 AFENDNXGAFYKQ… Organic c… Organic acids a… Hydroxy aci… Alpha hydroxy a… NA          NA            NA         
5 WHEUWNKSCXYKB… Organic c… Lipids and lipi… Steroids an… Estrane steroids Estrogens … NA            NA         
6 WHBMMWSBFZVSS… Organic c… Organic acids a… Hydroxy aci… Beta hydroxy ac… NA          NA            NA    

```


### Acknowledgements

If you use `classyfireR` you should cite the [ClassyFire](https://jcheminf.springeropen.com/articles/10.1186/s13321-016-0174-y) publication

> ___Djoumbou Feunang Y, Eisner R, Knox C, Chepelev L, Hastings J, Owen G, Fahy E, Steinbeck C, Subramanian S, Bolton E, Greiner R, and Wishart DS___. ClassyFire: Automated Chemical Classification With A Comprehensive, Computable Taxonomy. Journal of Cheminformatics, 2016, 8:61.

> __DOI:__ [10.1186/s13321-016-0174-y](https://jcheminf.springeropen.com/articles/10.1186/s13321-016-0174-y)
