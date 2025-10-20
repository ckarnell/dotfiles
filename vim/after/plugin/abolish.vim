if !exists(':Abolish')
  finish
endif

" Open the Abolish file
nnoremap <leader>na :e ~/.vim/after/plugin/abolish.vim<cr>

" Prepended commas represent the empty string
Abolish {despa,sepe}rat{e,es,ed,ing,ely,ion,ions,or} {despe,sepa}rat{}
Abolish {,in}consistant{,ly} {}consistent{}
Abolish fu{nc,cn}{tion,iton,tino,iotn}{,s,ed,ing,ally} fu{nc}{tion}{}
Abolish {,in}{el,ell}ig{i,a}ble {}{el}ig{i}ble
Abolish anomol{y,ies} anomal{}
Abolish cal{a,e}nder{,s} cal{e}ndar{}
Abolish reproducable reproducible
Abolish begining{,s} beginning{}
Abolish beggining{,s} beginning{}
Abolish begginning{,s} beginning{}
Abolish innacurate{,ly} inaccurate{}
Abolish occurr{,s} occur{}
Abolish foriegn foreign
