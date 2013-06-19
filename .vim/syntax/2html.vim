" "code2html.vim"
" Transform ("export") a syntax-highlighted source code file into HTML,
" using the current highlighting scheme.

" *********************************************************************
" **  Now Mutated (Maintained) by: Soren Andersen [perlspinr]         *
" **                              (<somian@pobox.com>)                *
" ** with contributions by Christian Hujer <Christian.Hujer@itcqis.com>
" ** ---------------------------------------------------------------  *
" **          See for updates / latest version:                       *
" **    http://vim.sourceforge.net/script.php?script_id=330           *
" **    See samples of the output of this script at my site:          *
" **   http://home.att.net/~perlspinr/makefiles/makefileworkshop.html *
" *********************************************************************
" --------------------------------------------------------------------*
" Previous Credits (when named "2html.vim", as distributed with VIM): *
" Maintainer: Bram Moolenaar <Bram@vim.org>                           *
"       (modified by David Ne\v{c}as (Yeti) <yeti@physics.muni.cz>)   *
" --------------------------------------------------------------------*

" ---------------------------------------------------------------------
" Last Change: Tue Aug 12 09:05:36 EDT 2003
" Version: ('VIM Online' versioning scheme) "1.3"
"     internal version: 1.51
" ---------------------------------------------------------------------

"	 Usage:  The following variables can be used to configure the script's 
"            output. 'html_use_css' should nearly always be defined, for
"            example in .vimrc: let html_use_css = 1
"----------------------------------------------------------------------
"  * html_use_css  -  as always, uses CSS instead of inline markup.
"  * html_output_xhtml - try to output correct xhtml instead of html.
"  * html_number_lines  - also as with "2html.vim", toggles line-numbering.
"  * html_meta_expires  - if this is true and VIM can find /bin/date on the system,
"            use a header meta-http-equiv line to set an expiry (so that browsers
"            or maybe proxy servers will request new document after that date).
"  * html_easygoing_secur  - write out the complete (fully-qualified) path to the
"            source file in a comment near the top of the HTML head section. By
"            default it no longer does this but merely writes the basename.
"  * html_no_display_credit  - do NOT write an inconspicuous string at the bottom
"            of the page, like:
"    code syntax highlighting by GVIM, using the "[color scheme name]" theme.
"-----------------------------------------------------------------------


let s:sourcefilename = substitute(substitute(expand("%:p"),'\\','/','g'),'\.html$','','')
let s:Using_xhtml = 0
" Setup what flavor of DTD we are doing.
if (exists("html_output_xhtml") && g:html_output_xhtml != 0)
  let s:Using_xhtml = 1
endif
" Number lines when explicitly requested or when `number' is set
if exists("html_number_lines")
  let s:numblines = html_number_lines
else
  let s:numblines = &number
endif

" When not in gui we can only guess the colors.
if has("gui_running")
 let s:whatterm = "gui"
else
  let s:whatterm = "cterm"
  if &t_Co == 8
    let s:cterm_color0  = "#808080"
    let s:cterm_color1  = "#ff6060"
    let s:cterm_color2  = "#00ff00"
    let s:cterm_color3  = "#ffff00"
    let s:cterm_color4  = "#8080ff"
    let s:cterm_color5  = "#ff40ff"
    let s:cterm_color6  = "#00ffff"
    let s:cterm_color7  = "#ffffff"
  else
    let s:cterm_color0  = "#000000"
    let s:cterm_color1  = "#c00000"
    let s:cterm_color2  = "#008000"
    let s:cterm_color3  = "#804000"
    let s:cterm_color4  = "#0000c0"
    let s:cterm_color5  = "#c000c0"
    let s:cterm_color6  = "#008080"
    let s:cterm_color7  = "#c0c0c0"
    let s:cterm_color8  = "#808080"
    let s:cterm_color9  = "#ff6060"
    let s:cterm_color10 = "#00ff00"
    let s:cterm_color11 = "#ffff00"
    let s:cterm_color12 = "#8080ff"
    let s:cterm_color13 = "#ff40ff"
    let s:cterm_color14 = "#00ffff"
    let s:cterm_color15 = "#ffffff"
  endif
