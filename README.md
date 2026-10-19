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
Modern, physics, TikZ, biblatex, and Biber, such as TeX Live or MacTeX.
No Python is needed. Latexmk runs Biber automatically when citations change.

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

## Outline slide

Use `\outlineslide` directly in the document, without a surrounding `frame`:

```latex
\outlineslide
```

It creates an `Outline` slide with pale section numbers, a thin teal
connecting line, and left-aligned titles inside a centred block. The command takes
no arguments: it automatically lists the titles and numbers of all
`\sectionslide` calls in document order, including those later in the talk.
Ordinary `\section` calls do not add outline entries.

The outline uses the previous compilation's auxiliary file, so compile twice
after adding, removing, or renaming sections (`latexmk` does this automatically).
The `outline title` and `outline number` font settings are in the style.

## Section opening slides

Introduce a section with:

```latex
\sectionslide{Section title}
```

The macro registers the Beamer section and creates a divider with an automatic
section number, a thin teal rule, and a large title on the shared
background. It creates its own frame and omits the usual header and footer.
Do not add a separate `\section` for the same section.

An optional subtitle provides a short introduction:

```latex
\sectionslide[A short sentence introducing the topic.]{Section title}
```

Typography is controlled by the `section slide title`, `section slide number`,
and `section slide subtitle` font settings in the style.

## Progressive overview

Use one frame to show a catch sentence alone, then move it upward and explain
one highlighted term at a time:

```latex
\begin{frame}{Overview}
  \overviewstatement{%
    Our method makes \catchterm<2>{large problems} \catchterm<3>{tractable}.%
  }
  \termexplanation{1}{Large problems}{Explain the first term here.}
  \termexplanation{2}{Tractable}{Explain the second term here.}
\end{frame}
```

The numbers in `<2>`, `<3>`, etc. select successive overlays, which appear as
separate PDF pages sharing one frame number. Explanation 1 starts on overlay 2,
explanation 2 on overlay 3, and so on. Numbered captions accumulate down the left
column; only the current caption uses `\emphword`. The right column shows only
the current explanation. Call `\termexplanation` directly, without a surrounding
`\only`, so earlier captions remain visible. Keep the calls in numerical order.
Add another term and matching explanation call to extend the sequence.

The sentence starts 45mm below the page top and moves to 28mm on later overlays.
For custom positioning, use `\catchsentence[28mm]{...}` directly. Set its width
in the style or override it in a presentation:

```latex
\setlength{\catchsentencewidth}{.95\paperwidth}
```

## Slide citations

Keep references in a presentation-local `main.bib` file and load it in the
preamble, after `\usepackage{beamart}`:

```latex
\addbibresource{main.bib}
```

Cite next to the relevant text:

```latex
Tsim\slidecite{haenel2026tsim}
```

Each call adds a superscript number and a small, muted reference at the bottom
of the slide, above the page number. References stack in citation order and
reserve space below the slide content. Each includes all authors with given-name
initials and full surnames, the full title, and the year. Titles link to the
entry's `url` when provided. See `merlin/main.bib` for examples.

For a long title, add an optional `shorttitle` field to the bibliography entry:

```bibtex
shorttitle = {{SymFT}: Universal Fault-Tolerant Quantum Circuit Simulation},
```

Slide citations use `shorttitle` when present and fall back to `title` otherwise.
Keep the complete title in `title` for the bibliography.

By default, citations appear on the current `\pause` step and remain visible on
later overlays. Use `\slidecite{key1,key2}` to stack several references at once, or
`\slidecite<2->{key}` to show a citation from overlay 2 onward. Beamer places
these notes at the bottom of the frame even when cited inside columns.
Adjust `\setbeamerfont{footnote}{size=\fontsize{5.5bp}{7bp}}` to change their size.
The citation block is anchored above the slide footer. Adjust
`\setlength{\slidecitationsep}{5bp}` to change the spacing between entries.
Build with `make pdf` or latexmk so Biber and the required LaTeX reruns happen
automatically.

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
