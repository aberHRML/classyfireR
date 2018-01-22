# classyfireR

> R Interface to the ClassyFire REST API (http://classyfire.wishartlab.com)


### Installation & Usage

```R
devtools::install_github('wilsontom/classyfireR')

library(classyfireR)

# For retrival of classifications already available a InChI Key is supplied to the  `entity_classification` function.

input <- 'BRMWTNUJHUMWMS-LURJTMIESA-N'

classification <- entity_classification(input)


```
