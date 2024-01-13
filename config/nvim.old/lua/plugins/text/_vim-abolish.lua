return {
  "tpope/vim-abolish",
  event = "InsertEnter",
  config = function()
    vim.cmd([[
Abolish {sepe}rat{e,es,ed,ing,ely,ion,ions,or}  {sepa}rat{}
Abolish {despa, daspe, daspa}rat{e,es,ed,ing,ely,ion,ions,or}  {despe}rat{}
Abolish {dapra, depra, dapre}rat{e,es,ed,ing,ely,ion,ions,or}  {depre}rat{}
Abolish {,in}consistant{,ly} {}consistent{}
Abolish anomol{y,ies} anomal{}
]])
  end,
}
