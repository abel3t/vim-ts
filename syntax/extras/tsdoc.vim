" tsDoc
syntax match   tsDocTags +@\%(abstract\|virtual\|async\|classdesc\|description\|desc\|file\|fileoverview\|overview\|generator\|global\|hideconstructor\|ignore\|inheritdoc\|inner\|instance\|override\|readonly\|static\|summary\|todo\)\>+ contained
syntax match   tsDocTags +@access\>+ contained skipwhite nextgroup=tsDocAccessTypes
syntax keyword tsDocAccessTypes package private protected public contained

syntax match   tsDocTags +@\%(alias\|augments\|extends\|borrows\|callback\|constructs\|external\|function\|func\|method\|interface\|mixin\|host\|lends\|memberof!\?\|mixes\|name\|this\|tutorial\)+ contained skipwhite nextgroup=tsDocNamepath
syntax match   tsDocNamepath +[^[:blank:]*]\++ contained skipwhite nextgroup=tsDocAs
syntax keyword tsDocAs as contained skipwhite nextgroup=tsDocNamepath

syntax match   tsDocTags +@author\>+ contained skipwhite nextgroup=tsDocAuthorName
syntax match   tsDocAuthorName +[^<>]\++ contained skipwhite nextgroup=tsDocAuthorMail
syntax region  tsDocAuthorMail matchgroup=tsDocAngleBrackets start=+<+ end=+>+ contained

syntax match   tsDocTags +@\%(class\|constructor\|constant\|const\|enum\|implements\|member\|var\|package\|private\|protected\|public\|type\)\>+ contained skipwhite nextgroup=tsDocTypeBlock,tsDocIdentifier

syntax match   tsDocTags +@\%(copyright\|deprecated\|license\|since\|variation\|version\)\>+ contained skipwhite nextgroup=tsDocImportant
syntax match   tsDocImportant +.\++ contained

syntax match   tsDocTags +@\%(default\|defaultValue\)\>+ contained skipwhite nextgroup=tsDocValue
syntax match   tsDocValue +.\++ contained

syntax match   tsDocTags +@\%(event\|fires\|emits\|listens\)\>+ contained skipwhite nextgroup=tsDocEvent
syntax match   tsDocEvent +[^[:blank:]*]\++ contained

syntax match   tsDocTags +@example\>+ contained skipwhite skipempty nextgroup=tsDocExample,tsDocCaption
syntax region  tsDocCaption matchgroup=tsDocCaptionTag start=+<caption>+ end=+</caption>+ contained skipwhite skipempty nextgroup=tsDocExample
syntax region  tsDocExample matchgroup=tsDocExampleBoundary start=+\*\%([*/]\|\s*@\)\@!+ end=+$+ contained contains=TOP keepend skipwhite skipempty nextgroup=tsDocExample

syntax match   tsDocTags +@\%(exports\|requires\)\>+ contained skipwhite nextgroup=tsDocModuleName
syntax match   tsDocModuleName +\%(module:\)\?\K\k*\%([/.#]\K\k*\)*+ contained

syntax match   tsDocTags +@kind\>+ contained skipwhite nextgroup=tsDocKinds
syntax keyword tsDocKinds class constant event external file function member mixin module namespace typedef contained

syntax match   tsDocTags +@\%(module\|namespace\|param\|arg\|argument\|prop\|property\|typedef\)\>+ contained skipwhite nextgroup=tsDocTypeBlock,tsDocModuleName
syntax match   tsDocTags +@\%(returns\|return\|throws\|exception\|yields\|yield\)\>+ contained skipwhite nextgroup=tsDocReturnTypeBlock
syntax match   tsDocTags +@\%(see\)\>+ contained skipwhite nextgroup=tsDocNamepath,tsDocInline

syntax region  tsDocTypeBlock matchgroup=tsDocBraces start=+{+ end=+}+ contained keepend contains=tsDocType skipwhite nextgroup=tsDocIdentifier
syntax region  tsDocReturnTypeBlock matchgroup=tsDocBraces start=+{+ end=+}+ contained keepend contains=tsDocType
syntax match   tsDocType +[^[:blank:]*]\++ contained
syntax match   tsDocIdentifier +\[\?\K\k*\%(\%(\[]\)\?\.\K\k*\)*\%(=[^]]\+\)\?]\?+ contained skipwhite nextgroup=tsDocHyphen
syntax match   tsDocHyphen +-+ contained

syntax region  tsDocInline matchgroup=tsDocBraces start=+{@\@=+ end=+}+ contained contains=tsDocTagsInline keepend
syntax match   tsDocTagsInline +@\%(link\|linkcode\|linkplain\|tutorial\)\>+ contained skipwhite nextgroup=tsDocLinkPath
syntax match   tsDocLinkPath +[^[:blank:]|]\++ contained skipwhite nextgroup=tsDocLinkSeparator
syntax match   tsDocLinkSeparator +[[:blank:]|]+ contained skipwhite nextgroup=tsDocLinkText
syntax match   tsDocLinkText +[^|]\++ contained

highlight default link tsDocBraces Special
highlight default link tsDocTags Keyword
highlight default link tsDocAccessTypes Type
highlight default link tsDocAuthorName String
highlight default link tsDocAuthorMail String
highlight default link tsDocImportant String
highlight default link tsDocValue Constant
highlight default link tsDocCaption String
highlight default link tsDocCaptionTag Type
highlight default link tsDocKinds Keyword
highlight default link tsDocExampleBoundary jsComment
highlight default link tsDocNamepath Identifier
highlight default link tsDocIdentifier Identifier
highlight default link tsDocModuleName Identifier
highlight default link tsDocEvent Identifier

highlight default link tsDocAngleBrackets Special
highlight default link tsDocHyphen Special

highlight default link tsDocTagsInline tsDocTags
highlight default link tsDocLinkPath String
highlight default link tsDocLinkSeparator tsDocBraces
highlight default link tsDocLinkText Identifier

highlight default link tsDocAs Keyword
highlight default link tsDocType Type
