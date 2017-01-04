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
