// ── Packages ─────────────────────────────────────────────────────────────────
#import "@preview/catppuccin:1.1.0": catppuccin, flavors
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.10": codly-languages

// ── Template ─────────────────────────────────────────────────────────────────
#let template = doc => {
  set page(paper: "a4", width: 11cm, numbering: "Page 1/1")
  set heading(numbering: "1.")
  show heading: smallcaps

  show: codly-init
  codly(
    languages: codly-languages,

    fill: flavors.mocha.colors.base.rgb,
    zebra-fill: flavors.mocha.colors.mantle.rgb,
    stroke: 1pt + flavors.mocha.colors.surface1.rgb,

    lang-fill: lang => lang.color.darken(69%),
    lang-stroke: lang => lang.color,
    number-format: number => text(
      fill: flavors.mocha.colors.overlay0.rgb,
    )[#number],
  )

  show: catppuccin.with(flavors.mocha)

  doc
}
