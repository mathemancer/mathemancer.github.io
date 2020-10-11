(TeX-add-style-hook
 "brent_resume"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "a4paper")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "brent_cv"
    "pifont")
   (TeX-add-symbols
    "isp"
    "bbull")
   (LaTeX-add-bibliographies
    "cvbib.bib"))
 :latex)

