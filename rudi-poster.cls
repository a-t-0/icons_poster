% ======================================================================
% ======================================================================
% ======================================================================
%
% UNOFFICIAL style for Posters at RU-DI
% Radboud University, Donders Institute,
% Nijmengen, Netherlands
%
%     Author: Riccardo Metere <r.metere@donders.ru.nl>
%       Date: Jun 2018
%  Copyright: 2018 (C) Riccardo Metere
%    License: LaTeX Project Public License (LPPL) 
%
% ======================================================================
% ======================================================================
% ======================================================================

% ======================================================================
% TODO:
% - support multiple authors/affiliations/acknowledgements/funding processing
%   e.g.
%     \language{en}
%     \eventname{}
%     \eventlocation{}
%
%     \author[aff1,aff2]{Riccardo Metere}{metere@.mpg.de}
%     \author[aff2]{Harald E. Möller}{moeller@.mpg.de}
%
%     \affiliation[aff1]
%         {Radboud University, Donders Institute, Nijmegen, Netherlands}
%     \affiliation[aff2]
%         {Max Planck Institute for Human Cognitive and Brain Sciences, Leipzig, Germany}
%
%     \acknowledge{Pinco Panco}
%     \acknowledge{Panco Pinco}
%     \acknowledge{Tizio}
%     \acknowledge{Caio}
%     \acknowledge{Sempronio}
%
%     \funding{The European Union}
%     \funding{Some foundation through grant agreement n. 123456}
% ======================================================================

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rudi-poster}[2018/04/23 v0.1 RU DI Posters]  % 

% :: class structure: declaration of options part
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

% :: class structure: execution of options part
\ProcessOptions\relax

% : class structure: declaration of options part
\LoadClass{article}


% ======================================================================
% :: load external packages
\RequirePackage[english]{babel}  % Multilingual support for Plain TeX or LaTeX
\RequirePackage{pgf}  % Create PostScript and PDF graphics in TeX
\RequirePackage{tikz}  % -- user-friendly interface to PGF
\RequirePackage{xcolor}  % Driver-independent color extensions for LaTeX and pdfLaTeX
\RequirePackage[T1]{fontenc}  % Standard package for selecting font encodings
% \RequirePackage{mathptmx}  % Use Times as default text font, and provide maths support}
\RequirePackage{newtxtext}  % Alternative uses of the TX fonts, with improved metrics -- text
\RequirePackage{newtxmath}  % Alternative uses of the TX fonts, with improved metrics -- math
% \RequirePackage{helvet}  % Load Helvetica, scaled -- font package
\RequirePackage{geometry}  % Flexible and complete interface to document dimensions
\RequirePackage{hyperref}  % Extensive support for hypertext in LaTeX
\RequirePackage{titling}  % Control over the typesetting of the \maketitle command
\RequirePackage{calc}  % Simple arithmetic in LaTeX commands
\RequirePackage[en-GB]{datetime2}  % Formats for dates, times and time zones
\RequirePackage{multicol}  % Intermix single and multiple columns
% \RequirePackage[absolute]{textpos}  % Place boxes at arbitrary positions on the LaTeX page
% \RequirePackage{rotating}  % Rotation tools, including rotated full-page floats
% \RequirePackage{qrcode}  % Generate QR codes in LaTeX


% ======================================================================
% :: define helper macros

% : Institute full name
\newcommand{\RUDI}{Radboud University}
\newcommand{\DELFT}{Delft University}
\newcommand{\RUDISHORT}{Radboud University, Nijmegen (NL)}
\newcommand{\RUDIFULL}{Radboud University, Nijmegen, Netherlands}


