" Vim syntax file
" Language:	DBL (Synergy/DE)
" Maintainer:	Chad Joan <cjoan@gmail.com>
" Last Change:	2014 Mar 07
"
" Original credits:
" Language:	DIBOL
" Maintainer:	Nicolas DUPEUX <nicolas@dupeux.net>
" Last Change:	2001 Apr 28

" Quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" Remove any old syntax stuff hanging around
syn clear

" ignore case
syn case ignore

syn cluster     dblAllSpace  contains=NONE
syn cluster     dblLiterals  contains=NONE
syn cluster     dblFuncElems contains=NONE

" comment
syn match       dblComment "[;].*$"
syn cluster     dblAllSpace add=dblComment

" When wanted, highlight trailing white space
if exists("dbl_space_errors")
  if !exists("dbl_no_trail_space_error")
    syn match   dblSpaceError     display excludenl "\s\+$"
  endif
  if !exists("dbl_no_tab_space_error")
    syn match   dblSpaceError     display " \+\t"me=e-1
  endif
endif
syn cluster     dblAllSpace add=dblSpaceError

" Preprocessor conditionals.
syn region      dblPreCondit      start="^\s*\.\s*\(if\|ifdef\|ifndef\)\>" skip="\\$" end="$" keepend contains=dblComment,dblSpaceError
syn match       dblPreConditMatch display "^\s*\.\s*\(else\|endc\)\>"
syn cluster     dblAllSpace add=dblPreCondit,dblPreConditMatch

" Multiline comments using ".if 0"
if !exists("dbl_no_if0")
  syn cluster   dblppOutInGroup  contains=dblppInIf,dblppInElse,dblppInElse2,dblppOutIf,dblppOutIf2,dblppOutElse,dblppInSkip,dblppOutSkip
  syn region    dblppOutWrapper  start="^\s*\.\s*if\s\+0\+\s*\($\|;\)" end=".\@=\|$" contains=dblppOutIf,dblppOutElse
  syntax sync match dblppOutWrapper groupthere dblppOutWrapper "^\s*\.\s*if\s\+0"
  syn cluster   dblAllSpace add=dblppOutInGroup,dblppOutWrapper
  syn region    dblppOutIf       contained start="0\+" matchgroup=dblppOutWrapper end="^\s*\.\s*endc\>" contains=dblppOutIf2,dblppOutElse
  if !exists("dbl_no_if0_fold")
    syn region  dblppOutIf2      contained matchgroup=dblppOutWrapper start="0\+" end="^\s*\.\s*\(else\>\|endc\>\)"me=s-1 contains=dblSpaceError,dblppOutSkip
  else
    syn region  dblppOutIf2      contained matchgroup=dblppOutWrapper start="0\+" end="^\s*\.\s*\(else\>\|endc\>\)"me=s-1 contains=dblSpaceError,dblppOutSkip fold
  endif
  syn region    dblppOutElse     contained matchgroup=dblppOutWrapper start="^\s*\.\s*\(else\)" end="^\s*\.\s*endc\>"me=s-1 contains=TOP,dblPreCondit
  syn region    dblppInWrapper   start="^\s*\.\s*if\s\+0*[1-9]\d*\s*\($\|;\)" end=".\@=\|$" contains=dblppInIf,dblppInElse
  syn region    dblppInIf        contained matchgroup=dblppInWrapper start="\d\+" end="^\s*\.\s*endc\>" contains=TOP,dblPreCondit
  if !exists("dbl_no_if0_fold")
    syn region  dblppInElse      contained start="^\s*\.\s*\(else\>\)" end=".\@=\|$" containedin=dblppInIf contains=dblppInElse2 fold
  else
    syn region  dblppInElse      contained start="^\s*\.\s*\(else\>\)" end=".\@=\|$" containedin=dblppInIf contains=dblppInElse2
  endif
  syn region    dblppInElse2     contained matchgroup=dblppInWrapper start="^\s*\.\s*\(else\)\([^/]\|/[^/*]\)*" end="^\s*\.\s*endc\>"me=s-1 contains=dblSpaceError,dblppOutSkip
  syn region    dblppOutSkip     contained start="^\s*\.\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\.\s*endc\>" contains=dblSpaceError,dblppOutSkip
  syn region    dblppInSkip      contained matchgroup=dblppInWrapper start="^\s*\.\s*\(if\s\+\(\d\+\s*\($\|;\)\)\@!\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\.\s*endc\>" containedin=dblppOutElse,dblppInIf,dblppInSkip contains=TOP,dblPreProc
