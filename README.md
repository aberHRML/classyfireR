# classyfireR
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/wilsontom/classyfireR.svg?branch=master)](https://travis-ci.org/wilsontom/classyfireR) [![Build status](https://ci.appveyor.com/api/projects/status/ua94fiotdmc0ssq5/branch/master?svg=true)](https://ci.appveyor.com/project/wilsontom/classyfirer/branch/master) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0")

> __R Interface to the [ClassyFire REST API](http://classyfire.wishartlab.com)__


### Installation & Usage

```R
devtools::install_github('wilsontom/classyfireR')

library(classyfireR)
```

> __For retrieval of classifications already available; a InChI Key is supplied to the  `entity_classification` function.__

```
> inchi_keys <- c('BRMWTNUJHUMWMS-LURJTMIESA-N', 'MDHYEMXUFSJLGV-UHFFFAOYSA-N')

> entity_classification(inchi_keys[1])

✔ classification retrieved
# A tibble: 4 x 3
  Level      Classification                       CHEMONT          
  <chr>      <chr>                                <chr>            
1 kingdom    Organic compounds                    CHEMONTID:0000000
2 superclass Organic acids and derivatives        CHEMONTID:0000264
3 class      Carboxylic acids and derivatives     CHEMONTID:0000265
4 subclass   Amino acids, peptides, and analogues CHEMONTID:0000013
```

Using the `tidyverse` a vector of InChI Keys can be submitted and easily extracted.

```
library(tidyverse)

> keys <- c(
  'BRMWTNUJHUMWMS-LURJTMIESA-N',
  'XFNJVJPLKCPIBV-UHFFFAOYSA-N',
  'TYEYBOSBBBHJIV-UHFFFAOYSA-N',
  'AFENDNXGAFYKQO-UHFFFAOYSA-N',
  'WHEUWNKSCXYKBU-QPWUGHHJSA-N',
  'WHBMMWSBFZVSSR-GSVOUGTGSA-N'
)

> classification_list <- map(keys, entity_classification)

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
```
