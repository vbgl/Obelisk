open Common

include MiniLatex

let print_header symbols =
  let max =
    let compare_length s1 s2 = compare (String.length s2) (String.length s1) in
    let max = List.(hd (sort compare_length (Symbols.defined symbols))) in
    let params =
      let rec aux = function
        | [] -> ""
        | [x] -> x
        | x :: xs -> x ^ ", " ^ aux xs
      in function
        | [] -> ""
        | xs -> "(" ^ aux xs ^ ")"
    in
    let max = match Common.Symbols.is_defined max symbols with
      | Some xs -> max ^ params xs
      | None -> assert false
    in
    String.escaped (Str.global_replace (Str.regexp "_") "\\_" max)
  in
  documentclass
    (usepackage "" "syntax" ^ "@;" ^
     (if pre () = "" then ""
     else
       "\\\\newenvironment{" ^ command "grammar" ^
       "}{\\\\begin{grammar}}{\\\\end{grammar}}@;@;") ^
     newcommand "gramterm" 1 None "#1" ^
     newcommand "gramnonterm" 1 None "\\\\synt{#1}" ^
     newcommand "gramdef" 0 None "::=" ^
     newcommand "grambar" 0 None "\\\\alt" ^
     newcommand "grameps" 0 None "\\\\ensuremath{\\\\epsilon}" ^
     "\\\\newlength{\\\\" ^ command "grammaxindent" ^
     "}@;\
      \\\\settowidth{\\\\" ^ command "grammaxindent" ^
     "}{\\\\synt{" ^ max ^ "} \\\\" ^
     command "gramdef" ^ "{} }@;@;");
  begin_document
    ("\\setlength{\\grammarindent}{\\" ^ command "grammaxindent" ^ "}")
    (Common.Symbols.terminals symbols)

let def () = "> \\\\" ^ command "gramdef" ^ "{} "
let prod_bar () = "\\\\" ^ command "grambar" ^ " "
let bar () = "@ \\\\" ^ command "grambar" ^ "@ "
let space () = "@ "
let break () = "@;"
let eps () = "\\\\" ^ command "grameps"

let print_rule_name is_not_fun =
  print_fmt (if is_not_fun then "<%s" else "<%s")
let rule_begin () =
  print_string "@[<v 2>"
let rule_end () =
  print_string "@]@;@;"

let print_symbol is_term _ s print_params =
  if is_term then print_fmt "\\%s{\\%s{}}" (command "gramterm") (command s)
  else begin print_fmt "\\%s{%s" (command "gramnonterm") s;
    print_params ();
    print_string "}"
  end
