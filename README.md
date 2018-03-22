# classyfireR

> R Interface to the ClassyFire REST API (http://classyfire.wishartlab.com)


### Installation & Usage

```R
devtools::install_github('wilsontom/classyfireR')

library(classyfireR)
```

> __For retrival of classifications already available; a InChI Key is supplied to the  `entity_classification` function.__

```
input <- 'BRMWTNUJHUMWMS-LURJTMIESA-N'

classification <- entity_classification(input)



```
