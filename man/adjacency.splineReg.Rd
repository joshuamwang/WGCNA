\name{adjacency.splineReg}
\alias{adjacency.splineReg}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{Calculate network adjacency based on natural cubic spline regression
}
\description{
adjacency.splineReg calculates a network adjacency matrix by fitting spline regression models to pairs of variables (i.e. pairs of columns from
 \code{datExpr}). Each spline regression model results in a fitting index R.squared.  Thus, the n columns of
\code{datExpr} result in an n x n dimensional matrix whose entries contain R.squared measures. This matrix
is typically non-symmetric. To arrive at a (symmetric) adjacency matrix, one can specify different
symmetrization methods with \code{symmetrizationMethod}. }

\usage{
adjacency.splineReg(
   datExpr, 
   df = 6-(nrow(datExpr)<100)-(nrow(datExpr)<30), 
   symmetrizationMethod = "mean", 
   ...) 
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{datExpr}{
  data frame containing numeric variables. Example: Columns may correspond to genes and rows to observations (samples).}
  \item{df}{
degrees of freedom in generating natural cubic spline. The default is as follows: if nrow(datExpr)>100 use 6, if nrow(datExpr)>30 use 4, otherwise use 5.}
  \item{symmetrizationMethod}{
  character string (eg "none", "min","max","mean") that specifies the method used to symmetrize the pairwise model fitting index matrix (see details).}
  \item{...}{
other arguments from function \code{\link[splines]{ns}}}
}
\details{
A network adjacency matrix is a symmetric matrix whose entries lie between 0 and 1. It is a special case of a similarity matrix.
Each variable (column of \code{datExpr}) is regressed on every other variable, with each model fitting index recorded in a square matrix. Note that the model fitting index of regressing variable x and variable y is usually different from that of regressing y on x.  From the spline regression model
glm( y ~ ns( x, df)) one can calculate the model fitting index R.squared(y,x). 
R.squared(y,x) is a number between 0 and 1. The closer it is to 1, the better the spline regression model
describes the relationship between x and y and the more significant is the pairwise relationship between the
2 variables. One can also reverse the roles of x and y to arrive at a model fitting index R.squared(x,y).
R.squared(x,y) is typically different from R.squared(y,x). Assume a set of n variables x1,...,xn
(corresponding to the columns of \code{datExpr}) then one can define R.squared(xi,xj). The model fitting
indices for the elements of an n x n dimensional matrix (R.squared(ij)).  
\code{symmetrizationMethod} implements the following symmetrization methods: 
A.min(ij)=min(R.squared(ij),R.squared(ji)),
A.ave(ij)=(R.squared(ij)+R.squared(ji))/2, 
A.max(ij)=max(R.squared(ij),R.squared(ji)).
For more information about natural cubic spline regression, please refer to functions "ns" and "glm".}
\value{
An adjacency matrix of dimensions ncol(datExpr) times ncol(datExpr).}
\references{
Song L, Langfelder P, Horvath S Avoiding mutual information based co-expression measures (to appear).

Horvath S (2011) Weighted Network Analysis. Applications in Genomics and Systems Biology. Springer Book. ISBN: 978-1-4419-8818-8
}
\author{
Lin Song, Steve Horvath
}

\seealso{
\code{\link[splines]{ns}}, \code{\link{glm}}
}
\examples{
#Simulate a data frame datE which contains 5 columns and 50 observations
m=50
x1=rnorm(m)
r=.5; x2=r*x1+sqrt(1-r^2)*rnorm(m)
r=.3; x3=r*(x1-.5)^2+sqrt(1-r^2)*rnorm(m)
x4=rnorm(m)
r=.3; x5=r*x4+sqrt(1-r^2)*rnorm(m)
datE=data.frame(x1,x2,x3,x4,x5)
#calculate adjacency by symmetrizing using max
A.max=adjacency.splineReg(datE, symmetrizationMethod="max")
A.max
#calculate adjacency by symmetrizing using max
A.mean=adjacency.splineReg(datE, symmetrizationMethod="mean")
A.mean
# output the unsymmetrized pairwise model fitting indices R.squared 
R.squared=adjacency.splineReg(datE, symmetrizationMethod="none")
R.squared
}

\keyword{misc}% __ONLY ONE__ keyword per line
