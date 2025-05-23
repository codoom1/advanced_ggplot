% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/animation.R
\name{Animation}
\alias{Animation}
\title{Animation Class}
\description{
Base class for animations
}
\section{Methods}{
\subsection{Public methods}{
\itemize{
\item \href{#method-Animation-new}{\code{Animation$new()}}
\item \href{#method-Animation-generate_frames}{\code{Animation$generate_frames()}}
\item \href{#method-Animation-clone}{\code{Animation$clone()}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Animation-new"></a>}}
\if{latex}{\out{\hypertarget{method-Animation-new}{}}}
\subsection{Method \code{new()}}{
Initialize animation
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Animation$new(duration = 1000, easing = "linear", delay = 0)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{duration}}{Duration in milliseconds}

\item{\code{easing}}{Easing function name}

\item{\code{delay}}{Delay before start in milliseconds}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Animation-generate_frames"></a>}}
\if{latex}{\out{\hypertarget{method-Animation-generate_frames}{}}}
\subsection{Method \code{generate_frames()}}{
Generate animation frames
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Animation$generate_frames(data, n_frames = 30)}\if{html}{\out{</div>}}
}

\subsection{Arguments}{
\if{html}{\out{<div class="arguments">}}
\describe{
\item{\code{data}}{Data frame to animate}

\item{\code{n_frames}}{Number of frames}
}
\if{html}{\out{</div>}}
}
}
\if{html}{\out{<hr>}}
\if{html}{\out{<a id="method-Animation-clone"></a>}}
\if{latex}{\out{\hypertarget{method-Animation-clone}{}}}
\subsection{Method \code{clone()}}{
The objects of this class are cloneable with this method.
\subsection{Usage}{
\if{html}{\out{<div class="r">}}\preformatted{Animation$clone(deep = FALSE)}\if{html}{\out{</div>}}
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
