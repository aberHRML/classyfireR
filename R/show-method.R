#' show-ClassyFire
#' @rdname show
#' @param object a `ClassyFire` S4 object
#' @export

setMethod('show', signature = 'ClassyFire',
          function(object) {
            cat(cli::rule(
              left = crayon::bold('ClassyFire Object'),
              right = paste0('classyfireR v', utils::packageVersion('classyfireR'))
            ), '\n')

            cat(crayon::red(
              'Object Size:',
              format(utils::object.size(object), units = 'Kb'),
              '\n',
              '\n'
            ))

            cat(crayon::green('Info:'), '\n')

            cat('\t', cli::cat_bullet(object@meta$inchikey), '\n')
            cat('\t', cli::cat_bullet(object@meta$smiles), '\n')
            cat('\t', cli::cat_bullet(paste0(
              'Classification Version: ', object@meta$version
            )), '\n')


            TreeList <- list()
            for (i in seq_along(object@classification$Level)) {
              if (i == length(object@classification$Level)) {
                TreeList[[i]] <- c(character(0))
              } else{
                TreeList[[i]] <- object@classification$Level[(i + 1)]
              }
            }


            TreeDF <- data.frame(
              stringsAsFactors = FALSE,
              id = object@classification$Level,
              connections = I(TreeList)
            )

            TreeDF$label <-
              paste0(
                crayon::bold(TreeDF$id),
                ' : ',
                cli::col_cyan(object@classification$Classification)
              )

           print(cli::tree(TreeDF))

          })