endif

" Return good color specification: in GUI no transformation is done, in
" terminal return RGB values of known colors and empty string on unknown
if s:whatterm == "gui"
" Soren Andersen's new function:
  function! WhatGuiFonts()
      if strlen(&guifont)
   let nind = ',\n           '
   let fontsizes = substitute(&guifont,'\(\i\{4,}\):h\(\d\+\),\=','\2pt\1 '     ,'g')
   let guifontss = substitute(fontsizes,'\(\d\{1,2}pt\)\(\S*\)\s','\1 \"\2\" , ','g')
   let guifonts = substitute( substitute(guifontss, '_',' ','g'), ',\s*',  nind ,'g')
    return guifonts
      else
  let nofontswarningmsg = '/* no font names were provided, please check your GVIM configuration! */'
" The following 'font name', 'Petunia300Quacker', is imaginary. It is needed
" merely for syntactical purposes. Since you'll always have carefully defined
" the *guifont* in your vimrc, this kludge won't ever be invoked, right?
    execute "return \n  " . nofontswarningmsg . "\n \"9pt Petunia300Quacker\""
      endif
  endfun

  function! s:HtmlColor(color)
    return a:color
  endfun
else
  function! s:HtmlColor(color)
    if exists("s:cterm_color" . a:color)
      execute "return s:cterm_color" . a:color
    else
      return ""
    endif
  endfun
endif

if !exists("html_use_css")
  " Return opening HTML tag for given highlight id
  function! s:HtmlOpening(id)
    let a = ""
    if synIDattr(a:id, "inverse")
      " For inverse, we always must set both colors (and exchange them)
      let x = s:HtmlColor(synIDattr(a:id, "fg#", s:whatterm))
      let a = a . '<span style="background-color: ' . ( x != "" ? x : s:fgc ) . '">'
      let x = s:HtmlColor(synIDattr(a:id, "bg#", s:whatterm))
      let a = a . '<font color="' . ( x != "" ? x : s:bgc ) . '">'
    else
      let x = s:HtmlColor(synIDattr(a:id, "bg#", s:whatterm))
      if x != "" | let a = a . '<span style="background-color: ' . x . '">' | endif
      let x = s:HtmlColor(synIDattr(a:id, "fg#", s:whatterm))
      if x != "" | let a = a . '<font color="' . x . '">' | endif
    endif
    if synIDattr(a:id, "bold") | let a = a . "<b>" | endif
    if synIDattr(a:id, "italic") | let a = a . "<i>" | endif
    if synIDattr(a:id, "underline") | let a = a . "<u>" | endif
    return a
  endfun

  " Return closing HTML tag for given highlight id
  function s:HtmlClosing(id)
    let a = ""
    if synIDattr(a:id, "underline") | let a = a . "</u>" | endif
    if synIDattr(a:id, "italic") | let a = a . "</i>" | endif
    if synIDattr(a:id, "bold") | let a = a . "</b>" | endif
    if synIDattr(a:id, "inverse")
      let a = a . '</font></span>'
    else
      let x = s:HtmlColor(synIDattr(a:id, "fg#", s:whatterm))
      if x != "" | let a = a . '</font>' | endif
      let x = s:HtmlColor(synIDattr(a:id, "bg#", s:whatterm))
      if x != "" | let a = a . '</span>' | endif
    endif
    return a
  endfun
endif

