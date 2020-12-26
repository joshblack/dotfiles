"
" Custom syntax highlight for typescript files. We build up a list of custom
" highlight groups that correspond more naturally to JavaScript files.
"

" Reference notes:
" javaScript -> when you want normal highlighting that properly highlights when
" active in visual mode

" Match JavaScript parenthesis
highlight link typescriptParens jsParens

" Global objects: console, window, etc
highlight link typescriptGlobal jsGlobalObjects
highlight link typescriptBOMWindowProp jsGlobalObjects

" Methods: console.log
highlight link typescriptConsoleMethod jsFuncCall
highlight link typescriptDOMEventTargetMethod jsFuncCall

" Classes
highlight link typescriptClassName jsClassDefinition

" Braces
highlight link typescriptBraces jsClassBraces

" Return
highlight link typescriptStatementKeyword jsReturn

" Binary operations
highlight link typescriptBinaryOp jsOperator

" Variables
highlight link typescriptVariable StorageClass

" Objects
highlight link typescriptObjectLabel jsObjectKey

" Types
highlight link typescriptPredefinedType javaScript
highlight link typescriptAliasDeclaration javaScript
highlight link typescriptTypeReference javaScript

" Interfaces
highlight link typescriptInterfaceName jsVariableDef

" Functions
" Target the label for the arguments of a function
highlight link typescriptCall jsFuncArgs

" Imports and exports
highlight link typescriptImport Include
highlight link typescriptExport Include
highlight link typescriptDefault Label

" Classes
highlight link typescriptClassHeritage jsClassDefinition
highlight link typescriptMember javaScript
highlight link typescriptClassStatic jsClassMethodType
