#
# http://davidgohel.github.io/ReporteRs/index.html
#
# ReporteRs is an R package for creating Microsoft Word and
# Powerpoint documents. It does not require any Microsoft component to be used. I
# 
# ReporteRs needs rJava with a java version >= 1.6
system("java -version")

require(rJava)
.jinit()
.jcall('java.lang.System','S','getProperty','java.version')

install.packages('ReporteRs')
devtools::install_github('davidgohel/ReporteRsjars')
devtools::install_github('davidgohel/ReporteRs')

library(ReporteRs)
example(docx) #run a complete and detailed docx example
example(pptx) #run a complete and detailed pptx example

# Example for a document 
require( ggplot2 )
doc = docx( title = 'My document' )

doc = addTitle( doc , 'First 5 lines of iris', level = 1)
doc = addFlexTable( doc , vanilla.table(iris[1:5, ]) )

doc = addTitle( doc , 'ggplot2 example', level = 1)
myggplot = qplot(Sepal.Length, Petal.Length, data = iris, color = Species, size = Petal.Width )
doc = addPlot( doc = doc , fun = print, x = myggplot )

doc = addTitle( doc , 'Text example', level = 1)
doc = addParagraph( doc, 'My tailor is rich.', stylename = 'Normal' )

filename <- tempfile(fileext = ".docx") # the document to produce
writeDoc( doc, filename )

