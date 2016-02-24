# Writing an R package from scratch
# 
# http://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/

# Step 0: Packages you will need
library(devtools)
library(roxygen2)

# Step 1: Create your package directory
setwd("C:/Users/Administrador/Dropbox/_SRC_Rcodes")
create("cats")

# Step 2: Add functions
# Step 3: Add documentation
#' A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param love Do you love cats? Defaults to TRUE.
#' @keywords cats
#' @export
#' @examples
#' cat_function()

cat_function <- function(love=TRUE){
  if(love==TRUE){
    print("I love cats!")
  }
  else {
    print("I am not a cool person.")
  }
}

# Step 4: Process your documentation
setwd("./cats")
document()

# Step 5: Install!
  
#  Step 6: Make the package a GitHub repo
install_github('cats','github_username')

# Step 7-infinity: Iterate
