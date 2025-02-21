#' Parse JSON output
#'
#' Parse the JSON output from the `GET` or `POST` request
#'
#' @param json_res the list output from `jsonlite::fromJSON(x)`
#' @return a `tibble` containing the following;
#' * __Level__ Classification level (kingdom, superclass, class and subclass)
#' * __Classification__ The compound classification
#' * __CHEMONT__ Chemical Ontology Identification code
#' @keywords internal
#' @importFrom magrittr %>%


parse_json_output <- function(json_res)
{
  list_output <-
    list(
      kingdom = json_res[['kingdom']],
      superclass = json_res[['superclass']],
      class = json_res[['class']],
      subclass = json_res[['subclass']],
      intermediate_nodes = json_res[['intermediate_nodes']],
      direct_parent = json_res[['direct_parent']]
    )
  
  if (length(list_output$intermediate_nodes) == 0) {
    list_output$intermediate_nodes <- NULL
  }
  
  list_output <- list_output[!sapply(list_output, is.null)]
  
  if (length(list_output) > 0) {
    # Convert list_output into a data frame by iterating over each element
    class_tibble <- do.call(rbind, lapply(seq_along(list_output), function(i) {
      l <- list_output[[i]]
      data.frame(
        Level = names(list_output)[i],  # Extract the name of the list element as Level
        Classification = l$name,  # Extract the classification name
        CHEMONT = l$chemont_id,  # Extract the chemical ontology ID
        stringsAsFactors = FALSE  # Ensure character columns remain characters
      )
    }))
    
    # Remove duplicate classifications
    class_tibble <- class_tibble[!duplicated(class_tibble$Classification), ]
    
    # Count the number of intermediate nodes
    nIntermediate <- sum(class_tibble$Level == "intermediate_nodes")
    
    # Rename intermediate nodes dynamically
    class_tibble$Level[class_tibble$Level == "intermediate_nodes"] <- 
      paste0("level ", seq_len(nIntermediate) + 4)
    
    # Rename direct_parent level based on the number of intermediate nodes
    class_tibble$Level[class_tibble$Level == "direct_parent"] <- 
      paste0("level ", 5 + nIntermediate)
  } else {
    class_tibble <- tibble()
  }
  return(class_tibble)
}


#' Parse External Descriptors
#'
#' Parse the list output of returned External Descriptors
#'
#' @param json_res the list output from `jsonlite::fromJSON(x)`
#' @return a `tibble` containing the following;
#' * __source__ External source name
#' * __source_id__ External source ID
#' * __annotations__ External source annotation
#' @importFrom tibble tibble
#' @keywords internal

parse_external_desc <- function(x)
{
  external_ann <- list()
  for (i in seq_along(x$external_descriptors$annotations)) {
    external_ann[[i]] <-
      paste(x$external_descriptors$annotations[[i]], collapse = ' // ')
  }

  external_desc <-
    tibble::tibble(
      source = x$external_descriptors$source,
      source_id = x$external_descriptors$source_id,
      annotations = unlist(external_ann)
    )

  return(external_desc)
}



#' Check if ClassyFire API Server is available
#'
#' @return a numeric value. 0 if the server is not accessible. 1 if the server is accessible.
#' @keywords internal


is_server_there <- function()
{

  response <- httr::GET(
    'http://classyfire.wishartlab.com/entities/BRMWTNUJHUMWMS-LURJTMIESA-N.json',
    quiet = T
  )

  if (response$status_code == 200) {
    return(1)
  } else{
    return(0)
  }
}

