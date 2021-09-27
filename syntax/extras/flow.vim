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