endif

" Preprocessor
syn match       dblIncludeStruct  display contained ~\s*\(\(["].\{-}["]\)\|\(['].\{-}[']\)\|=\|\(,\=\s*\w\+\)\)\+~ contains=TOP,dblVarDeclScope,dblGroupScope
"syn match       dblIncludeStruct  display contained ~\s*\(\(["].\{-}["]\)\|\(['].\{-}[']\)\|=\|\(,\=\s*\w\+\)\)\+~ contains=dblString,dblStructure,dblStorageClass,\(dblVarDeclScope\)/\@!,\(dblGroupScope\)/\@!
syn match       dblIncludeEnum    display contained "\s*,\s*[a-zA-Z]+\s+ENUM" contains=dblStorageClass,dblStructure
syn match       dblIncludeLib     display contained "\s*LIBRARY\s*" nextgroup=dblString
syn match       dblIncludeRepo    display contained "\s*REPOSITORY" nextgroup=dblIncludeEnum,dblIncludeStruct
syn match       dblIncluded       display contained ~\s*\(["].\{-}["]\|['].\{-}[']\)~ contains=dblString nextgroup=dblIncludeRepo,dblIncludeLib
syn match       dblInclude        display "^\s*\([.]\)\s*include\>" nextgroup=dblIncluded
syn cluster     dblAllSpace add=dblInclude

syn region      dblDefine         start="^\s*[.]\s*\(define\|undefine\)\>" skip="$\s*&" end="$" keepend
syn cluster     dblAllSpace add=dblDefine

" Storage classes.
syn keyword dblStorageClass in out inout req required opt optional static ref
syn keyword dblStorageClass private public protected abstract stack const
syn keyword dblStorageClass sealed override external endexternal
syn cluster dblFuncElems add=dblStorageClass

" identifier
syn match   dblIdentifier "\<[a-zA-Z_][a-zA-Z0-9$_]*\>" contained
syn match   dblLabel      "^\s*[a-zA-Z_][a-zA-Z0-9$_]*\s*,\s*\(.*$\)\@=" contains=TOP

syn cluster dblLiterals add=dblIdentifier

" string
syn region  dblString start=+"+ end=+"+
syn region  dblString start=+'+ end=+'+
syn cluster dblLiterals add=dblString

" number
syn match   dblNumber "\<[0-9]\+\>"
syn cluster dblLiterals add=dblNumber

" boolean
syn match   dblBoolean "[%^]\s*\(TRUE\|FALSE\|NULL\)\>"
syn cluster dblLiterals add=dblBoolean

" conditional
syn keyword dblConditional if then else
syn keyword dblConditional using select endusing range

" repeat
syn keyword dblRepeat repeat for from thru foreach while do forever until

" Statements... DBL has A LOT of them.
syn keyword dblStatement display accept delete detach clear init incr decr
syn keyword dblStatement open close read reads write writes store get gets find
syn keyword dblStatement flush forms lpque purge put puts unlock
syn keyword dblStatement merge sort locase upcase nop sleep send recv 
syn keyword dblStatement addhandler removehandler raiseevent event
syn keyword dblStatement begin end lambda
syn keyword dblStatement stop xreturn freturn mreturn
syn keyword dblJump      call goto return exit exitloop exittry nextloop stop
syn match   dblJump      "\<go\s*to\>"
syn match   dblJump      "\<exit\s*\(loop\|try\)\>"
syn match   dblJump      "\<next\s*loop\>"
syn keyword dblException try catch finally endtry throw
syn match   dblException "\<\(on\|off\)\s*error\>"

" The stench is enormous: it is wise to give XCALL it's own group, since this can highlight failure points.
syn keyword dblXCall     xcall

" Other misc keywords.
syn keyword dblKeyword  import new

" operators
syn keyword dblOperator + - * / += -= *= /=
syn match   dblOperator "\(&\|&&\|||\|=\|==\|!=\|<\|<=\|>\|>=\|[()]\)"
syn match   dblOperator "\.\(EQ\|NE\|LT\|LE\|GT\|GE\)\."
syn match   dblOperator "\.\(EQS\|NES\|LTS\|LES\|GTS\|GES\)\."

" Function tags
syn keyword dblFunctionTag function method subroutine main
syn cluster dblFuncElems add=dblFunctionTag

" Built-in types.
syn match   dblTypeNum           "[0-9]\+" contained
syn match   dblTypeArrayInfer    "[*#]" contained
syn match   dblTypeSizeExpr      "[%^]\s*\h[a-zA-Z_$0-9]*\s*(.\{-})" contained
syn match   dblTypeBuiltinConst  "[adip][0-9]\+\>" contained contains=dblTypeNum
syn match   dblTypeBuiltinSzExpr "[adip][%^]\@=" contained nextgroup=dblTypeSizeExpr
syn cluster dblTypeBuiltin       contains=dblTypeBuiltinConst,dblTypeBuiltinSzExpr
syn match   dblTypeStar          "[*]" contained
syn match   dblTypeUser          "\h[a-zA-Z_$0-9.]*[%^]\@!\>" contained contains=\(dblTypeBuiltin.*\)/\@! " The [%^]\@! is to prevent this rule from interfering with dblTypeBuiltinSzExpr.
syn cluster dblTypeRoot          contains=@dblTypeBuiltin,dblTypeUser,dblTypeStar
syn match   dblType              "[@]\=\<\(\d\+[@]\=\)\=" nextgroup=@dblTypeRoot contains=dblTypeNum contained
"syn match   dblType              "[@]\=\<" nextgroup=@dblTypeRoot contained
syn match   dblType              "[@][*]" contained
syn match   dblType              "[@]\=\[.*\][@]\=" nextgroup=@dblTypeRoot contains=dblTypeNum,dblTypeSizeExpr,dblIdentifier,dblTypeArrayInfer contained

" Grammar.
syn keyword dblData        data contained
"syn match   dblVarDeclEnd   ".*$" contains=dblType contained transparent
syn match   dblVarDecl     "^\s*\([a-z]\+\s\+\)\{-}\(\h[a-zA-Z_$0-9]*\s*\)\=,\s*\(;\|$\)\@!" contained nextgroup=dblType contains=dblData/\@!,dblIdentifier,dblStorageClass,@dblFuncElems
syn match   dblDataVarDecl "^\s*data\s\+\h[a-zA-Z_$0-9]*\s*,\s*\(;\|$\)\@!" nextgroup=dblType contains=dblData,dblIdentifier

" Writing a basic DBL grammar in vimscript seems very hard... things like
" records can end in statements besides "endrecord", and comments and .if 0
" can all derail matches.  Consider these things before getting ambitious.
syn keyword dblStructure     record    common    literal    group    enum    global    contained
syn keyword dblStructure     endrecord endcommon endliteral endgroup endenum endglobal endparams
syn keyword dblStructure     namespace endnamespace
syn keyword dblStructure     property endproperty " Properties contain methods and are in class-context, so the region-based highlighting should be already-handled by the class/method/proc rules.
syn keyword dblStructure     extends
syn keyword dblStatement     endsubroutine endmain endfunction endmethod endelegate " Just-incase these are missed by the region...
syn cluster dblVarDeclSpace  contains=dblVarDecl,@dblAllSpace,@dblLiterals
syn region  dblVarDeclScope  matchgroup=dblStructure start="\<structure\>" end="\<endstructure\>" contains=@dblVarDeclSpace,dblVarDeclScope fold keepend
syn region  dblClassScope    matchgroup=dblStructure start="\<class\>"     end="\<endclass\>" contains=@dblVarDeclSpace,dblVarDeclScope,dblFuncScope,dblStructure fold keepend
syn region  dblFuncScope     start="^[^;]*\<\(method\|function\|subroutine\|delegate\)\>"   end="\<\(endsubroutine\|endfunction\|endmethod\|enddelegate\)\>" contains=@dblVarDeclSpace,@dblFuncElems,dblVarDeclScope,dblStructure,dblProcScope fold keepend
syn region  dblVarDeclScope  matchgroup=dblStructure start="\<global\>"    end="\(\<\(record\|common\|global\|literal\|proc\|endglobal\)\>\)\@="  contains=@dblVarDeclSpace,dblGroupScope fold
syn region  dblVarDeclScope  matchgroup=dblStructure start="\<common\>"    end="\(\<\(record\|common\|global\|literal\|proc\|endcommon\)\>\)\@="  contains=@dblVarDeclSpace,dblGroupScope fold
syn region  dblVarDeclScope  matchgroup=dblStructure start="\<record\>"    end="\(\<\(record\|common\|global\|literal\|proc\|endrecord\)\>\)\@="  contains=@dblVarDeclSpace,dblGroupScope fold
syn region  dblVarDeclScope  matchgroup=dblStructure start="\<literal\>"   end="\(\<\(record\|common\|global\|literal\|proc\|endliteral\)\>\)\@=" contains=@dblVarDeclSpace,dblGroupScope fold
syn region  dblGroupScope    matchgroup=dblStructure start="\<group\>"     end="\<endgroup\>" contains=@dblVarDeclSpace,dblVarDeclScope,dblGroupScope fold keepend
syn region  dblProcScope     matchgroup=dblStatement start="\<proc\>"      end="\<\(endsubroutine\|endmain\|endfunction\|endmethod\)\>"   contains=TOP,dblVarDecl fold keepend

syntax sync match dblClassScope   groupthere dblClassScope   "\<class\>"
syntax sync match dblVarDeclScope groupthere dblVarDeclScope "\<\(structure\|record\|common\|literal\)\>"
syntax sync match dblGroupScope   groupthere dblGroupScope   "\<group\>"
syntax sync match dblProcScope    groupthere dblProcScope    "\<proc\>"
"syntax sync match dblSync groupthere NONE "\<\(class\|structure\|record\|common\|literal\|group\|proc\)\>"

" Plug it all in.
hi def link dblVarDeclScope     Normal
hi def link dblProcScope        Normal
hi def link dblClassScope       Normal
hi def link dblFuncScope        Normal
hi def link dblGroupScope       Normal

hi def link dblKeyword          Keyword

hi def link dblIdentifier       Normal " Setting this to "Identifier" gets distracting very quickly.
hi def link dblLabel            Label
hi def link dblString           String
hi def link dblNumber           Number
hi def link dblBoolean          Boolean
hi def link dblOperator         Operator

hi def link dblData             dblStatement
hi def link dblStatement        Statement
hi def link dblConditional      Conditional
hi def link dblRepeat           Repeat
hi def link dblException        Exception
hi def link dblJump             Label

" DBL doesn't have a Character element, so we can use this to make XCALLs
" be more distinctive.  This is good, since XCALLs can hide nasty side-effects
" in old code very easily.
hi def link dblXCall            Character

" These aren't really typedefs.
" But... DBL doesn't have typedefs.
" So we can use the typedef class to get more highlighting colors.
hi def link dblFunctionTag      Typedef

hi def link dblTypeBuiltinConst dblType
hi def link dblTypeBuiltinSzExpr dblType
hi def link dblTypeSzExpr       dblType
hi def link dblTypeUser         dblType
hi def link dblTypeStar         dblType
hi def link dblType             Type
hi def link dblTypeNum          dblNumber
hi def link dblTypeSizeExpr     dblNumber
hi def link dblTypeArrayInfer   dblNumber
hi def link dblStructureEnd     Structure
hi def link dblStructure        Structure
hi def link dblStorageClass     StorageClass

hi def link dblSpaceError       dblError 
hi def link dblInclude          Include
hi def link dblIncludeLib       Keyword
hi def link dblIncludeRepo      Keyword
hi def link dblIncludeEnum      Keyword
hi def link dblIncludeStruct    Keyword
hi def link dblPreProc          PreProc
hi def link dblDefine           Define
hi def link dblIncluded         cString
hi def link dblError            Error
hi def link dblStatement        Statement
hi def link dblppInWrapper      dblppOutWrapper
hi def link dblppOutWrapper     dblPreCondit
hi def link dblPreConditMatch   dblPreCondit
hi def link dblPreCondit        PreCondit
hi def link dblppOutSkip        dblppOutIf2
hi def link dblppInElse2        dblppOutIf2
hi def link dblppOutIf2         dblppOut2     " Old syntax group for #if 0 body
hi def link dblppOut2           dblppOut      " Old syntax group for #if of #if 0
hi def link dblppOut            Comment
hi def link dblComment          Comment


" Set the current syntax to be known as dbl
let b:current_syntax = "dbl"