% : url, mailto, doi decoration
\let\URL\url
\renewcommand{\url}[1]{\textcolor{rudi-dark-orange}{\URL{#1}}}
\newcommand{\mailto}[1]{\href{mailto:#1}{\textcolor{rudi-bright-red}{\texttt{#1}}}}
\newcommand{\doi}[1]{doi:\href{http://doi.org/#1}{{\textcolor{rudi-dark-red}{\detokenize{#1}}}}}

% : date management
\DTMsetup{useregional,showdow}
\DTMlangsetup[en-GB]{ord=raise}
\let\olddate\date
\renewcommand{\date}[1]{\olddate{#1}\DTMsavedate{eventdate}{\thedate}}
\newcommand{\theyear}{\DTMfetchyear{eventdate}}
\newcommand{\thedayoftheweek}{\DTMfetchdow{eventdate}}
\newcommand{\theeventdate}{\DTMusedate{eventdate}}
\selectlanguage{english}


% ======================================================================
% :: define template colors
% : base colors
\definecolor{rudi-black}{cmyk}{0,0,0,1}
\definecolor{rudi-dark-red}{cmyk}{0,1,1,0.5}
\definecolor{rudi-ru-red}{cmyk}{0,1,1,0.25}
\definecolor{rudi-bright-red}{cmyk}{0,1,1,0}
% : extended colors
\definecolor{rudi-dark-orange}{cmyk}{0,0.70,1,0}
\definecolor{rudi-light-orange}{cmyk}{0,0.25,1,0}
\definecolor{rudi-yellow}{cmyk}{0,0,1,0}
% : additional colors (unofficial)
\definecolor{rudi-dead-red}{cmyk}{0,0.5,0.5,1}
\definecolor{rudi-water-red}{cmyk}{0,0.05,0.05,0}
\definecolor{rudi-water-orange}{cmyk}{0,0.04,0.02,0}
\definecolor{rudi-water-yellow}{cmyk}{0,0.02,0.04,0}

\definecolor{rudi-header-title}{named}{rudi-dead-red}
\definecolor{rudi-header-author}{named}{rudi-dark-red}
\definecolor{rudi-header-border}{HTML}{222E7E}
\definecolor{rudi-header-background}{named}{white}
\definecolor{rudi-block-border}{named}{rudi-black}
\definecolor{rudi-block-title}{named}{white}
\definecolor{rudi-block-background}{named}{white}
\definecolor{rudi-block1-border}{named}{rudi-dark-red}
\definecolor{rudi-block1-background}{named}{white}
\definecolor{rudi-block2-border}{named}{rudi-bright-red}
\definecolor{rudi-block2-background}{named}{white}
\definecolor{rudi-block3-border}{named}{rudi-dark-red}
\definecolor{rudi-block3-background}{named}{white}
\definecolor{rudi-block-fig-foreground}{named}{rudi-dark-orange}
\definecolor{rudi-block-fig-background}{named}{rudi-water-orange}
\definecolor{rudi-text}{named}{rudi-dead-red}


% ======================================================================
% :: define poster sizes

% : define `setnewlength` auxiliary command
\newcommand{\setnewlength}[2]{\newlength{#1}\setlength{#1}{#2}}

\setnewlength{\rudisizebase}{\maxof{\paperwidth}{\paperheight}}
\setnewlength{\uum}{0.0008410428931875525\rudisizebase}

% : poster specific text sizes
% note: 1mm = 2.8452755845248108pt and 1pt = 0.35145980425899936mm
\setnewlength{\rudisizetext}{9\uum}  % ~ 28.5pt
\setnewlength{\rudisizetitle}{2\rudisizetext} % Size of title 
\setnewlength{\rudisizeauthors}{\rudisizetext}
\setnewlength{\rudisizeaffiliations}{0.9\rudisizetext}

\renewcommand{\tiny}{\fontsize{0.60\rudisizetext}{0.7500\rudisizetext}\selectfont}
\renewcommand{\scriptsize}{\fontsize{0.70\rudisizetext}{0.8750\rudisizetext}\selectfont}   
\renewcommand{\footnotesize}{\fontsize{0.80\rudisizetext}{1.0000\rudisizetext}\selectfont}
\renewcommand{\small}{\fontsize{0.90\rudisizetext}{1.1250\rudisizetext}\selectfont}
\renewcommand{\normalsize}{\fontsize{1.00\rudisizetext}{1.2500\rudisizetext}\selectfont}
\renewcommand{\large}{\fontsize{1.15\rudisizetext}{1.4375\rudisizetext}\selectfont}
\renewcommand{\Large}{\fontsize{1.30\rudisizetext}{1.6250\rudisizetext}\selectfont}
\renewcommand{\LARGE}{\fontsize{1.45\rudisizetext}{1.8125\rudisizetext}\selectfont}
\renewcommand{\huge}{\fontsize{1.60\rudisizetext}{2.0000\rudisizetext}\selectfont}
\renewcommand{\Huge}{\fontsize{1.75\rudisizetext}{2.1875\rudisizetext}\selectfont}
\newcommand{\veryHuge}{\fontsize{1.90\rudisizetext}{2.375\rudisizetext}\selectfont}
\newcommand{\VeryHuge}{\fontsize{2.05\rudisizetext}{2.5625\rudisizetext}\selectfont}
\newcommand{\VERYHuge}{\fontsize{2.20\rudisizetext}{2.7500\rudisizetext}\selectfont}

% : redefine base layout sizes
\setlength{\columnsep}{1.2\rudisizetext}
\setlength{\parskip}{1\rudisizetext}
% \setlength{\parindent}{0mm}
% \setlength{\textfloatsep}{0mm}
\setlength{\tabcolsep}{0.5\rudisizetext}

% : define poster specific layout sizes
\setnewlength{\rudisizeborder}{2\uum}
\setnewlength{\rudisizehpadding}{10\uum}
\setnewlength{\rudisizevpadding}{5\uum}

\setnewlength{\rudisizemargin}{10\uum}

\setnewlength{\rudisizetopmargin}{1.2\rudisizemargin}
\setnewlength{\rudisizebottommargin}{45\uum}

\setnewlength{\rudisizeleftmargin}{50\uum}
\setnewlength{\rudisizerightmargin}{20\uum}

\setnewlength{\rudisizeblocktitleheight}{20\uum} % Block title height
\setnewlength{\rudisizeblocktitlewidth}{60\uum}
\setnewlength{\rudisizelogooffset}{2\uum}

% The figure caption height and width(Orange blocks with Fig. 1 in them)
\setnewlength{\rudisizefigtitleheight}{10\uum}
\setnewlength{\rudisizefigtitlewidth}{12\uum}

\setnewlength{\rudisizeextralogo}{\rudisizebottommargin - \rudisizemargin}

% : block sizes
\setnewlength{\rudisizeblockheader}{1\uum}
% Abstract
\setnewlength{\rudisizeblockintro}{0.06\paperheight}
% Ignore
\setnewlength{\rudisizeblockmethods}{0.01\paperheight} % min
% Methodology
\setnewlength{\rudisizeblockintroduction}{0.37\paperheight}% min
% Ignore
\setnewlength{\rudisizeblockdiscussion}{0.08\paperheight}

% IGNORE
\setnewlength{\rudisizeblockmethodsresultsbody}{0.26\paperheight}
% Results & Discussion
\setnewlength{\rudisizeblockconclusion}{0.30\paperheight}

% Conclusion and Recommendations
\setnewlength{\rudisizeblockrecommendations}{0.05\paperheight}

\setnewlength{\rudisizeblockresults}{0.50\paperheight}

% is adjusted later
\setnewlength{\rudisizeblockreferences}{0.18\paperheight}
\setnewlength{\rudisizeblockaddendum}{0.18\paperheight}


% : derived poster sizes
% set length to vertical fill space of results block
% \setlength{\rudisizeblockresults}{\paperheight - \rudisizeblockheader - \rudisizeblockintro - \rudisizeblockmethods - \rudisizeblockdiscussion - 0\rudisizeblocktitleheight - 4\parskip - 1\rudisizetopmargin -1\rudisizebottommargin - 8\rudisizevpadding - 4\rudisizeborder - 2\rudisizeblocktitleheight  + 0\uum - 10\uum}

\setlength{\rudisizeblockresults}{\paperheight - \rudisizeblockheader - \rudisizeblockintro - \rudisizeblockmethods - \rudisizeblockdiscussion - 0\rudisizeblocktitleheight - 4\parskip - 1\rudisizetopmargin -1\rudisizebottommargin - 8\rudisizevpadding - 4\rudisizeborder - 2\rudisizeblocktitleheight  + 0\uum - 10\uum}

% set length of Addendum block equal to Discussion block
\setlength{\rudisizeblockreferences}{\rudisizeblockdiscussion}
\setlength{\rudisizeblockaddendum}{\rudisizeblockdiscussion}


% ======================================================================
% : set-up `hyperref` package
\hypersetup{% hyperref setup for PDFs
  bookmarksnumbered,
  colorlinks=false,
%   linkcolor=[rgb]{0,0,0.3},
%   anchorcolor=[rgb]{0,0,0},
%   citecolor=[rgb]{0,0.3,0},
%   filecolor=[rgb]{0,0.3,0.3},
%   menucolor=[rgb]{0.3,0,0.3},
%   runcolor=[rgb]{0.3,0.2,0},
%   urlcolor=[named]{rudi-dark-orange},
%   citebordercolor=[rgb]{0,1,0},
%   filebordercolor=[rgb]{0,0.5,0.5},
%   linkbordercolor=[rgb]{1,1,0},
%   menubordercolor=[rgb]{1,0.8,0},
%   urlbordercolor=[rgb]{0,1,1},
%   runbordercolor=[rgb]{0,0.7,0.7},
  pdfborderstyle={/S/U/W 0.0}% border style will be underline with a given width
}%


% ======================================================================
% : set-up margin size using `geometry`
\geometry{
  top=\rudisizetopmargin,
  bottom=\rudisizebottommargin,
  left=\rudisizeleftmargin,
  right=\rudisizerightmargin,
%   vmargin=2cm,
%   hmargin=3cm,
%   margin=0ex,
  }


% ======================================================================
% :: define block environments

% : base block environment
\newenvironment{rudiblock}[5]{%
\bgroup\noindent\ignorespaces%
\gdef\rudicolborder{#1}%
\gdef\rudicolbackground{#2}%
\gdef\rudiblockwidth{#3}%
\gdef\rudiblockheight{#4}%
\gdef\rudiblocktitle{#5}%
\begin{tikzpicture}%
    \node [draw=\rudicolborder, fill=\rudicolbackground, line width=\rudisizeborder,%
            rectangle, inner sep=\rudisizehpadding, inner ysep=\rudisizevpadding] (box) \bgroup%
        \begin{minipage}[t!][\rudiblockheight][t]{\rudiblockwidth - 2\rudisizeborder - 2\rudisizehpadding}%
        \vspace{0.45\rudisizeblocktitleheight}%
        \rmfamily\fontsize{\rudisizetext}{1.25\rudisizetext}\selectfont\color{rudi-text}}%
        {\vfill%
        \end{minipage}\egroup;%
    \node[fill=\rudicolbackground, text=\rudicolborder, right=0pt,%
            minimum height=\rudisizeblocktitleheight, anchor=north west, inner sep=0.5\rudisizehpadding,%
            above=-0.02\rudisizeblocktitleheight, right=2\rudisizehpadding, align=center]%
            at (box.north west) {%
        \sffamily\fontseries{l}\fontsize{0.7\rudisizeblocktitleheight}{\rudisizeblocktitleheight}\selectfont{{\expandafter\MakeUppercase\expandafter{\rudiblocktitle}}}};%
\end{tikzpicture}%
\noindent\ignorespacesafterend\egroup}

% : base block environment with no title
\newenvironment{rudiblocknotitle}[4]{%
\bgroup\noindent\ignorespaces%
\gdef\rudicolborder{#1}%
\gdef\rudicolbackground{#2}%
\gdef\rudiblockwidth{#3}%
\gdef\rudiblockheight{#4}%
\begin{tikzpicture}%
    \node [draw=\rudicolborder, fill=\rudicolbackground, line width=\rudisizeborder,%
            rectangle, inner sep=\rudisizehpadding, inner ysep=\rudisizevpadding] (box) \bgroup%
        \begin{minipage}[t!][\rudiblockheight][t]{\rudiblockwidth - 2\rudisizeborder - 2\rudisizehpadding}%
        \rmfamily\fontsize{\rudisizetext}{1.25\rudisizetext}\selectfont\color{rudi-text}\vspace{0.5\rudisizevpadding}}%
        {\vfill%
        \end{minipage}\egroup;%
\end{tikzpicture}%
\noindent\ignorespacesafterend\egroup}

% : derived rudi-block environments
%    - rudiblockintro
%    - rudiblockmethods
%    - rudiblockresults
%    - rudiblockdiscussion
%    - rudiblockaddendum
\newenvironment{rudiblockintro}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockintro}{Abstract}}{\end{rudiblock}}

\newenvironment{rudiblock_target_audience}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockintro}{Abstract}}{\end{rudiblock}}
\newenvironment{rudiblocki_executive_summary}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockintro}{Executive Summary}}{\end{rudiblock}}

\newenvironment{rudiblockiintroduction}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockintroduction}{Methodology}}{\end{rudiblock}}

\newenvironment{rudiblockimethodsresultsbody}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockmethodsresultsbody}{Open Source With KLM: How and Why}}{\end{rudiblock}}

\newenvironment{rudiblockiconclusion}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockconclusion}{Results \& Discussion}}{\end{rudiblock}}

\newenvironment{rudiblockipolicyrecommendations}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockrecommendations}{Conclusion \& Recommendations}}{\end{rudiblock}}


\newenvironment{rudiblockmethods}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockmethods}{Executive Summary}}{\end{rudiblock}}

\newenvironment{rudiblockdesign}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockmethods}{Design}}{\end{rudiblock}}
\newenvironment{rudiblockanalysis}{\begin{rudiblock}{rudi-block1-border}{rudi-block1-background}{\hsize}{\rudisizeblockmethods}{Analysis}}{\end{rudiblock}}

\newenvironment{rudiblockresults}{\begin{rudiblock}{rudi-block2-border}{rudi-block2-background}{\hsize}{\rudisizeblockresults}{Results \& Discussion}}{\end{rudiblock}}



\newenvironment{rudiblockconclusion}{\begin{rudiblock}{rudi-block3-border}{rudi-block3-background}{\hsize}{\rudisizeblockconclusion}{Results \& Discussion}}{\end{rudiblock}}

\newenvironment{rudiblock_references_and_acknowledgements}{\begin{rudiblock}{rudi-block3-border}{rudi-block3-background}{\hsize}{\rudisizeblockreferences}{References \& Acknowledgements}}{\end{rudiblock}}

\newenvironment{rudiblockaddendum}{\begin{rudiblocknotitle}{rudi-block3-border}{rudi-block3-background}{\hsize}{\rudisizeblockaddendum}}{\end{rudiblocknotitle}}

% : derived block figure environment
\newenvironment{rudifig}[2]{%
\gdef\rudifigwidth{#1}%
\gdef\rudifigtitle{#2}%
\bgroup\noindent\ignorespaces%
\begin{tikzpicture}%
    \node [fill=rudi-block-fig-background, rectangle, inner sep=0.4\rudisizehpadding, inner ysep=0.4\rudisizevpadding] (box) \bgroup%
        \begin{minipage}{\rudifigwidth - 0\rudisizeborder - 0.8\rudisizehpadding}}%
{\end{minipage}\egroup;%
    \node[fill=rudi-block-fig-foreground, text=rudi-block-fig-background, right=0pt, above=-0.4\rudisizevpadding,%
        minimum width=\rudisizefigtitleheight, minimum height=\rudisizefigtitlewidth, anchor=south west, inner sep=0.6\rudisizehpadding, inner ysep=0.3\rudisizevpadding]%
        at (box.north west) {%
    \sffamily\fontseries{m}\fontsize{0.9\rudisizefigtitleheight}{\rudisizefigtitleheight}\selectfont{\rudifigtitle}};%
\end{tikzpicture}%
\noindent\ignorespacesafterend\egroup}

% : derived block sub-environment
\newenvironment{rudisubblock}[2]{%
\gdef\rudisubblockwidth{#1}%
\gdef\rudisubblocktitle{#2}%
\bgroup\noindent\ignorespaces%
\begin{tikzpicture}%
    \node [draw=rudi-block-border, fill=rudi-block-background, line width=\rudisizeborder,%
            rectangle, inner sep=\rudisizehpadding, inner ysep=\rudisizevpadding] (box) \bgroup%
        \begin{minipage}{\rudisubblockwidth - 2\rudisizeborder - 2\rudisizehpadding}%
        \vspace{0.45\rudisizeblocktitleheight}%
        \rmfamily\fontsize{\rudisizetext}{1.25\rudisizetext}\selectfont\color{rudi-text}}%
        {\vspace{0.4\rudisizevpadding}\vfill%
        \end{minipage}\vspace{0.5\rudisizevpadding}\egroup;%
	\node[fill=rudi-block-background, text=rudi-block-border, right=0pt,%
            minimum height=\rudisizeblocktitleheight, anchor=north west, inner sep=0.5\rudisizehpadding,%
            above=0\rudisizeblocktitleheight, right=2\rudisizehpadding, align=center]%
            at (box.north west) {%
        \sffamily\fontseries{l}\fontsize{0.7\rudisizeblocktitleheight}{\rudisizeblocktitleheight}\selectfont{{\expandafter\MakeUppercase\expandafter{\rudisubblocktitle}}}};%
\end{tikzpicture}%
\noindent\ignorespacesafterend\egroup}

% : position 2 parallel blocks
\newenvironment{paralleltwoblocks}[1]{%
\noindent\ignorespaces%
\begin{tabular}[t]{@{}p{#1\hsize - \tabcolsep} p{\hsize - #1\hsize - \tabcolsep}@{}}%
    \noindent\ignorespaces}%
{\noindent\ignorespacesafterend%
\end{tabular}%
\noindent\ignorespacesafterend}

% : position 3 parallel blocks
\newenvironment{parallelthreeblocks}[2]{%
\noindent\ignorespaces%
\begin{tabular}[t]{@{}p{#1\hsize - 2\tabcolsep} p{#2\hsize - 2\tabcolsep} p{\hsize - #1\hsize - #2\hsize - 2\tabcolsep}@{}}%
    \noindent\ignorespaces}%
{\noindent\ignorespacesafterend%
\end{tabular}%
\noindent\ignorespacesafterend}


% ======================================================================
% :: Define poster header
\newcommand{\rudiposterheader}[3]{%
\bgroup\noindent\ignorespaces%
\gdef\rudipostertitle{#1}%
\gdef\rudiposterauthors{#2}%
\gdef\rudiposteraffiliations{#3}%
\setlength{\parskip}{\parskip - \rudisizelogooffset}%
\begin{tikzpicture}[remember picture, overlay]%
    \node [anchor=north east, rectangle, fill=white, inner sep=0ex, inner ysep=0ex] (logorudi) at (current page.north east) {\includegraphics[height=70\uum]{ru_en_1}};%
\end{tikzpicture}%
\begin{tikzpicture}%
	\node [anchor=north west, rectangle, minimum width=\hsize, minimum height=\rudisizeblockheader, xshift=\rudisizeleftmargin, align=left, text width=\hsize] (box) at (current page.north west) {%
        \begin{minipage}{\hsize - 205\uum}%
        \vfill%
        {\rmfamily\fontsize{1\rudisizetitle}{1.2\rudisizetitle}\selectfont\color{rudi-header-title}\rudipostertitle}\par%
        \vfill\vspace{0.5ex}%
        {\rmfamily\fontsize{0.7\rudisizetitle}{0.7\rudisizetitle}\selectfont\color{rudi-header-author}\rudiposterauthors}\par%
        \vfill%
        {\rmfamily\fontsize{0.25\rudisizetitle}{0.25\rudisizetitle}\selectfont\color{rudi-header-title}\rudiposteraffiliations}\par%
        \end{minipage}%
        };%
\end{tikzpicture}%
\setlength{\parskip}{\parskip + \rudisizelogooffset}%
\noindent\ignorespacesafterend}%


% ======================================================================
% :: Define poster side note
\newcommand{\rudipostersidenote}[1]{%
\bgroup\noindent\ignorespaces%
\begin{tikzpicture}[remember picture,overlay]%
	\node[rotate=90, anchor=south west, xshift=\rudisizemargin] at (current page.south east) {\sffamily\fontsize{0.6\rudisizemargin}{0.8\rudisizemargin}\selectfont#1};
	\node[rectangle, anchor=south east, minimum width=30\uum, minimum height=\paperheight, inner sep=0ex, inner ysep=0ex, outer sep=0ex, outer ysep=0ex] (first band) at (current page.north west) {};%
\end{tikzpicture}%
\noindent\ignorespacesafterend}%


% ======================================================================
% :: Define poster footer
\newcommand{\rudiposterfooter}[2]{%
\bgroup\noindent\ignorespaces%
\gdef\rudipostercontact{#1}%
\gdef\rudiposterextralogos{#2}%
\setlength{\parskip}{\parskip - \rudisizelogooffset}%
\begin{tikzpicture}[remember picture, overlay]%
    \node [anchor=south east, rectangle, inner sep=1.5\rudisizerightmargin, inner ysep=\rudisizemargin] (logoruumc) at (current page.south east) {\includegraphics[height=30\uum]{latex/os_logo.png}};%
\end{tikzpicture}%
\begin{tikzpicture}[remember picture, overlay]%
	\node [anchor=south west, rectangle, minimum height=\rudisizebottommargin, minimum width=0.2\hsize, xshift=\rudisizeleftmargin, align=left, inner ysep=\rudisizemargin] (contact) at (current page.south west) {%
        {\rmfamily\fontsize{\rudisizetitle}{1.2\rudisizetitle}\selectfont\color{rudi-header-author}}\rudipostercontact};%
    \node [anchor=south west, rectangle, minimum height=\rudisizebottommargin, minimum width=0.8\hsize - 200\uum, align=center, inner ysep=0.9\rudisizemargin] (box) at (contact.south east) {\rudiposterextralogos};%
\end{tikzpicture}%
\setlength{\parskip}{\parskip + \rudisizelogooffset}%
\noindent\ignorespacesafterend}%


% ======================================================================
% :: Define poster bands
\newcommand{\rudibands}{%
\bgroup\noindent\ignorespaces%
\begin{tikzpicture}[remember picture,overlay]%
	\node[fill=rudi-bright-red, rectangle, anchor=north west, minimum width=30\uum, minimum height=\paperheight, inner sep=0ex, inner ysep=0ex, outer sep=0ex, outer ysep=0ex] (first band) at (current page.north west) {};%
    \node[fill=rudi-ru-red, rectangle, anchor=north west, minimum width=26\uum, minimum height=\paperheight, inner sep=0ex, inner ysep=0ex, outer sep=0ex, outer ysep=0ex] (second band) at (current page.north west) {};%
    \node[fill=rudi-dark-red, rectangle, anchor=north west, minimum width=16\uum, minimum height=\paperheight, inner sep=0ex, inner ysep=0ex, outer sep=0ex, outer ysep=0ex] (third band) at (current page.north west) {};%
\end{tikzpicture}%
\noindent\ignorespacesafterend}%


% ======================================================================
\AtBeginDocument{%
\pagestyle{empty}%
\rudibands%
\vspace{-20\uum}
}

\AtEndDocument{
\clearpage
}

% ======================================================================
\endinput
% ======================================================================
