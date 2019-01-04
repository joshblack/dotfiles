" Default nginx and *.conf files to the conf filetype
autocmd BufNewFile,BufRead *.conf,nginx.conf,nginx.*.conf,nginx.conf.* set ft=conf

" Try and predict conf files from nginx sites-available directory
autocmd BufNewFile,BufRead *.local,*.com set ft=conf
