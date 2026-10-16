# Beamart presentation template

A reusable Beamer template for Arthur Pesah's academic presentations, with a
light blue-green vector background, teal emphasis, coauthor portraits, and
progressive overview slides. The shared style is `beamart.sty`; `merlin/` is an
example presentation using it.

## Structure

```text
beamart.sty          Shared colours, typography, layouts, and commands
.latexmkrc          Makes the shared style available to presentation folders
.vscode/            LaTeX Workshop build-on-save settings
<presentation>/
  main.tex          Talk content and metadata
  assets/           Local images and portraits
```

Keep each presentation in its own folder directly below the repository root.
Load the style with `\usepackage{beamart}`, rather than `\usetheme{beamart}`.

## Build

Requires latexmk and a TeX installation containing PDFLaTeX, Beamer, Latin
Modern, physics, and TikZ, such as TeX Live or MacTeX. No Python is needed.

From the repository root, build any presentation with:

```sh
latexmk -cd -pdf my-talk/main.tex
```

The PDF is written alongside that presentation's `main.tex`. The supplied
`make pdf` shortcut currently builds the `merlin/` example; change the path in
the Makefile to select another presentation.

## Start a presentation

Create a folder for the talk and add a `main.tex`, for example:

```latex
% !TeX root = main.tex
% !LW recipe = latexmk (presentation)
\documentclass[aspectratio=169,11pt,t]{beamer}
\usepackage{beamart}

\title{Talk title}
\presenter{Presenter name}{Affiliation}
\date{}
\venue{}

\begin{document}
\begin{frame}
  \titlepage
\end{frame}

\begin{frame}{Introduction}
  Some text with \emphword{an emphasized phrase}.
\end{frame}
\end{document}
```

Add coauthors with `\coauthors{...}` in the preamble. Each entry uses
`\coauthorportrait[yshift=-3mm]{assets/photo.png}{Name}{Affiliation}`; the optional
TikZ settings adjust the image inside its circular crop without stretching it.

## Customization

Edit `beamart.sty` for shared colours, background shapes, font sizes, title
layout, and footers. The font settings are named `title`, `frametitle`,
`normal text`, `itemize/enumerate body`, and `catch sentence`. Equation spacing
is controlled by the four lengths inside `\DCPDisplaySpacing`.

Presentation-specific overrides can go after `\usepackage{beamart}` in a talk's
`main.tex`, so other talks continue to use the shared defaults.

## Progressive overview

Use one frame to show a catch sentence alone, then move it upward and explain
one highlighted term at a time:

```latex
\begin{frame}{Overview}
  \overviewstatement{%
    Our method makes \catchterm<2>{large problems} \catchterm<3>{tractable}.%
  }
  \only<2>{\termexplanation{1}{Large problems}{Explain the first term here.}}
  \only<3>{\termexplanation{2}{Tractable}{Explain the second term here.}}
\end{frame}
```

The numbers in `<2>`, `<3>`, etc. select successive overlays, which appear as
separate PDF pages sharing one frame number. Add another term and matching
explanation block to extend the sequence.

The sentence starts 45mm below the page top and moves to 28mm on later overlays.
For custom positioning, use `\catchsentence[28mm]{...}` directly. Set its width
in the style or override it in a presentation:

```latex
\setlength{\catchsentencewidth}{.95\paperwidth}
```

## VS Code

With LaTeX Workshop installed, saving a presentation's `main.tex` runs the
`latexmk (presentation)` recipe. Open the PDF with **LaTeX Workshop: View LaTeX
PDF file**; the viewer refreshes after successful builds.

The shared style's `% !TeX root = ...` comment selects which talk rebuilds when
you save `beamart.sty`. Update that path to the presentation you are working on.
If you open a presentation folder directly instead of the repository root,
copy the supplied `merlin/.vscode/settings.json` into that folder's `.vscode/`.
The editor settings use `/Library/TeX/texbin/latexmk`; adjust that executable
path for installations outside MacTeX.
