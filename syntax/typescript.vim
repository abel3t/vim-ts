if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'typescript'
endif

" Dollar sign is permitted anywhere in an identifier
if (v:version > 704 || v:version == 704 && has('patch1142')) && main_syntax == 'typescript'
  syntax iskeyword @,48-57,_,192-255,$
else
  setlocal iskeyword+=$
endif

syntax sync fromstart
syntax case match

" Basic tokens
syntax keyword tsDebugger debugger
syntax match   tsSemicolon +;+
syntax match   tsComma +,+ contained
syntax match   tsAssignmentColon +:+ contained skipwhite skipempty nextgroup=@tsExpression
syntax match   tsAssignmentEqual +=+ contained skipwhite skipempty nextgroup=@tsExpression
syntax match   tsPrivateIdentifier +#+ contained nextgroup=tsIdentifierProp,tsFunctionCall
syntax match   tsDot +\.+ contained skipwhite skipempty nextgroup=tsPrivateIdentifier,tsIdentifierProp,tsFunctionCall
syntax match   tsSpread +\.\.\.+ contained skipwhite skipempty nextgroup=@tsExpression
syntax match   tsParensError +[)}\]]+

" Code blocks
syntax region  tsBlock matchgroup=tsBraces start=+{+ end=+}+ contains=@tsTop extend fold
syntax region  tsParen matchgroup=tsParens start=+(+ end=+)+ contains=@tsExpression,tsComma,tsSpread extend fold skipwhite skipempty nextgroup=tsArrow,tsFunctionCallArgs,tsAccessor,tsDot,@tsOperators,tsFlowColon

