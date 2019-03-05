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
