#' Convert a recipe in beerXML format to an R data frame.
#'
#' @param beerXML_file A recipe in beerXML format.
#'
#' @return A data frame.
#' @export
#'
#' @importFrom xml2 as_list read_xml xml_children xml_find_all xml_name xml_text
recipe_to_df <- function(beerXML_file) {
  parsed_xml <- read_xml(beerXML_file)

  recipes <- xml_find_all(parsed_xml, ".//RECIPE")

  for (recipe in recipes) {
    nodes <- xml_children(recipe)

    columns <- list()

    for (node in nodes) {
      col_name <- xml_name(node)

      if (length(xml_children(node)) > 0) {
        columns[[col_name]] <- I(list(as_list(node)))
      } else {
        columns[[col_name]] <- xml_text(node)
      }
    }

    df <- as.data.frame(columns)

    if (!exists("recipes_df")) {
      recipes_df <- df
    } else {
      recipes_df <- rbind(recipes_df, df)
    }
  }

  return(recipes_df)
}
