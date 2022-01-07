let g:targets_aiAI = 'aIAi'
autocmd User targets#mappings#user call targets#mappings#extend({
\ 'a': {'argument': [{'o': '[({[]', 'c': '[]})]', 's': ','}]},
\ 'b': {'pair': [{'o':'(', 'c':')'}]}
\ })