" Return CSS style describing given highlight id (can be empty)
function! s:CSS1(id)
  let a = ""
  if synIDattr(a:id, "inverse")
    " For inverse, we always must set both colors (and exchange them)
    let x = s:HtmlColor(synIDattr(a:id, "bg#", s:whatterm))
    let a = a . "color: " . ( x != "" ? x : s:bgc ) . "; "
    let x = s:HtmlColor(synIDattr(a:id, "fg#", s:whatterm))
    let a = a . "background-color: " . ( x != "" ? x : s:fgc ) . "; "
  else
    let x = s:HtmlColor(synIDattr(a:id, "fg#", s:whatterm))
    if x != "" | let a = a . "color: " . x . "; " | endif
    let x = s:HtmlColor(synIDattr(a:id, "bg#", s:whatterm))
    if x != "" | let a = a . "background-color: " . x . "; " | endif
  endif
  if synIDattr(a:id, "bold") | let a = a . "font-weight: bold; " | endif
  if synIDattr(a:id, "italic") | let a = a . "font-style: italic; " | endif
  if synIDattr(a:id, "underline") | let a = a . "text-decoration: underline; " | endif
  return a
endfun

" Set some options to make it work faster.
" Expand tabs in original buffer to get 'tabstop' correctly used.
" Don't report changes for :substitute, there will be many of them.
let s:old_title = &title
let s:old_icon = &icon
let s:old_et = &l:et
let s:old_report = &report
set notitle noicon
setlocal et
set report=1000000

" Split window to create a buffer with the HTML file.
if expand("%") == ""
  new Untitled.html
else
  new %.html
endif
set modifiable
%d
let s:old_paste = &paste
set paste

" The DTD
if (s:Using_xhtml)
  exe "normal a<?xml version=\"1.0\"\e"
  if &fileencoding != ""
	  exe "normal a encoding=\"" . &fileencoding . "\"\e"
  elseif &encoding != ""
	  exe "normal a encoding=\"" . &encoding . "\"\e"
  endif
  exe "normal a?>\n\e"
	exe "normal a<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\"\n    \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">\n\e"
else
  exe "normal a<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\"\n    \"http://www.w3.org/TR/html4/strict.dtd\">\n\e"
endif

" HTML header, with the title and generator ;-). Left free space for the CSS,
" to be filled at the end.
exe "normal a<html>\n<head>\n\e"

" Set the expiry date in the future based on a variable existing to tell how
" far forward to set it. But it's considered FAR BETTER to do this on the server):
if ( exists('html_meta_expires') && executable('/bin/date') )
 let s:futurexpire = substitute(system('date -uR -d ' . "'+" . html_meta_expires ." day'")
\ ,"\n",'','')
 if strlen(s:futurexpire)
   exe "normal a<meta http-equiv=" . '"expires" content="'. s:futurexpire .'">'. "\n\e"
 endif
endif

exe "normal a<title>" . substitute(expand("%:t"),'\.html$','','') . "</title>\n\e"

" WARNING. The following is my addition [perlspinr] to this plugin. What it
" can do (but no longer does by default) might be considered a SECURITY
" CONCERN by some people: it can write a fully-specified (absolute) file
" path of the source file to a comment in the header portion of the HTML.
" Anyone with the interest in looking at the source of the HTML file would
" be able to see a little glimpse of the owner's filesystem layout. DISABLE
" THIS FEATURE if this is unacceptable by making sure that
" html_easygoing_secur is undefined or == 0.
  if expand('%:t') != 'Untitled.html'
	if (exists('html_easygoing_secur') && html_easygoing_secur > 0)
     exe "normal a<!--   absolute location: " . s:sourcefilename . "   -->\n\e"
    else
	 exe "normal a<!--   source filename: " .expand("%:t:s,\.html$,,"). "   -->\n\e"
    end
	exe "normal a<!--   " . strftime('%d %b %Y %X %Z', getftime(s:sourcefilename)) .
\   "     filesize: " . getfsize(s:sourcefilename) . " Bytes.   -->\n\e"
  endif

" Record of the colorscheme / theme used when this conversion was made.
exe "normal a<!--   colorscheme name: \"" . g:colors_name . "\"   -->\n\e"
" Who are we? We are VIM! ... Better than being BORG I think ;-)
exe "normal a<meta name=\"Generator\" content=\"Vim/" . version/100 . "." . version %100 .
\   " - code2html.vim\">\n\e"

