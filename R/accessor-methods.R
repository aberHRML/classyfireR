#' Accessor Methods for the ClassyFire S4 class

#' @include allClasses.R
#' @include allGenerics.R

#' classification
#' @rdname classification
#' @description Get the `ClassyFire` classification results
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('classification', signature = 'ClassyFire',
          function(object) {
            object@classification
          })

#' classification
#' @rdname classification
#' @description Get the `ClassyFire` classification results
#' @param object a `Query` S4 object
#' @export

setMethod('classification', signature = 'Query',
          function(object) {
            object@classification
          })

#' meta
#' @rdname meta
#' @description Get the `ClassyFire` meta data
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('meta', signature = 'ClassyFire',
          function(object) {
            object@meta
          })

#' meta
#' @rdname meta
#' @description Get the `ClassyFire` meta data
#' @param object a `Query` S4 object
#' @export
setMethod('meta', signature = 'Query',
          function(object) {
            object@meta
          })


#' description
#' @rdname description
#' @description Get the `ClassyFire` description
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('description', signature = 'ClassyFire',
          function(object) {
            object@description
          })

#' description
#' @rdname description
#' @description Get the `ClassyFire` description
#' @param object a `Query` S4 object
#' @export
#'
setMethod('description', signature = 'Query',
          function(object) {
            object@description
          })


#' chebi
#' @rdname chebi
#' @description Get the predicted ChEBI identifications
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('chebi', signature = 'ClassyFire',
          function(object) {
            object@predicted_chebi
          })

#' chebi
#' @rdname chebi
#' @description Get the predicted ChEBI identifications
#' @param object a `Query` S4 object
#' @export
#'
setMethod('chebi', signature = 'Query',
          function(object) {
            object@predicted_chebi
          })

#' descriptors
#' @rdname descriptors
#' @description Get the external descriptors
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('descriptors', signature = 'ClassyFire',
          function(object) {
            object@external_descriptors
          })

#' descriptors
#' @rdname descriptors
#' @description Get the external descriptors
#' @param object a `Query` S4 object
#' @export

setMethod('descriptors', signature = 'Query',
          function(object) {
            object@external_descriptors
          })

#' alternative_parents
#' @rdname alternative_parents
#' @description Get the alternative_parents
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('alternative_parents', signature = 'ClassyFire',
          function(object) {
            object@alternative_parents
          })

#' alternative_parents
#' @rdname alternative_parents
#' @description Get the alternative_parents
#' @param object a `Query` S4 object
#' @export

setMethod('alternative_parents', signature = 'Query',
          function(object) {
            object@alternative_parents
          })


#' direct_parent
#' @rdname direct_parent
#' @description Get the direct_parent
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('direct_parent', signature = 'ClassyFire',
          function(object) {
            object@direct_parent
          })

#' direct_parent
#' @rdname direct_parent
#' @description Get the direct_parent
#' @param object a `Query` S4 object
#' @export

setMethod('direct_parent', signature = 'Query',
          function(object) {
            object@direct_parent
          })
