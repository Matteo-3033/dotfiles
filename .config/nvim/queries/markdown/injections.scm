;; Override della injections.scm di nvim-treesitter per markdown: la regola
;; dei fenced code block e' rimossa di proposito.
;;
;; Su Neovim 0.12 il parsing asincrono dell'highlighter core, quando deve
;; anche costruire un language-tree iniettato per il contenuto di un fenced
;; code block (```bash, ```toml, ...), va in race e crasha con
;; "attempt to call method 'range' (a nil value)" — e lo fa ad ogni redraw,
;; quindi si vede come un mare di errori ogni volta che si apre un .md con
;; code fence (vedi a.md). Il bug e' nel core (vim/treesitter/highlighter.lua),
;; non in nvim-treesitter ne' in snacks: e' riproducibile anche con la sola
;; combinazione nvim-treesitter + `:redraw`, senza altri plugin.
;;
;; Rimuovendo solo questa regola, il contenuto dei code fence resta
;; visibile ma senza syntax highlighting specifico del linguaggio (niente
;; colori dedicati per bash/toml/ecc. dentro i ``` blocchi): e' il prezzo
;; per evitare il crash. Le altre injection (markdown_inline nei paragrafi,
;; html_block, front-matter yaml/toml) restano attive.
;;
;; Se in futuro un aggiornamento di Neovim risolve il bug a monte, questo
;; file puo' essere eliminato per riavere l'highlighting nei code fence.

((html_block) @injection.content
  (#set! injection.language "html")
  (#set! injection.combined)
  (#set! injection.include-children))

((minus_metadata) @injection.content
  (#set! injection.language "yaml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

((plus_metadata) @injection.content
  (#set! injection.language "toml")
  (#offset! @injection.content 1 0 -1 0)
  (#set! injection.include-children))

([
  (inline)
  (pipe_table_cell)
] @injection.content
  (#set! injection.language "markdown_inline"))
