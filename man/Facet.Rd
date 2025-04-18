% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/facet.R
\name{Facet}
\alias{Facet}
\title{Facet Class}
\description{
Base class for faceting
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Facet-new}{\code{Facet$new()}}
\item \href{#method-Facet-split_data}{\code{Facet$split_data()}}
\item \href{#method-Facet-get_dimensions}{\code{Facet$get_dimensions()}}
\item \href{#method-Facet-generate_scales}{\code{Facet$generate_scales()}}
\item \href{#method-Facet-clone}{\code{Facet$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Facet-new"></a>}}
\if{latex}{\out{\hypertarget{method-Facet-new}{}}}
\subsection{Method \code{new()}}{
Initialize faceting
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Facet$new(rows = NULL, cols = NULL, scales = "fixed")}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{rows}}{Variable(s) to use for row facets}

\item{\code{cols}}{Variable(s) to use for column facets}

\item{\code{scales}}{Scale handling ("fixed", "free", "free_x", "free_y")}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Facet-split_data"></a>}}
\if{latex}{\out{\hypertarget{method-Facet-split_data}{}}}
\subsection{Method \code{split_data()}}{
Split data into facets
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Facet$split_data(data)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{Data frame to split}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Facet-get_dimensions"></a>}}
\if{latex}{\out{\hypertarget{method-Facet-get_dimensions}{}}}
\subsection{Method \code{get_dimensions()}}{
Calculate layout dimensions
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Facet$get_dimensions(data)}\if{html}{\out{</div>}}
}

}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Facet-generate_scales"></a>}}
\if{latex}{\out{\hypertarget{method-Facet-generate_scales}{}}}
\subsection{Method \code{generate_scales()}}{
Generate scales for each facet
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Facet$generate_scales(data, original_scales)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{List of faceted data}

\item{\code{original_scales}}{Original plot scales}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Facet-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Facet-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Facet$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
