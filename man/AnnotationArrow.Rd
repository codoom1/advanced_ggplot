% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/annotation.R
\name{AnnotationArrow}
\alias{AnnotationArrow}
\title{Arrow Annotation}
\description{
Add arrows to the plot
}
\section{Super class}{
\code{\link[AdvancedGgplot:Annotation]{AdvancedGgplot::Annotation}} -> \code{AnnotationArrow}
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-AnnotationArrow-new}{\code{AnnotationArrow$new()}}
\item \href{#method-AnnotationArrow-render}{\code{AnnotationArrow$render()}}
\item \href{#method-AnnotationArrow-clone}{\code{AnnotationArrow$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-AnnotationArrow-new"></a>}}
\if{latex}{\out{\hypertarget{method-AnnotationArrow-new}{}}}
\subsection{Method \code{new()}}{
Initialize arrow annotation
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{AnnotationArrow$new(
  x0,
  y0,
  x1,
  y1,
  color = "black",
  size = 1,
  arrow_size = 0.1
)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{x0}}{Start x coordinate}

\item{\code{y0}}{Start y coordinate}

\item{\code{x1}}{End x coordinate}

\item{\code{y1}}{End y coordinate}

\item{\code{color}}{Arrow color}

\item{\code{size}}{Line size}

\item{\code{arrow_size}}{Size of arrow head}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-AnnotationArrow-render"></a>}}
\if{latex}{\out{\hypertarget{method-AnnotationArrow-render}{}}}
\subsection{Method \code{render()}}{
Render arrow annotation
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{AnnotationArrow$render(viewport)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{viewport}}{The current viewport}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-AnnotationArrow-clone"></a>}}
\if{latex}{\out{\hypertarget{method-AnnotationArrow-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{AnnotationArrow$clone(deep = FALSE)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{deep}}{Whether to make a deep clone.}
}
\if{html}{\out{</div>}}
}
}
}
