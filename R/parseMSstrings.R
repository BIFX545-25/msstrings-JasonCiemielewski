#' parseMSstrings.R
#' Extracts metadata from annotated peptide sequence from Spectronaut, returns tibble with sequence, modifications, and modification locations in peptide sequence.
#'
#' @param seqs A character string. Sequence represents amino acids.
#' @param mods A character string. Sequence represents modifications to amino acids.
#' @param mods_at A numeric value. Location of modifications in sequence.
#'
#' @returns A tibble.  Tibble containing amino acid seqeuence, modifications,
#'  and sequence position location of modifications
#' @export
#' @importFrom dplyr tibble
#' @importFrom purrr map map_chr
#' @importFrom Biostrings AAStringSet
#' @importFrom stringr str_extract_all str_replace str_replace_all str_split fixed

# parseMSstrings.R
# utilities for parsing MS strings

# library(Biostrings) # for `AAStringSet` - BiocManager::install('Biostrings')
# library(dplyr) # for `tibble`
# library(purrr) # for `map` and `map_chr`
# library(stringr) # for `str_extract_all`, `str_replace`, `str_replace_all`, and `str_split`

parse_mods <- function(seqs, format = 'Spectronaut')
{
  # remove '_'
  seqs <- seqs |>
    str_replace_all('_', '')


  # locate modification(s)
  mods <- str_extract_all(seqs, "\\[.*?\\]") |>
    map(~ .x |>
          str_replace(fixed("["), '') |>
          str_replace(fixed("]"), '') |>
          str_replace("\\(.*?\\)", '') |>
          trimws())


  # remove modifications from seqs
  seqs <- str_split(seqs, "\\[.*?\\]")


  # find where the mods are at
  mods_at <- map(seqs, ~
                   {
                     retval <- nchar(.x) |>
                       cumsum()

                     retval[-length(retval)] # this is the end of the peptide, not a modification
                   })


  # return the data.frame
  retval <- tibble(sequence = map_chr(seqs, ~ paste(.x, collapse = '')) |>
                     AAStringSet() |>
                     as.list(),
                   mods = mods,
                   mods_at = mods_at)

  class(retval) <- c('protein_mods', class(retval))

  return(retval)
}
