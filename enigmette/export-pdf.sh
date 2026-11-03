#!/usr/bin/env bash
# Emploi : ./export-pdf.sh fichier.html [rouge|souligne] [sortie.pdf]
set -euo pipefail

f=${1:?manque le fichier html}          # fichier d'entrée
m=${2:-rouge}                           # rouge ou souligne
o=${3:-${f%.*}-$m.pdf}                  # ficher de sortie
d=$(cd "$(dirname "$0")" && pwd)        # dossier du code

# préambule LaTeX (couleurs)
# pour essayer un autre effet : \definecolor{HiddenBlue}{HTML}{1E4A42}
# à changer aussi dans hidden.lua 
h=$(mktemp)
trap 'rm -f "$h"' EXIT
# écrit le préambule LaTeX (couleurs) dans le fichier temporaire
printf '%s\n' '\usepackage{xcolor}' '\definecolor{HiddenRed}{HTML}{C4232B}' >"$h"

pandoc "$f" -f html -t pdf --pdf-engine=xelatex \
  --lua-filter="$d/hidden.lua" -M "hidden-mode=$m" -H "$h" \
  -V geometry:margin=2.5cm -o "$o"

echo "PDF: $o"
