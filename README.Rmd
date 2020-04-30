# classyfireR

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/aberHRML/classyfireR.svg?branch=master)](https://travis-ci.org/aberHRML/classyfireR) [![Build status](https://ci.appveyor.com/api/projects/status/ua94fiotdmc0ssq5/branch/master?svg=true)](https://ci.appveyor.com/project/wilsontom/classyfirer/branch/master) [![codecov](https://codecov.io/gh/wilsontom/classyfireR/branch/master/graph/badge.svg)](https://codecov.io/gh/wilsontom/classyfireR) ![License](https://img.shields.io/badge/license-GNU%20GPL%20v3.0-blue.svg "GNU GPL v3.0") [![DOI](https://zenodo.org/badge/118162964.svg)](https://zenodo.org/badge/latestdoi/118162964)

[![CRAN](https://www.r-pkg.org/badges/version/classyfireR)](https://cran.r-project.org/web/packages/classyfireR/index.html) ![total downloads](https://cranlogs.r-pkg.org/badges/grand-total/classyfireR?color=red)
> __R Interface to the [ClassyFire REST API](http://classyfire.wishartlab.com)__ 


### Installation & Usage
`classyfireR` can be installed from CRAN using;

```R
install.packages('classyfireR')
```

Or the latest development version can be installed form GitHub using the `remotes` package

```R
remotes::install_github('aberHRML/classyfireR')
```

* [Get Classification](get-classification)
* [Acknowledgements](#acknowledgements)

### Get Classification

__For retrieval of classifications already available; a InChI Key is supplied to the  `get_classification` function.__

```R
library(classyfireR)

> inchi_keys <- c('BRMWTNUJHUMWMS-LURJTMIESA-N', 'MDHYEMXUFSJLGV-UHFFFAOYSA-N')

> classification_result <- get_classification(inchi_keys[1])

✔ BRMWTNUJHUMWMS-LURJTMIESA-N

> classification_result

── ClassyFire Object ────────────────────────────────────────────────────────────────────────── classyfireR v0.3.0
Object Size: 18.2 Kb 
 
Info: 
● InChIKey=BRMWTNUJHUMWMS-LURJTMIESA-N
	 
● [H][C@](N)(CC1=CN(C)C=N1)C(O)=O
	 
● Classification Version: 2.1
	 
kingdom : Organic compounds
└─superclass : Organic acids and derivatives
  └─class : Carboxylic acids and derivatives
    └─subclass : Amino acids, peptides, and analogues
      └─level 5 : Amino acids and derivatives
        └─level 6 : Alpha amino acids and derivatives
          └─level 7 : Histidine and derivatives
```


### Acknowledgements

If you use `classyfireR` you should cite the [ClassyFire](https://jcheminf.springeropen.com/articles/10.1186/s13321-016-0174-y) publication

> ___Djoumbou Feunang Y, Eisner R, Knox C, Chepelev L, Hastings J, Owen G, Fahy E, Steinbeck C, Subramanian S, Bolton E, Greiner R, and Wishart DS___. ClassyFire: Automated Chemical Classification With A Comprehensive, Computable Taxonomy. Journal of Cheminformatics, 2016, 8:61.

> __DOI:__ [10.1186/s13321-016-0174-y](https://jcheminf.springeropen.com/articles/10.1186/s13321-016-0174-y)
