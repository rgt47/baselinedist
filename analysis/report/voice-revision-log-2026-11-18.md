# Voice revision log: report.Rmd
*2026-11-18 16:37 PST*

Manuscript: `analysis/report/report.Rmd`. Baseline: git HEAD
`2394c09` (working tree was clean before editing). Pass 2 applied the
`use_rgtvoice` rules. Pass 3 applied the humanizer skill in File mode
to the Pass 2 text. Edits were made with the Edit tool only. Nothing
was staged, committed, rendered, or pushed.

## Scope of the edit

`git diff -U0` shows 100 hunks (444 insertions, 425 deletions; most
lines are rewrapping around split sentences). The file grew from
1301 to 1319 lines. Prose sentences over 25 words fell from 47 to 0,
outside the abstract. Mean sentence length fell from 16.6 to 12.0
words. The counter also flags the FDA bullet list as one 73-word
'sentence'. It is a list of fragments and was not changed.

## Pass 2: voice

- Long sentences were split at their subordinate clauses. A plain
  connective now heads the second sentence ('That is,', 'As a
  result,', 'However,', 'Instead,', 'Then').
- Conditions were kept when splitting. For example, 'provided $X$ is
  prognostic for $Y$' is now a separate sentence ('This holds provided
  ...').
- The inline enumerations (i) to (iv) in the EMA paragraph and in the
  Raab et al. paragraph became 'First, ... Fourth,' sentences. No item
  was dropped or reordered.
- Common words replaced Latinate ones where no term of art was
  involved: 'constitute' to 'are', 'demonstrated' to 'showed',
  'provided' (verb) to 'gave', 'make use of' to 'use', 'enumerated'
  to 'listed', 'reiterated' to 'restated'.
- 'We note that' and 'It is clear that' were kept where they already
  appeared. The voice file lists both as approved signposts, and the
  humanizer does not list them. One 'We note that' was moved to head
  the Limitations sentence on the broader literature. No net new
  instances were added.
- The trade-off framing ('On the one hand ... On the other') was
  used once, in Future Research item 2, where the original already
  described a tradeoff.

## Pass 3: humanizer

- The one double-hyphen dash (criterion 4) was removed by splitting
  the sentence. The file now has no em dashes, en dashes, or spaced
  double hyphens.
- Stock words removed: 'highlighted' (to 'noted'), 'key insight'
  (sentence restructured), 'key recommendations' (to 'main
  recommendations'), 'represents' (to 'is').
- One not-X-but-Y construction ('more accurate to say ... rather than
  as an intermediate strategy') became a direct statement that keeps
  both halves, because the negative half corrects a reading a reader
  could plausibly hold.
- A first-pass split produced announcer sentences ('These are ...',
  'That practice is ...', 'The central point concerns ...'). These
  are a staging pattern, so the following sentences were restored to
  their HEAD wording, all of which were already within 25 words: the
  Introduction's 'fundamental analytical decision' sentence,
  Freedman's opening sentence, the Vickers comparison, the Yang and
  Tsiatis 'most efficient' sentence, the Rosenblum 'common practice'
  sentence, and the FDA lineage sentence. The Limitations 'core
  qualitative message' passage was restructured so the literature
  sentence leads and the two claims follow as 'First' and 'Second'.
- Section headings were changed to sentence case only. Acronyms and
  names (ANCOVA, ICH E9, EMA, FDA, Freedman-Lin) were kept. Prose
  that named a section ('Theoretical Foundations', 'Binary Outcome
  and Model Misspecification') was changed to the lower-case form.
- Two line-break artifacts that rendered with a stray space were
  joined: 'covariate- adjusted' and 'marginal/ standardization'. One
  hyphen after an -ly adverb was removed ('correctly-specified' to
  'correctly specified').

## Passages deliberately left alone

- The abstract (byte-identical to HEAD), the YAML header, every code
  chunk, chunk option, `fig.cap`, kable caption, and chunk comment.
- Verbatim quotations (Senn 1994, ICH E9, Lin, Harrell). The ICH E9
  quotation is now split across two sentences ('It also advises them
  to'), with the quoted words unchanged. Two closing periods were
  moved inside the quotation mark to match the file's convention.
- Bold run-in labels: '**When to adjust:**', the strategy labels
  ('**Unadjusted**:' and the others), the metric labels, the Future
  Research item labels, '**Random-number generator.**', and '**Data
  and code availability.**'. These are structure, not decoration.
- The FDA bullet list, the 'seven myths' list items, and the
  criteria list items already under 25 words.
- Sentences the referee report flags as wrong or overstated were
  reworded only, never strengthened or corrected: 'fully consistent
  with' (M1), the test-then-adjust SE comparison (M2), 'should
  remain identifiable' (M3), the FDA lineage sentence (M4, restored
  verbatim), the Morris et al. summary (M5), and criterion 11. Words
  that carry claim strength ('fully', 'strictly', 'most rigorous',
  'typically much more so', 'never') were kept. The 'since' linking
  'no validity advantage' to ANCOVA's coverage was kept.
- 'Var(Y) = 1 marginally' and 'the two standardization working
  models coincide' (referee minor comments 1 and 2) were left as
  written.
- 'Heteroskedasticity' and 'heteroscedasticity' both appear. Both
  are US-acceptable, so this was not resolved here.

## Remaining subordinate clauses (not fully done)

The 'no subordinate clauses' rule was applied to every sentence over
25 words and to some shorter ones. It was not applied exhaustively.
A grep of non-abstract prose for when, because, since, although,
while, whenever, whether, unless, provided, and where flags 28
sentences (37 at HEAD). Most are short (8 to 22 words), and the
clause is a brief condition or a 'whether' complement, where a split
would produce choppy prose. Examples are 'This holds even when the
regression model is misspecified' and the 'As Moore and van der Laan
and Tsiatis et al. later clarified' sentence. The sentence on
'since ANCOVA's coverage' was kept deliberately (see above). Relative
clauses with 'that' and 'which' were not counted. A further manual
pass could reduce these if the author wants stricter adherence.

## Merged or dropped content

No sentence was deleted. No literal repetition was merged. One phrase
was shortened inside a split: 'maps each of these dispersed sources'
became 'maps these dispersed sources'.

## Verification

A script in the reviewer's scratch directory, not in the repo,
compared the revised file against
`git show HEAD:analysis/report/report.Rmd`:

| Check | HEAD | Revised | Identical |
|---|---|---|---|
| YAML header | | | yes |
| Abstract block | | | yes |
| Code-chunk lines (fences included) | | | yes |
| Numbers (multiset) | 392 | 392 | yes |
| `@` citation keys (multiset) | 92 | 92 | yes |
| Inline R expressions (multiset) | 19 | 19 | yes |
| Inline math (multiset, whitespace-normalized) | 77 | 77 | yes |
| Display math | 3 | 3 | yes |
| `\@ref()` cross-references | 6 | 6 | yes |
| Inline code spans (multiset, whitespace-normalized) | 60 | 60 | yes |
| Heading sequence, ignoring case | | | yes |

No number or key needed the adjacent-punctuation exemption. The
document was not rendered, so the revised prose was not checked in
PDF output.
