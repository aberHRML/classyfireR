# classyfireR 0.3.3

* Fix error when `get_classification` runs with no error codes, but no classification data is returned

# classyfireR 0.3.2

* Add check to `get_classification` for when a valid http status code (200) is returned but the content of the return is `{}`. This appears to be an error during InChIKey validation. 

* Add further length checks in `get_classification` for when there are no `alternative_parents` returned. 

# classyfireR 0.3.1

* Add length checks in `get_classification` for when elements of the `json` output is missing (ie, no external descriptors present)

# classyfireR 0.3.0

* Use `S4` object orientation (OO) for storing and accessing results

# classyfireR 0.2.3

* `stringr`, `dplyr` and `purrr` functions are now imported

# classyfireR 0.2.2

* `get_classification` now checks if the ClassyFire server rate limit has been exceeded

# classyfireR 0.2.1

* Fix internal parsing function so that entries with no classifications returns `NULL`
* Add @jasenfinch as package contributor

# classyfireR 0.2.0

* Remove POST submission functions. ClassyFire database is now extensive enough that new submission are rarely needed. This will prevent the intermitent failing of checks on CRAN aswell. 
* Add `pkgdown` website for docs
* `entity_classification` renamed to `get_classification`
* All available classificatons now returned (@jasenfinch)

# classyfireR 0.1.2

* Fix unit test to catch when server is unresponsive. This will fix intermittent CRAN check fails

# classyfireR 0.1.1

* Add more detailed examples ready for CRAN submission

# classyfireR 0.1.0

* Low level access to the ClassyFire RESTful API
* Retrieve existing classifications using InChI Keys
* Submit new classifications to the server using InChI Codes and retrieve the results
