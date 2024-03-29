% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_classification.R
\name{get_classification}
\alias{get_classification}
\title{Get Entity Classification}
\usage{
get_classification(inchi_key, conn = NULL)
}
\arguments{
\item{inchi_key}{a character string of a valid InChIKey}

\item{conn}{a DBIConnection object, as produced by dbConnect}
}
\value{
a \code{ClassyFire} S4 object.
}
\description{
Retrieve entity classification from `http://classyfire.wishartlab.com/entities/'.
The optional local cache function enables classification requests with less waiting time.
Furthermore, there will be fewer traffic on the classyFire servers. For best high efficiency
there is an option for creating a SQLight database to cache results.
}
\examples{
\dontrun{

# Valid InChI key where all four classification levels are available
get_classification('BRMWTNUJHUMWMS-LURJTMIESA-N')

# Valid InChI key where only three classification levels are available
get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-N')

# Invalid InChI key
get_classification('MDHYEMXUFSJLGV-UHFFFAOYSA-B')
}
}
\seealso{
ClassyFire-class
}