if (s:Using_xhtml)
  exe "normal a<meta http-equiv=\"Content-Type\" content=\"application/xml+xhtml\e"
  if &fileencoding != ""
	exe "normal a;charset=" . &fileencoding . "\e"
  elseif &encoding != ""
	exe "normal a;charset=" . &encoding . "\e"
  endif
  exe "normal a\"/>\n\e"
endif


" Start the CSS STYLE defs block.
if exists("html_use_css")
  exe "normal a<style type=\"text/css\">\n<!--\n#main_code { margin: -9 3 0 1; }\n"
 " Only do the following if html_no_display_credit is not defined.
   if ! exists('html_no_display_credit')
	 exe "normal a.credits {font: smaller \"avant-garde\", \"verdana\", " .
\     "\n           \"helvetica\", \"arial\", sans-serif;" .
\     "\n         padding:0.4ex 2ex; background-color:#3A1E24; color:#CCCC99;}\n\e"
   endif
  let s:stylesstart_at = line(".")
" Close the CSS style definitions block.
  exe "normal a\n -->\n</style>\n\e"
endif

" Now that we have our HEAD on straight...
exe "normal a</head>\n\n\n<body>\n\n<div id=\"main_code\">\n<pre>\n\e"
" Go get'em tiger!  (... sheeesh, I really need some sleep)
exe "normal \<C-W>p"

" List of all id's
let s:idlist = ","

" Loop over all lines in the original text
let s:end = line("$")
let s:lnum = 1

while s:lnum <= s:end
  " Get the current line, with tabs expanded to spaces when needed
  " FIXME: What if it changes syntax highlighting?
  let s:line = getline(s:lnum)
  if stridx(s:line, "\t") >= 0
    exe s:lnum . "retab!"
    let s:did_retab = 1
    let s:line = getline(s:lnum)
  else
    let s:did_retab = 0
  endif
  let s:len = strlen(s:line)
  let s:new = ""
  if s:numblines
    let s:new = '<span class="lnr">'.
\      strpart('        ', 0, strlen(line("$")) - strlen(s:lnum))  s:lnum . '</span>  '
  endif
  " Loop over each character in the line
  let s:col = 1
  while s:col <= s:len
    let s:startcol = s:col " The start column for processing text
    let s:id = synID(s:lnum, s:col, 1)
    let s:col = s:col + 1

	" Speed loop (it's small - that's the trick)
    " Go along till we find a change in synID
    while s:col <= s:len && s:id == synID(s:lnum, s:col, 1) | let s:col = s:col + 1 | endwhile

    " Output the text with the same synID, with class set to c{s:id}
    let s:id = synIDtrans(s:id)
    let s:new = s:new . '<span class="c' . s:id . '">' . 
\ substitute(substitute(substitute(substitute(substitute(strpart(s:line, s:startcol - 1,
\ s:col - s:startcol), '&', '\&amp;', 'g'), '<', '\&lt;', 'g'), '>', '\&gt;', 'g'), '"',
\ '\&quot;', 'g'), "\x0c", '<hr class="page-break">', 'g') . '</span>'
    " Add the class to class list if it's not there yet
    if stridx(s:idlist, "," . s:id . ",") == -1
      let s:idlist = s:idlist . s:id . ","
    endif
    if s:col > s:len
      break
    endif
  endwhile

  if s:did_retab
    undo
  endif

  exe "normal \<C-W>pa" . strtrans(s:new) . "\n\e\<C-W>p"
  let s:lnum = s:lnum + 1
  +
endwhile
" Finish with the last lines, write credit.
exe "normal \<C-W>pa</pre>\n</div>\e"
  if !exists('html_no_display_credit')
	exe "normal a<div class=credits align=right>\ncode syntax highlighting by " .
\   "<a name=vimhome target=\"_top\" href=\"http://vim.sourceforge.net/\">GVIM</a>,\n" .
\   "using the &quot;" .g:colors_name . "&quot; theme. &nbsp;</div>\n\e"
  endif
exe "normal a\n</body>\n</html>\e"