" Operators
" REFERENCE: https://developer.mozilla.org/en-US/docs/Web/typescript/Guide/Expressions_and_Operators
syntax keyword tsUnaryOperator delete void typeof skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsRelationalOperator in instanceof contained skipwhite skipempty nextgroup=@tsExpression
" REFERENCE: https://github.com/tc39/proposal-bind-operator
syntax match   tsBindOperator +::+ contained skipwhite skipempty nextgroup=@tsExpression
" Arithmetic operators (**, *, %, /)
syntax match   tsOperator +\%(\*\*\|[*%]\|/\%([/*]\)\@!\)+ contained skipwhite skipempty nextgroup=@tsExpression
" Arithmetic operators (+, ++, -, --)
syntax match   tsTopOperator +\%([+-]\{1,2}\)+ skipwhite skipempty nextgroup=@tsExpression
" Comparison operators (==, !=, ===, !==, >, >=, <, <=)
syntax match   tsOperator +\%([=!]==\?\|[<>]=\?\)+ contained skipwhite skipempty nextgroup=@tsExpression
" Bitwise operators (&, |, ^, <<, >>, >>>)
syntax match   tsOperator +\%([&^|]\|<<\|>>>\?\)+ contained skipwhite skipempty nextgroup=@tsExpression
" Bitwise operators (~)
syntax match   tsTopOperator +[~]+ skipwhite skipempty nextgroup=@tsExpression
" Logical operators (&&, ||)
syntax match   tsOperator +[|&]\{2}+ contained skipwhite skipempty nextgroup=@tsExpression
" Logical operators (!)
syntax match   tsTopOperator +!+ skipwhite skipempty nextgroup=@tsExpression
" Assignment operators (*=, /=, %=, +=, -=, <<=, >>=, >>>=, &=, ^=, |=, **=)
syntax match   tsOperator +\%([-/%+&|^]\|<<\|>>>\?\|\*\*\?\)=+ contained skipwhite skipempty nextgroup=@tsExpression
" Ternary expression
syntax region  tsTernary matchgroup=tsTernaryOperator start=+?+ end=+:+ contained contains=@tsExpression skipwhite skipempty nextgroup=@tsExpression
" Optional chaining operator: https://github.com/TC39/proposal-optional-chaining
syntax match   tsOptionalOperator +?\.+ contained skipwhite skipempty nextgroup=tsIdentifierProp,tsAccessor,tsFunctionCall,tsFunctionCallArgs 
" Nullish coalescing operator: https://github.com/tc39/proposal-nullish-coalescing
syntax match   tsOperator +??+ contained skipwhite skipwhite nextgroup=@tsExpression

syntax cluster tsTopOperators contains=tsTopOperator,tsUnaryOperator
syntax cluster tsOperators contains=tsRelationalOperator,tsTernary,tsOperator,tsTopOperator,tsBindOperator

" Modules
" REFERENCE:
"   - https://developer.mozilla.org/en-US/docs/Web/typescript/Reference/Statements/import
"   - https://developer.mozilla.org/en-US/docs/Web/typescript/Reference/Statements/export
syntax keyword tsImport import skipwhite skipempty nextgroup=tsModuleName,tsModuleAsterisk,tsModuleBlock,tsString,tsDecoratorName,tsFlowModuleType,tsFlowModuleTypeof
syntax keyword tsExport export skipwhite skipempty nextgroup=tsVariableType,tsFunction,tsClass,tsDecorator,tsModuleBlock,tsModuleDefault,tsModuleAsterisk
syntax keyword tsFrom from contained skipwhite skipempty nextgroup=tsString
syntax keyword tsModuleDefault default contained skipwhite skipempty nextgroup=@tsExpression
syntax match   tsModuleAsterisk +\*+ contained skipwhite skipempty nextgroup=tsModuleAs,tsFrom
syntax keyword tsModuleAs as contained skipwhite skipempty nextgroup=tsModuleName
syntax region  tsModuleBlock matchgroup=tsModuleBraces start=+{+ end=+}+ contained contains=tsModuleName,tsModuleComma,tsComment,tsDecoratorName skipwhite skipempty nextgroup=tsFrom
syntax match   tsModuleName +\<\K\k*\>+ contained contains=tsModuleDefault skipwhite skipempty nextgroup=tsFrom,tsModuleComma,tsModuleAs
syntax match   tsModuleComma +,+ contained skipwhite skipempty nextgroup=tsModuleBlock,tsModuleName,tsModuleAsterisk

" RegExp
syntax region  tsRegexp matchgroup=tsRegexpSlashes start=+/+ end=+\%([^\\]\%(\\\\\)*\\\)\@<!/+ contains=@tsRegexpTokens,tsRegexpError nextgroup=tsRegexpFlags
syntax match   tsRegexpFlags +[gimsuy]\++ contained
syntax match   tsRegexpChars +.+ contained
syntax match   tsRegexpError +)+ contained

" Escape token
syntax match   tsRegexpEscape +\\+ contained nextgroup=tsRegexpChars
" Or
syntax match   tsRegexpOr +|+ contained
" Quantifier tokens (x*, x+, x?, x{n}, x{n,}, x{n,m}, x*?, x+?, x??, x{n}?, x{n,}?, x{n,m}?)
syntax match   tsRegexpQuantifier +[*?+]\|{\d\+\%(,\d*\)\?}+ contained
" Group back reference (\n)
syntax match   tsRegexpGroupReference +\\[1-9]\d*+ contained
" Match hyphen (-) inside the range. [a-z], [0-9], but don't match [-a] and [a-]
syntax match   tsRegexpRangeHyphen +\[\@1<!-]\@!+ contained
" Match caret (^) at the start of the range. [^a-z], don't match [a-z^]
syntax match   tsRegexpRangeCaret +\[\@1<=\^+ contained
" Match the dot
syntax match   tsRegexpDot +\.+ contained
" Match all the character classes
syntax match   tsRegexpCharClass +\\[bBdDwWsStrnvf0]\|\\c\u\|\\x\x\{2}\|\\u\x\{4}\|\\u{\x\{4,5}}+ contained
" Match the boundaries
syntax match   tsRegexpBoundaries +[$^]\|\\[Bb]+ contained
" Match The unicode range
syntax region  tsRegexpUnicode matchgroup=tsRegexpUnicodeBraces start=+\\p{+ end=+}+ contained contains=tsRegexpUnicodeName
syntax match   tsRegexpUnicodeName +\K\k*+ contained nextgroup=tsRegexpUnicodeEqual
syntax match   tsRegexpUnicodeEqual +=+ contained nextgroup=tsRegexpUnicodeValue
syntax match   tsRegexpUnicodeValue +\K\k*+ contained

" Match the groups. (x), (?<Name>x), (?:x)
" skip=+\\)+ seems not work, so I have to write a complex end pattern
syntax region  tsRegexpGroup matchgroup=tsRegexpParens start=+(?<\K\k*>+ start=+(?:+ start=+(+ end=+\%([^\\]\%(\\\\\)*\\\)\@<!)+ contained contains=@tsRegexpTokens
" Match the range. [a-b]
syntax region  tsRegexpRange matchgroup=tsRegexpBrackets start=+\[+ end=+\%([^\\]\%(\\\\\)*\\\)\@<!]+ contained contains=tsRegexpEscape,tsRegexpChars,tsRegexpCharClass,tsRegexpRangeHyphen,tsRegexpRangeCaret
" Match the assertions. x(?=y), x(?!y), (?<=y)x, (?<!y)x
syntax region  tsRegexpAssertion matchgroup=tsRegexpAssertionParens start=+(?<\?[=!]+ end=+\%([^\\]\%(\\\\\)*\\\)\@<!)+ contained contains=@tsRegexpTokens

syntax cluster tsRegexpTokens contains=tsRegexpChars,tsRegexpGroup,tsRegexpGroupReference,tsRegexpOr,tsRegexpRange,tsRegexpAssertion,tsRegexpBoundaries,tsRegexpQuantifier,tsRegexpEscape,tsRegexpDot,tsRegexpCharClass,tsRegexpUnicode

" Comments
" Comments can be treat as a special expression which produces nothing, so I added it to the expression cluster
syntax keyword tsCommentTodo contained TODO FIXME XXX TBD
syntax region  tsComment start=+//+ end=/$/ contains=tsCommentTodo,@Spell extend keepend
syntax region  tsComment start=+/\*+  end=+\*/+ contains=tsCommentTodo,@Spell,tsDocTags,tsDocInline fold keepend skipwhite skipempty nextgroup=@tsOperators
syntax region  tsHashbangComment start=+^#!+ end=+$+

" Declaration
syntax keyword tsVariableType const let var skipwhite skipempty nextgroup=tsIdentifier,tsObjectDestructuring,tsArrayDestructuring
" Match the top level identifier, e.g., `foo` inside `foo.bar`
syntax match   tsIdentifier +\<\K\k*\>+ contains=@tsGlobals,tsTemplateStringTag skipwhite skipempty nextgroup=tsAssignmentEqual,tsComma,tsArrow,tsAccessor,tsDot,tsOptionalOperator,@tsOperators,tsFlowColon
" Match the prop identifier, e.g., `bar` inside `foo.bar`
syntax match   tsIdentifierProp +\<\K\k*\>+ contained contains=tsTemplateStringTag skipwhite skipempty nextgroup=tsAssignmentEqual,tsComma,tsAccessor,tsDot,tsOptionalOperator,@tsOperators

" Strings
syntax region  tsString start=+\z(["']\)+ skip=+\\\\\|\\\z1\|\\\n+ end=+\z1+ contains=@Spell skipwhite skipempty nextgroup=tsAccessor,tsDot,@tsOperators,tsFlowColon
syntax match   tsTemplateStringTag +\<\K\k*\>\%(\_s*`\)\@=+ skipwhite skipempty nextgroup=tsTemplateString
syntax region  tsTemplateString start=+`+ skip=+\\\\\|\\`\|\\\n+ end=+`+ contains=tsTemplateExpression,@Spell skipwhite skipempty nextgroup=tsAccessor,tsDot,@tsOperators,tsFlowColon
syntax region  tsTemplateExpression matchgroup=tsTemplateBrace start=+\%([^\\]\%(\\\\\)*\)\@<=${+ end=+}+ contained contains=@tsExpression

" Built-in values
" REFERENCE: https://developer.mozilla.org/en-US/docs/Web/typescript/Reference/Global_Objects
syntax keyword tsBuiltinValues undefined null NaN true false Infinity globalThis global contained
syntax keyword tsBuiltinValues window document module exports require console arguments contained

" Built-in objects
syntax keyword tsBuiltinObjects Object Function Boolean Symbol Error EvalError InternalError RangeError ReferenceError SyntaxError TypeError URIError contained
syntax keyword tsBuiltinObjects Number BigInt Math Date String RegExp contained
syntax keyword tsBuiltinObjects Array Int8Array Uint8Array Uint8ClampedArray Int16Array Uint16Array Int32Array Uint32Array Float32Array Float64Array BigInt64Array BigUint64Array contained
syntax keyword tsBuiltinObjects Map Set WeakMap WeakSet contained
syntax keyword tsBuiltinObjects ArrayBuffer SharedArrayBuffer Atomics DataView tsON contained
syntax keyword tsBuiltinObjects Promise Generator GeneratorFunction AsyncFunction Reflect Proxy Intl WebAssembly contained

" Built-in functions
syntax keyword tsBuiltinFunctions eval uneval isFinite isNaN parseFloat parseInt decodeURI decodeURIComponent encodeURI encodeURIComponent escape unescape require contained

" Numbers
" REFERENCE: http://www.ecma-international.org/ecma-262/10.0/index.html#prod-NumericLiteral
syntax match   tsNumber +\c[+-]\?\%(0b[01]\%(_\?[01]\)*\|0o\o\%(_\?\o\)*\|0x\x\%(_\?\x\)*\|\%(\%(\%(0\|[1-9]\%(_\?\d\%(_\?\d\)*\)\?\)\.\%(\d\%(_\?\d\)*\)\?\|\.\d\%(_\?\d\)*\|\%(0\|[1-9]\%(_\?\d\%(_\?\d\)*\)\?\)\)\%(e[+-]\?\d\%(_\?\d\)*\)\?\)\)+ contains=tsNumberDot,tsNumberSeparator skipwhite skipempty nextgroup=tsAccessor,@tsOperators,tsFlowColon
syntax match   tsNumberDot +\.+ contained
syntax match   tsNumberSeparator +_+ contained

" Array
syntax region  tsArray matchgroup=tsBrackets start=+\[+ end=+]+ contains=@tsExpression,tsComma,tsSpread skipwhite skipempty nextgroup=tsAccessor,tsDot,@tsOperators,tsFlowColon

" Object
syntax region  tsObject matchgroup=tsObjectBraces start=+{+ end=+}+ contained contains=tsComment,tsIdentifier,tsObjectKey,tsObjectKeyString,tsMethod,tsComputed,tsGeneratorAsterisk,tsAsync,tsMethodType,tsComma,tsSpread skipwhite skipempty nextgroup=tsFlowColon
syntax match   tsObjectKey +\<\k\+\>\ze\s*:+ contained skipwhite skipempty nextgroup=tsAssignmentColon
syntax region  tsObjectKeyString start=+\z(["']\)+ skip=+\\\\\|\\\z1\|\\\n+ end=+\z1+ contained contains=@Spell skipwhite skipempty nextgroup=tsAssignmentColon

" Property accessor, e.g., arr[1] or obj["prop"]
syntax region  tsAccessor matchgroup=tsAccessorBrackets start=+\[+ end=+]+ contained contains=@tsExpression skipwhite skipempty nextgroup=tsAccessor,tsFunctionCallArgs,tsDot,tsOptionalOperator,@tsOperators,tsFlowColon

" Array Destructuring
" Cases like [a, b] = [1, 2] and the array destructuring in the arrow function arguments cannot be highlighted
" as array destructuring, they are highlighted as Array, but it doesn't break the syntax
syntax region  tsArrayDestructuring matchgroup=tsDestructuringBrackets start=+\[+ end=+]+ contained contains=tsComment,tsIdentifier,tsComma,tsSpread,tsObjectDestructuring,tsArrayDestructuring skipwhite skipempty nextgroup=tsAssignmentEqual,tsFlowColon

" Object Destructuring
" Cases like ({a, b} = {a: 1, b: 2}) and the object destructuring in the arrow function arguments cannot be highlighted
" as object destructuring, they are highlighted as Object, but it doesn't break the syntax
syntax region  tsObjectDestructuring matchgroup=tsDestructuringBraces start=+{+ end=+}+ contained contains=tsComment,tsObjectDestructuringKey,tsIdentifier,tsComma,tsObjectDestructuring,tsArrayDestructuring,tsSpread skipwhite skipempty nextgroup=tsAssignmentEqual,tsFlowColon
syntax match   tsObjectDestructuringKey +\<\K\k*\>\ze\s*:+ contained skipwhite skipempty nextgroup=tsObjectDestructuringColon
syntax match   tsObjectDestructuringColon +:+ contained skipwhite skipempty nextgroup=tsIdentifier,tsObjectDestructuring,tsArrayDestructuring

" Class
syntax keyword tsClass class skipwhite skipempty nextgroup=tsClassName,tsClassBody
syntax keyword tsExtends extends contained skipwhite skipempty nextgroup=tsClassName
syntax keyword tsConstructor constructor contained
syntax keyword tsSuper super contained
syntax keyword tsStatic static contained skipwhite skipempty nextgroup=tsClassProp,tsMethod,tsGeneratorAsterisk
syntax match   tsClassName +\<\K\k*\%(\.\K\k*\)*\>+ contained skipwhite skipempty nextgroup=tsExtends,tsClassBody,tsFlowGenericDeclare,tsFlowImplments
syntax region  tsClassBody matchgroup=tsClassBraces start=+{+ end=+}+ contained contains=tsComment,tsAsync,tsStatic,tsMethodType,tsClassPrivate,tsClassProp,tsMethod,tsGeneratorAsterisk,tsComputed,tsDecoratorName,tsDecoratorParams,tsSemicolon fold
syntax match   tsClassProp +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsAssignmentEqual,tsFlowColon
syntax match   tsClassPrivate +#+ contained nextgroup=tsClassProp,tsMethod

syntax keyword tsNew new skipwhite skipempty nextgroup=tsNewClassName
syntax match   tsNewClassName +\K\k*\%(\.\K\k*\)*+ contained contains=tsNewDot,@tsGlobals skipwhite skipempty nextgroup=tsNewClassArgs,tsFlowGenericCall
syntax region  tsNewClassArgs matchgroup=tsNewClassParens start=+(+ end=+)+ contained contains=@tsExpression,tsComma,tsSpread skipwhite skipempty nextgroup=tsAccessor,tsFunctionCallArgs,tsDot,tsOptionalOperator,@tsOperators
syntax match   tsNewDot +\.+ contained

" Decorator
" REFERENCE: https://github.com/tc39/proposal-decorators
syntax keyword tsDecorator decorator skipwhite skipempty nextgroup=tsDecoratorName
syntax match   tsDecoratorName +@\K\k*\>+ skipwhite skipempty nextgroup=tsDecoratorBlock,tsDecoratorParams,tsFrom
syntax region  tsDecoratorBlock matchgroup=tsDecoratorBraces start=+{+ end=+}+ contained contains=tsComment,tsDecoratorName,tsDecoratorParams
syntax region  tsDecoratorParams matchgroup=tsDecoratorParens start=+(+ end=+)+ contained contains=@tsExpression,tsComma,tsSpread nextgroup=tsDecoratorBlock

" Function
syntax keyword tsAsync async skipwhite skipempty nextgroup=tsFunction,tsFunctionArgs,tsGeneratorAsterisk,tsComputed,tsIdentifier,tsMethod
syntax keyword tsAwait await skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsThis this contained
syntax keyword tsReturn return skipwhite skipempty nextgroup=@tsExpression
syntax keyword tsFunction function skipwhite skipempty nextgroup=tsGeneratorAsterisk,tsFunctionName,tsFunctionArgs,tsFlowGenericDeclare
syntax match   tsFunctionName +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsFunctionArgs,tsFlowGenericDeclare
syntax region  tsFunctionArgs matchgroup=tsFunctionParens start=+(+ end=+)+ contained contains=tsComment,tsIdentifier,tsComma,tsSpread,tsObjectDestructuring,tsArrayDestructuring skipwhite skipempty nextgroup=tsArrow,tsFunctionBody,tsFlowColon fold
syntax region  tsFunctionBody matchgroup=tsFunctionBraces start=+{+ end=+}+ contained contains=@tsTop fold

" Arrow Function
syntax match   tsArrow +=>+ contained skipwhite skipempty nextgroup=@tsExpression,tsFunctionBody

" Object method
syntax match   tsMethod +\<\K\k*\>\%(\_s*(\)\@=+ contained contains=tsConstructor skipwhite skipempty nextgroup=tsFunctionArgs
syntax match   tsMethodType +\<[sg]et\>+ contained skipwhite skipempty nextgroup=tsMethod

" Computed property
syntax region  tsComputed matchgroup=tsComputedBrackets start=+\[+ end=+]+ contained contains=@tsExpression skipwhite skipempty nextgroup=tsAssignmentEqual,tsFunctionArgs,tsAssignmentColon

" Generator
syntax match   tsGeneratorAsterisk +\*+ contained skipwhite skipempty nextgroup=tsFunctionName,tsMethod,tsComputed
syntax keyword tsYield yield skipwhite skipempty nextgroup=@tsExpression,tsYieldAsterisk
syntax match   tsYieldAsterisk +\*+ contained skipwhite skipempty nextgroup=@tsExpression

" Function Call
" Matches: func(), obj.func(), obj.func?.(), obj.func<Array<number | string>>() etc.
syntax match   tsFunctionCall +\<\K\k*\>\%(\_s*<\%(\_[^&|)]\{-1,}\%([&|]\_[^&|)]\{-1,}\)*\)>\)\?\%(\_s*\%(?\.\)\?\_s*(\)\@=+ contains=tsImport,tsSuper,tsBuiltinFunctions,tsFlowGenericCall skipwhite skipempty nextgroup=tsOptionalOperator,tsFunctionCallArgs
syntax region  tsFunctionCallArgs matchgroup=tsFunctionParens start=+(+ end=+)+ contained contains=@tsExpression,tsComma,tsSpread skipwhite skipempty nextgroup=tsAccessor,tsFunctionCallArgs,tsDot,tsOptionalOperator,@tsOperators

" Loops
syntax keyword tsFor for skipwhite skipempty nextgroup=tsLoopCondition,tsForAwait
syntax keyword tsForAwait await contained skipwhite skipempty nextgroup=tsLoopCondition
syntax keyword tsOf of contained skipwhite skipempty nextgroup=@tsExpression
syntax region  tsLoopBlock matchgroup=tsLoopBraces start=+{+ end=+}+ contained contains=@tsTop skipwhite skipempty nextgroup=tsWhile
syntax region  tsLoopCondition matchgroup=tsLoopParens start=+(+ end=+)+ contained contains=@tsExpression,tsOf,tsVariableType,tsSemicolon,tsComma skipwhite skipempty nextgroup=tsLoopBlock

syntax keyword tsDo do skipwhite skipempty nextgroup=tsLoopBlock
syntax keyword tsWhile while skipwhite skipempty nextgroup=tsLoopCondition

syntax keyword tsBreak break skipwhite skipempty nextgroup=tsLabelText
syntax keyword tsContinue continue skipwhite skipempty nextgroup=tsLabelText

syntax match   tsLabel +\<\K\k*\>\_s*:+ contains=tsLabelText skipwhite skipempty nextgroup=tsBlock,tsFor,tsDo,tsWhile
syntax match   tsLabelText +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsLabelColon
syntax match   tsLabelColon +:+ contained

" Control flow
" If statement
syntax keyword tsIf if skipwhite skipempty nextgroup=tsIfCondition,tsIfBlock
syntax keyword tsElse else contained skipwhite skipempty nextgroup=tsIf,tsIfBlock
syntax region  tsIfBlock matchgroup=tsIfBraces start=+{+ end=+}+ contained contains=@tsTop skipwhite skipempty nextgroup=tsElse
syntax region  tsIfCondition matchgroup=tsIfParens start=+(+ end=+)+ contained contains=@tsExpression,tsVariableType,tsComma skipwhite skipempty nextgroup=tsIfBlock

" Switch statements
syntax keyword tsSwitch switch skipwhite skipempty nextgroup=tsSwitchCondition
syntax region  tsSwitchBlock matchgroup=tsSwitchBraces start=+{+ end=+}+ contained contains=tsCaseStatement,@tsTop
syntax region  tsSwitchCondition matchgroup=tsSwitchParens start=+(+ end=+)+ contained contains=@tsExpression,tsVariableType,tsComma skipwhite skipempty nextgroup=tsSwitchBlock
syntax region  tsCaseStatement matchgroup=tsSwitchCase start=+\<\%(case\|default\)\>+ matchgroup=tsSwitchColon end=+:+ contained contains=@tsExpression

" Exceptions
syntax keyword tsTry try skipwhite skipempty nextgroup=tsExceptionBlock
syntax region  tsExceptionBlock matchgroup=tsExceptionBraces start=+{+ end=+}+ contained contains=@tsTop skipwhite skipempty nextgroup=tsCatch,tsFinally
syntax keyword tsCatch catch skipwhite skipempty nextgroup=tsExceptionBlock,tsExceptionParams
syntax region  tsExceptionParams matchgroup=tsExceptionParens start=+(+ end=+)+ contained contains=@tsExpression skipwhite skipempty nextgroup=tsExceptionBlock
syntax keyword tsFinally finally contained skipwhite skipempty nextgroup=tsExceptionBlock
syntax keyword tsThrow throw skipwhite skipempty nextgroup=@tsExpression

" with statement
syntax keyword tsWith with skipwhite skipempty nextgroup=tsWithExpression
syntax region  tsWithExpression matchgroup=tsWithParens start=+(+ end=+)+ contained contains=@tsExpression,tsVariableType,tsComma skipwhite skipempty nextgroup=tsBlock

" Tokens that appear at the top-level
syntax cluster tsTop contains=tsDebugger,tsSemicolon,tsParensError,tsBlock,tsParen,@tsTopOperators,tsImport,tsExport,tsRegexp,tsComment,tsVariableType,tsIdentifier,tsString,tsTemplateString,tsTemplateStringTag,tsNumber,tsArray,tsClass,tsNew,tsDecorator,tsDecoratorName,tsAsync,tsAwait,tsReturn,tsFunction,tsYield,tsFunctionCall,tsFor,tsDo,tsWhile,tsBreak,tsContinue,tsLabel,tsIf,tsSwitch,tsTry,tsThrow,tsWith
" Tokens that produce a value
syntax cluster tsExpression contains=tsRegexp,tsComment,tsString,tsTemplateString,tsTemplateStringTag,tsNumber,tsArray,tsObject,tsIdentifier,tsAsync,tsAwait,tsYield,tsFunction,tsFunctionCall,tsClass,tsParen,@tsTopOperators,tsBindOperator,tsNew
" Tokens that are globally used by typescript
syntax cluster tsGlobals contains=tsBuiltinValues,tsThis,tsSuper,tsBuiltinObjects

" Highlight tsodc
silent! source <sfile>:h/extras/tsdoc.vim

" Basics
highlight default link tsDebugger Error
highlight default link tsSemicolon Operator
highlight default link tsComma Operator
highlight default link tsAssignmentColon Operator
highlight default link tsAssignmentEqual Operator
highlight default link tsPrivateIdentifier Type
highlight default link tsSpread Operator
highlight default link tsParensError Error
highlight default link tsBraces Special
highlight default link tsParens Special
highlight default link tsBrackets Special

" Operators
highlight default link tsUnaryOperator Keyword
highlight default link tsRelationalOperator Keyword
highlight default link tsBindOperator Keyword
highlight default link tsOperator Operator
highlight default link tsTopOperator tsOperator
highlight default link tsTernaryOperator tsOperator
highlight default link tsDot tsOperator
highlight default link tsOptionalOperator tsOperator

" Modules
highlight default link tsImport PreProc
highlight default link tsExport tsImport
highlight default link tsFrom tsImport
highlight default link tsModuleDefault Keyword
highlight default link tsModuleAsterisk tsOperator
highlight default link tsModuleAs tsImport
highlight default link tsModuleName tsIdentifier
highlight default link tsModuleComma tsComma
highlight default link tsModuleBraces tsBraces

" RegExp
highlight default link tsRegexpError Error
highlight default link tsRegexpSlashes Special
highlight default link tsRegexpFlags Type
highlight default link tsRegexpChars String
highlight default link tsRegexpQuantifier Keyword
highlight default link tsRegexpOr Keyword
highlight default link tsRegexpEscape Keyword
highlight default link tsRegexpRangeHyphen Keyword
highlight default link tsRegexpRangeCaret Keyword
highlight default link tsRegexpBoundaries Keyword
highlight default link tsRegexpDot Character
highlight default link tsRegexpCharClass Type
highlight default link tsRegexpUnicodeBraces Keyword
highlight default link tsRegexpUnicodeName Type
highlight default link tsRegexpUnicodeEqual Special
highlight default link tsRegexpUnicodeValue Constant
highlight default link tsRegexpParens Type
highlight default link tsRegexpGroupReference Keyword
highlight default link tsRegexpBrackets Type
highlight default link tsRegexpAssertionParens Type

" Comments
highlight default link tsComment Comment
highlight default link tsHashbangComment PreProc
highlight default link tsCommentTodo Todo

" Declaration
highlight default link tsVariableType Type

" Strings and Values
highlight default link tsString String
highlight default link tsTemplateStringTag Identifier
highlight default link tsTemplateString String
highlight default link tsTemplateBrace Special
highlight default link tsBuiltinValues Constant
highlight default link tsBuiltinObjects Type
highlight default link tsBuiltinFunctions tsFunction
highlight default link tsNumber Number
highlight default link tsNumberDot Special
highlight default link tsNumberSeparator Number

" Object
highlight default link tsObjectBraces tsBraces
highlight default link tsObjectKey Identifier
highlight default link tsObjectKeyString String
highlight default link tsAccessorBrackets tsBrackets

" Destructuring
highlight default link tsDestructuringBrackets tsBrackets
highlight default link tsDestructuringBraces tsBraces
highlight default link tsObjectDestructuringColon Operator

" Class
highlight default link tsClass Keyword
highlight default link tsExtends Keyword
highlight default link tsConstructor Keyword
highlight default link tsSuper Keyword
highlight default link tsStatic Keyword
highlight default link tsClassName Identifier
highlight default link tsClassProp Identifier
highlight default link tsClassPrivate Type
highlight default link tsClassBraces tsBraces
highlight default link tsNew Keyword
highlight default link tsNewClassName Identifier
highlight default link tsNewClassParens tsParens
highlight default link tsNewDot tsDot

" Decorator
highlight default link tsDecorator Keyword
highlight default link tsDecoratorName Type
highlight default link tsDecoratorBraces tsBraces
highlight default link tsDecoratorParens tsParens

" Function
highlight default link tsAsync Keyword
highlight default link tsAwait Keyword
highlight default link tsYield Keyword
highlight default link tsThis Keyword
highlight default link tsReturn Keyword
highlight default link tsFunction Keyword
highlight default link tsFunctionName Function
highlight default link tsFunctionParens tsParens
highlight default link tsFunctionBraces tsBraces
highlight default link tsArrow Keyword
highlight default link tsMethodType Type
highlight default link tsMethod tsFunctionName

highlight default link tsComputedBrackets tsBrackets

" Generator
highlight default link tsGeneratorAsterisk tsOperator
highlight default link tsYieldAsterisk tsOperator

" Function call
highlight default link tsFunctionCall Function

" Loops
highlight default link tsFor Keyword
highlight default link tsForAwait tsAwait
highlight default link tsOf Keyword
highlight default link tsDo Keyword
highlight default link tsWhile Keyword
highlight default link tsLoopParens tsParens
highlight default link tsLoopBraces tsBraces
highlight default link tsLabelText Identifier
highlight default link tsLabelColon tsOperator
highlight default link tsBreak Keyword
highlight default link tsContinue Keyword

" Conditional Statements
highlight default link tsIf Keyword
highlight default link tsElse Keyword
highlight default link tsIfParens tsParens
highlight default link tsIfBraces tsBraces
highlight default link tsSwitch Keyword
highlight default link tsSwitchParens tsParens
highlight default link tsSwitchBraces tsBraces
highlight default link tsSwitchCase Keyword
highlight default link tsSwitchColon tsOperator

" Exceptions
highlight default link tsTry Keyword
highlight default link tsCatch Keyword
highlight default link tsFinally Keyword
highlight default link tsThrow Keyword
highlight default link tsExceptionParens tsParens
highlight default link tsExceptionBraces tsBraces

" Flow syntax highlighting
" Syntax groups for flow module
syntax keyword tsModuleType type contained skipwhite skipempty nextgroup=tsModuleTypeName,tsModuleBlock
syntax match   tsModuleTypeName +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsModuleComma,jsFrom
syntax match   tsModuleComma +,+ contained skipwhite skipempty nextgroup=tsModuleBlock,tsModuleTypeName
syntax region  tsModuleBlock matchgroup=tsModuleBraces start=+{+ end=+}+ contained contains=tsModuleTypeName,tsModuleComma skipwhite skipempty nextgroup=jsFrom
syntax keyword tsModuleTypeof typeof contained skipwhite skipempty nextgroup=jsModuleName,jsModuleBlock,tsModuleAsterisk
syntax match   tsModuleAsterisk +\*+ contained skipwhite skipempty nextgroup=tsModuleAs
syntax keyword tsModuleAs as contained skipwhite skipempty nextgroup=tsModuleTypeName

syntax match   tsColon +?\?:+ contained skipwhite skipempty nextgroup=@tsTypes,tsMaybe,tsArrayShorthand,tsChecks,tsGenericContained
syntax match   tsMaybe +?+ contained skipwhite skipempty nextgroup=@tsTypes
syntax match   tsUnion +|+ contained skipwhite skipempty nextgroup=@tsTypes
syntax match   tsIntersection +&+ contained skipwhite skipempty nextgroup=@tsTypes
syntax match   tsChecks +%checks+ contained skipwhite skipempty nextgroup=jsFunctionBody
syntax match   tsArrow +=>+ contained skipwhite skipempty nextgroup=@tsTypes
syntax match   tsModifier +[+-]+ contained skipwhite skipempty nextgroup=tsKey,tsIndexer
syntax keyword tsTypeof typeof contained skipwhite skipempty nextgroup=@jsExpression

" Tokens that can appear after a flow type
syntax cluster tsTokensAfterType contains=jsAssignmentEqual,tsUnion,tsIntersection

syntax match   tsType +\<\K\k*\>+ contained contains=tsPrimitives,tsSpecialType,tsUtility skipwhite skipempty nextgroup=@tsTokensAfterType,jsFunctionBody,jsArrow,tsGenericContained,tsArrayShorthand,tsChecks,tsColon
syntax keyword tsPrimitives boolean Boolean number Number string String null void contained
syntax keyword tsSpecialType mixed any Object Function contained
syntax match   tsUtility +$\K\k*+ contained

syntax keyword tsBoolean true false contained skipwhite skipempty nextgroup=@tsTokensAfterType
syntax region  tsString start=+\z(["']\)+ skip=+\\\\\|\\\z1\|\\\n+ end=+\z1+ contained skipwhite skipempty nextgroup=@tsTokensAfterType
syntax match   tsNumber +\c-\?\%(0b[01]\%(_\?[01]\)*\|0o\o\%(_\?\o\)*\|0x\x\%(_\?\x\)*\|\%(\%(\%(0\|[1-9]\%(_\?\d\%(_\?\d\)*\)\?\)\.\%(\d\%(_\?\d\)*\)\?\|\.\d\%(_\?\d\)*\|\%(0\|[1-9]\%(_\?\d\%(_\?\d\)*\)\?\)\)\%(e[+-]\?\d\%(_\?\d\)*\)\?\)\)+ contained contains=jsNumberDot,jsNumberSeparator skipwhite skipempty nextgroup=@tsTokensAfterType

" Generic used after function name or class name
syntax region  tsGenericDeclare matchgroup=tsAngleBrackets start=+<+ end=+>+ contained contains=@tsTypes,tsMaybe,jsComma skipwhite skipempty nextgroup=jsFunctionArgs,jsClassBody,jsExtends,tsImplments
" Generic used after new Class or function call
syntax region  tsGenericCall matchgroup=tsAngleBrackets start=+<+ end=+>+ contained contains=@tsTypes,tsMaybe,jsComma skipwhite skipempty nextgroup=jsNewClassArgs
" Generic used elsewhere
syntax region  tsGenericContained matchgroup=tsAngleBrackets start=+<+ end=+>+ contained contains=@tsTypes,tsMaybe,jsComma,tsGenericContained skipwhite skipempty nextgroup=@tsTokensAfterType,tsParen,tsChecks

syntax keyword tsArray Array contained skipwhite skipempty nextgroup=tsGenericContained
syntax match   tsArrayShorthand contained +\[\_s*]+ skipwhite skipempty nextgroup=@tsTokensAfterType,tsChecks
syntax region  tsTuple matchgroup=tsBrackets start=+\[+ end=+]+ contained contains=jsComma,jsComment,@tsTypes skipwhite skipempty nextgroup=@tsTokensAfterType,tsChecks

syntax region  tsObject matchgroup=tsBraces start=+{|\?+ end=+|\?}+ contained contains=tsModifier,tsKey,jsComma,jsSemicolon,@tsTypes,tsIndexer,jsComment,tsSpread skipwhite skipempty nextgroup=@tsTokensAfterType,tsChecks
syntax match   tsKey +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsColon,tsGenericContained,tsParen
syntax region  tsIndexer matchgroup=tsBrackets start=+\[+ end=+]+ contained contains=tsIndexerKey,@tsTypes skipwhite skipempty nextgroup=tsColon
syntax match   tsIndexerKey +\<\K\k*\>\ze\s*?\?:+ contained skipwhite skipempty nextgroup=tsColon
syntax match   tsSpread +\.\.\.+ contained skipwhite skipempty nextgroup=tsType

syntax region  tsParen matchgroup=tsParens start=+(+ end=+)+ contained contains=tsMaybe,@tsTypes,tsParameter,jsSpread,jsComment skipwhite skipempty nextgroup=tsArrayShorthand,tsArrow,tsColon
syntax match   tsParameter +\<\K\k*\>\ze\s*?\?:+ contained skipwhite skipempty nextgroup=tsColon

syntax keyword tsDeclare declare skipwhite skipempty nextgroup=tsModuleDeclare,jsClass,jsFunction,jsVariableType,jsExport
syntax keyword tsModuleDeclare module contained skipwhite skipempty nextgroup=tsModuleName
syntax region  tsModuleName start=+\z(["']\)+  skip=+\\\%(\z1\|$\)+  end=+\z1+ contained skipwhite skipempty nextgroup=tsModuleBody
syntax region  tsModuleBody matchgroup=tsBraces start=+{+ end=+}+ contained contains=jsComment,@tsTop

syntax keyword tsOpaque opaque skipwhite skipempty nextgroup=tsAliasType
syntax keyword tsAliasType type skipwhite skipempty nextgroup=tsAliasName
syntax match   tsAliasName +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsAliasEqual,tsGenericAlias,tsAliasSubtyping
syntax region  tsGenericAlias matchgroup=tsAngleBrackets start=+<+ end=+>+ contained contains=@tsTypes,tsMaybe skipwhite skipempty nextgroup=tsAliasEqual,tsAliasSubtyping
syntax region  tsAliasSubtyping matchgroup=tsColon start=+:+ matchgroup=tsAliasEqual end=+=+ end=+\ze\%(;\|$\)+ contained contains=@tsTypes skipwhite skipempty nextgroup=@tsTypes
syntax match   tsAliasEqual +=+ contained skipwhite skipempty nextgroup=@tsTypes,tsUnion,tsIntersection,tsMaybe,tsGenericContained

syntax keyword tsInterface interface skipwhite skipempty nextgroup=tsInterfaceName,tsGenericInterface
syntax match   tsInterfaceName +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsInterfaceBody,tsGenericInterface
syntax region  tsGenericInterface matchgroup=tsAngleBrackets start=+<+ end=+>+ contained contains=@tsTypes,tsMaybe skipwhite skipempty nextgroup=tsInterfaceBody
syntax region  tsInterfaceBody matchgroup=tsBraces start=+{+ end=+}+ contained contains=tsKey,tsIndexer,tsGenericContained,jsSemicolon,jsComment,tsModifier

syntax keyword tsImplments implements contained skipwhite skipempty nextgroup=tsImplmentsName
syntax match   tsImplmentsName +\<\K\k*\>+ contained skipwhite skipempty nextgroup=tsImplmentsComma,jsClassBody
syntax match   tsImplmentsComma +,+ contained skipwhite skipempty nextgroup=tsImplmentsName

syntax region  jsComment matchgroup=tsComment start=+/\*:+  end=+\*/+ contains=@tsTypes fold
syntax region  jsComment matchgroup=tsComment start=+/\*\%(::\|flow-include\)+  end=+\*/+ contains=@tsTop,tsColon,jsSemicolon,tsParameter fold

syntax cluster tsTop contains=tsDeclare,tsAliasType,tsOpaque,tsInterface
syntax cluster tsTypes contains=tsType,tsBoolean,tsString,tsNumber,tsObject,tsArray,tsTuple,tsParen,tsTypeof
syntax cluster jsTop add=@tsTop

" Flow syntax
highlight default link tsColon Operator
highlight default link tsMaybe Operator
highlight default link tsUnion Operator
highlight default link tsIntersection Operator

highlight default link tsType Type
highlight default link tsPrimitives Type
highlight default link tsSpecialType Type
highlight default link tsUtility PreProc
highlight default link tsBoolean Constant
highlight default link tsString String
highlight default link tsNumber Number

highlight default link tsKey Identifier
highlight default link tsSpread Special
highlight default link tsIndexerKey Identifier
highlight default link tsArray Type
highlight default link tsArrayShorthand Special
highlight default link tsAngleBrackets Special
highlight default link tsBrackets Special
highlight default link tsBraces Special
highlight default link tsParens Special
highlight default link tsArrow Special
highlight default link tsChecks Special
highlight default link tsTypeof Keyword

highlight default link tsDeclare Keyword
highlight default link tsModuleDeclare Keyword
highlight default link tsModuleName String
highlight default link tsOpaque PreProc
highlight default link tsAliasType Keyword
highlight default link tsAliasName Type
highlight default link tsAliasEqual Operator

highlight default link tsInterface Keyword
highlight default link tsInterfaceName Type
highlight default link tsImplments Keyword
highlight default link tsImplmentsName Type
highlight default link tsImplmentsComma Operator
highlight default link tsModifier Operator

highlight default link tsModuleType Keyword
highlight default link tsModuleTypeName Type
highlight default link tsModuleComma jsComma
highlight default link tsModuleBraces jsModuleBrace
highlight default link tsModuleTypeof Keyword
highlight default link tsModuleAsterisk Operator
highlight default link tsModuleAs Keyword
highlight default link tsComment Comment


" with statement
highlight default link tsWith Keyword
highlight default link tsWithParens tsParens

let b:current_syntax = "typescript"
if main_syntax == 'typescript'
  unlet main_syntax
endif
