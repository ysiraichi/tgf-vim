" Vim syntax file
" Vim syntax file
" Language: Pure-Functional Tiger Language
" Latest Revision: 17 December 2015

if exists("b:current_syntax")
  finish
endif

" Keywords
syn keyword tgfTypes int string float answer
syn keyword tgfDef   let in end
syn keyword tgfDecl  array of nil if then else
syn keyword tgfFDecl function var type

" Matches
syn match   tgfBOp   '\V\[&|]' 
syn match   tgfOtOp  '\v(\:\=|\:)'

syn match   tgfInto  '\v\-\>'

syn match   tgfNum   '\v<[1-9]+[0-9]*>'
syn match   tgfNum   '\v<[0-9]+\.[0-9]*>'
syn match   tgfNum   '\V\<0\>'

" Regions
syn region  tgfComnt start="/\*" end="\*/" contains=tgfComnt
syn region  tgfStr   start='"'   end='"'

" Highlight
hi def link tgfTypes Structure
hi def link tgfDecl  Structure
hi def link tgfInto  Special
hi def link tgfDef   Statement
hi def link tgfComnt Comment
hi def link tgfStr   Constant
hi def link tgfNum   Constant
hi def link tgfFDecl Function
hi def link tgfOtOp  Ignore


let b:current_syntax = "pf-tiger"
