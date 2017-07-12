include MiniLatex

let print_header symbols =
  documentclass
    (usepackage "" "tabu" ^
     "@;\
      \\\\newenvironment{grammar}{@;<0 2>\
      \\\\begin{trivlist}@;<0 4>\
      \\\\item[]@;<0 6>\
      \\\\begin{tabu}{r%@{}c%@{}X%@{}}@;\
      }{@;<0 6>\
      \\\\end{tabu}@;<0 2>\
      \\\\end{trivlist}@;\
      }@;@;\
      \\\\newcommand\\\\gramsp{\\\\quad}@;\
      \\\\newcommand\\\\gramdef{$\\\\gramsp::=\\\\gramsp$}@;\
      \\\\newcommand\\\\grambar{$\\\\gramsp|\\\\gramsp$}@;\
      \\\\newcommand{\\\\grameps}{\\\\ensuremath{\\\\epsilon}}@;\
      \\\\newcommand\\\\gramnonterm[1]{\\\\ensuremath{\\\\langle\\\\textnormal{#1}\\\\rangle}}@;\
      \\\\newcommand\\\\gramfunc[1]{#1}@;\
      \\\\newcommand\\\\gramterm[1]{#1}@;");
  begin_document "grammar" (Common.Symbols.terminals symbols)

let print_footer () = end_document "grammar"

let def = "& \\\\gramdef & "
let prod_bar = "& \\\\grambar &"
let bar = "@ \\\\grambar@ "
let space = "@ "
let break = "\\\\\\\\@;"
let eps = "\\\\grameps"

let print_rule_name is_not_fun name =
  print_fmt (if is_not_fun then "\\gramnonterm{%s}" else "\\gramfunc{%s}")
    (Str.global_replace (Str.regexp "_") "\\_" name)
let rule_begin () =
  print_string "@[<v 2>"
let rule_end () =
  print_string "@;\\\\\\\\& & \\\\\\\\";
  print_string "@]@;@;"

let print_symbol is_term is_non_term s print_params =
  let s' = Str.global_replace (Str.regexp "_") "\\_" s in
  if is_non_term then print_fmt "\\gramnonterm{%s}" s'
  else if is_term then print_fmt "\\gramterm{\\%s{}}" (command s)
  else print_fmt "\\gramfunc{%s}" s';
  print_params ()
