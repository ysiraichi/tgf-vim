" indent/tgf.vim

setlocal indentexpr=TgfIndent()
setlocal indentkeys==end,=in,=int,=let,=if,e,=then,O,o,0(,0),0{,0}

function! Regexfy(char)
  if (a:char =~ '\v[\{\}\(\)]')
    return a:char
  else
    return "\\\<" . a:char . "\\\>"
  endif
endfunction

function! IncrementIndent(line)
  return indent(a:line) + &shiftwidth 
endfunction

function! IsNotOver(lst, times)
  let Count   = 1
  let NotOver = 1
  while Count < len(a:lst)
    let NotOver = NotOver && (a:times[a:lst[Count-1]] <= a:times[a:lst[Count]])
    let Count   = Count + 1
  endwhile
  return NotOver
endfunction

function! FindLast(...)
  let pNum   = v:lnum
  let times = {}
  for i in a:000
    let times[i] = 0
  endfor
  while IsNotOver(a:000, times)
    let pNum  = prevnonblank(pNum-1)
    let pLine = getline(pNum)
    echom "FindLast(pLine): " . pLine
    for i in a:000
      if pLine =~ Regexfy(i)
        let times[i] = times[i] + 1
        echom "times[" . i . "] : " . times[i]
      endif
    endfor
    if pNum == 1
      break
    endif
  endwhile
  return pNum
endfunction

function! TgfIndent()
  let thisLine = getline(v:lnum)

  let synCount = {}
  let synCount['let'] = 0
  let synCount['in'] = 0
  let synCount['end'] = 0
  let synCount['if'] = 0
  let synCount['then'] = 0
  let synCount['else'] = 0
  let synCount['var'] = 0
  let synCount['function'] = 0
  let synCount['type'] = 0
  let synCount['{'] = 0
  let synCount['}'] = 0
  let synCount['('] = 0
  let synCount[')'] = 0

  let pNum  = prevnonblank(v:lnum - 1)
  let pLine = getline(pNum)

  echom "tL: " . thisLine
  echom "pL: " . pLine

  " If the current line has any keywords
  if (thisLine !~ '\<let\>' && (thisLine =~ '\<in\>' || thisLine =~ '\<end\>'))
    let lastN = FindLast('let', 'in', 'end')
    return indent(lastN)
  endif

  if (thisLine !~ '\<if\>' && thisLine =~ '\<else\>')
    let lastN = FindLast('if', 'then', 'else')
    return indent(lastN)
  elseif (thisLine !~ '\<if\>' && thisLine =~ '\<then\>')
    return IncrementIndent(FindLast('if', 'then'))
  endif

  if (thisLine =~ '\v^\ *[\{\(]\ *$')
    return indent(pNum)
  endif
  if (thisLine =~ '\v^\ *\}\ *$')
    let lastN = indent(FindLast('{', '}'))
    echom "lN: " . lastN
    return lastN
  endif
  if (thisLine =~ '\v^\ *\)\ *$')
    return indent(FindLast('(', ')'))
  endif
    
  " If the parent line has this specific keywords
  if (pLine =~ '\<function\>' && pLine =~ '\v\=\ *$') 
    return IncrementIndent(pNum)
  endif
  if (pLine =~ '\<var\>' && pLine =~ '\v\:\=\ *$') 
    return IncrementIndent(pNum)
  endif
  if (pLine =~ '\<type\>' && pLine =~ '\v\=\ *$')
    return IncrementIndent(pNum)
  endif
  if (pLine =~ '\<else\>' && pLine =~ '\Velse\ \*\$')
    return IncrementIndent(pNum)
  endif
  if (pLine =~ '{' && pLine !~ '}') || (pLine =~ '(' && pLine !~ ')')
    return IncrementIndent(pNum)
  endif

  " Find where we are
  while pNum > 0 
    for i in keys(synCount)
      if pLine =~ Regexfy(i)
        let synCount[i] = synCount[i] + 1
      endif
    endfor

    if (synCount['then'] > synCount['else']) || (synCount['if'] > synCount['then'])
      return IncrementIndent(pNum)
    endif

    if (synCount['in'] > synCount['end']) || (synCount['let'] > synCount['in'])
      return IncrementIndent(pNum)
    endif

    if (synCount['('] > synCount[')']) || (synCount['{'] > synCount['}'])
      return IncrementIndent(pNum)
    endif

    if pNum == 1
      let pNum = 0
    else
      let pNum  = prevnonblank(pNum - 1)
      let pLine = getline(pNum)
    endif

  endwhile

  return 0

endfunction
