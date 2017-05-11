## SMDS Beamer Theme

## Installation

Installing the SMDS theme from source, like any Beamer theme, involves four easy
steps:

1. **Download the source** with a `git clone` of the [Metropolis repository](https://github.com/ds-lab/smds-beamer-theme)
or as a [zip archive](https://github.com/ds-lab/smds-beamer-theme/archive/master.zip) of the latest development version.

2. **Compile the style files** by running `make sty` inside the downloaded
    directory. (Or run LaTeX directly on `source/smdstheme.ins`.)

3. **Move the resulting `*.sty` files** to the folder containing your
   presentation. To use Metropolis with many presentations, run `make install`
   or move the `*.sty` files to a folder in your TeX path instead (might require
   `sudo` rights).

4. **Use the theme for your presentation** by declaring `\usetheme{smds}` in
    the preamble of your Beamer document.

## Usage
The following code snippet illustrates the use of the SMDS Beamer
theme in a very simple Beamer presentation.

```latex
\documentclass{beamer}
\usetheme{smds}       % Use SMDS theme
\title{Hello World}
\date{\today}
\author{Adrian Rumpold}
\institute{University of Augsburg}
\begin{document}
\maketitle
\section{Introduction}
\begin{frame}{Agenda}
    \begin{itemize}
    \item Eat ice cream.
    \item Drink coffee.
    \end{itemize}
\end{frame}
\end{document}
```

## License

The theme itself is licensed under a [Creative Commons Attribution-ShareAlike
4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/). This
means that if you change the theme and re-distribute it, you *must* retain the
copyright notice header and license it under the same CC-BY-SA license. This
does not affect the presentation that you create with the theme.