" Now, when we finally know which, we define the colors and styles.
" First return to the STYLE block in document HEAD.
if exists("html_use_css")
  call cursor(s:stylesstart_at,0)
"  exe "normal a\n/* DEFINITION START */\n\e"
endif

" Find the background and foreground colors.
let s:fgc = s:HtmlColor(synIDattr(highlightID("Normal"), "fg#", s:whatterm))
let s:bgc = s:HtmlColor(synIDattr(highlightID("Normal"), "bg#", s:whatterm))
if s:fgc == ""
  let s:fgc = ( &background == "dark" ? "#ffffff" : "#000000" )
endif
if s:bgc == ""
  let s:bgc = ( &background == "dark" ? "#000000" : "#ffffff" )
endif

" Normal/global attributes:
" For Netscape 4, set <body> attributes too, though, strictly speaking, it's
" incorrect.
if exists("html_use_css")
  let s:ourfontstyle = WhatGuiFonts()
  exec "normal a\n\n pre { color: " . s:fgc . "; background-color: " . s:bgc .
\ ";\n     font: " . s:ourfontstyle . ",\n     monospace;"
\ " padding:6;\n }\n\e"
  exec "normal a\n body { padding: 0.2em 0em; margin: 0em; color: "
\ . s:fgc ."; background-color: ". s:bgc ."; }\n\e"
else
  execute '%s:<body>:<body ' . 'bgcolor="' . s:bgc . '" text="' . s:fgc . '">'
endif

" Line numbering attributes
if s:numblines
  if exists("html_use_css")
    execute "normal a\n.lnr { " . s:CSS1(highlightID("LineNr")) . "}\e"
  else
    execute '%s+<span class="lnr">\([^<]*\)</span>+' . s:HtmlOpening(highlightID("LineNr")) .
\   '\1'. s:HtmlClosing(highlightID("LineNr")) . '+g'
  endif
endif

" Gather attributes for all other classes
let s:idlist = strpart(s:idlist, 1)
" Return to the STYLE block in document HEAD.
if exists("html_use_css")
  call cursor(s:stylesstart_at,0)
endif
while s:idlist != ""
  let s:attr = ""
  let s:col = stridx(s:idlist, ",")
  let s:id = strpart(s:idlist, 0, s:col)
  let s:idlist = strpart(s:idlist, s:col + 1)
  let s:attr = s:CSS1(s:id)
  " [If the class has some attributes, export the style, otherwise DELETE all
  " its occurences to make the HTML shorter.] <-- NOPE, for some reason this is
  " malfunctioning now, have to comment it out.
  if s:attr != ""
    if exists("html_use_css")
	  let s:padme = ""
	  if strlen(s:id)<2 | let s:padme = " " | endif
      execute "normal A\n.c" . s:id . s:padme " { " . s:attr . "}"
	  let s:padme = ""
    else
      execute '%s+<span class="c' . s:id . '">\([^<]*\)</span>+'.
\     s:HtmlOpening(s:id) .'\1'. s:HtmlClosing(s:id) .'+g'
    endif
  else
"    execute '%s+<span class="c' . s:id . '">\([^<]*\)</span>+\1+g'
  endif
endwhile

" Cleanup (we've already lost last user's pattern match highlighting)
%s:\s\+$::e
if has("extra_search")
  nohlsearch
endif

" Restore old settings
let &report = s:old_report
let &title = s:old_title
let &icon = s:old_icon
let &paste = s:old_paste
exe "normal \<C-W>p"
let &l:et = s:old_et
exe "normal \<C-W>p"

" Save a little bit of memory (Is this worth doing?)
unlet s:old_et s:old_paste s:old_icon s:old_report s:old_title
unlet s:whatterm s:idlist s:lnum s:end s:fgc s:bgc
unlet! s:col s:id s:attr s:len s:line s:new s:did_retab s:numblines
delfunc s:HtmlColor
delfunc s:CSS1
if !exists("html_use_css")
  delfunc s:HtmlOpening
  delfunc s:HtmlClosing
endif
