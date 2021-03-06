\name{foreach}
\alias{foreach}
\title{foreach}

\description{ Execute function in parallel as distributed
  tasks. Implicit barrier at the end of loop.
}

\usage{
   foreach(index, range, func, progress=TRUE, scheduler=0)
}
\arguments{
  \item{index}{loop index.}
  \item{range}{vector. Range of loop index.}
  \item{func}{function to execute in parallel.}
  \item{progress}{display progress bar if TRUE.}
  \item{scheduler}{choose task placement policy. Default policy minimizes data movement. Set to 1 if tasks should be placed on the worker where the first argument resides.}
}

\details{
  \code{\link{foreach}} executes a function in parallel on worker
  nodes. Programmers can pass any R object as argument to the
  function. Distributed array, data frame or lists, and their partitions can be
  passed using \code{\link{splits}}.
  
  The \code{\link{foreach}} loop or the function executed by it does not
  return any value. Instead, users can call \code{\link{update}} inside
  \code{func} to modify distributed arrays, data frames or lists and publish
  changes. Note that \code{\link{update}} is the only way to make
  side-effects globally visible. 
}

\value{
}

\references{
  \itemize{
    \item Venkataraman, S., Bodzsar, E., Roy, I.,
    AuYoung, A., and Schreiber, R. (2013) Presto: Distributed Machine
      Learning and Graph Processing with Sparse
      Matrices. \emph{EuroSys'13},
      197--210.
      \item Homepage: http://www.vertica.com/distributedr
%      \item Mailing list: presto-dev@external.groups.hp.com
    }
  }

\author{HP Vertica Development Team}

\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
\code{\link{darray}}, \code{\link{dframe}}, \code{\link{dlist}}, \code{\link{splits}}, \code{\link{update}}, 
\code{\link{npartitions}}
}

\examples{
\dontrun{
library(distributedR)
distributedR_start()
da <- darray(dim=c(9,9), blocks=c(3,3), sparse=FALSE, data=10)
cat("Number of partitions of da are ", npartitions(da),"\n")
db <- darray(dim=c(9,9), blocks=c(3,3), sparse=FALSE, data=5)
result <- darray(dim=c(9,9), blocks=c(3,3))
##Add two matrices in parallel
foreach(i, 1:npartitions(da),
  add<-function(a = splits(da,i),
                b = splits(db,i),
                c = splits(result,i)){
    c <- a + b
    update(c)
  })
getpartition(result)
distributedR_shutdown()
}
}

