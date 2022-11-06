let g:targets_aiAI = 'aIAi'
autocmd User targets#mappings#user call targets#mappings#extend({
\ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]},
\ 'b': {'pair': [{'o':'(', 'c':')'}, {'o':'[', 'c':']'}, {'o':'{', 'c':'}'}, {'o':'<', 'c':'>'}]},
\ })

"  Prefer multiline targets around cursor over distant targets within cursor line:
"  https://github.com/wellle/targets.vim#gtargets_seekranges
let g:targets_seekRanges = 'cc cr cb cB lc ac Ac lr lb ar ab lB Ar aB Ab AB rr ll rb al rB Al bb aa bB Aa BB AA'
