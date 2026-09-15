# mathemancer.github.io

Personal site of Brent Moran, built with [Hugo](https://gohugo.io) and
deployed to GitHub Pages at <https://mathemancer.com> (also reachable as
<https://mathemancer.github.io>).

## Structure

- `hugo.yaml` — site config (menus, markup, math delimiters)
- `content/_index.md` — homepage
- `content/blog/` — the blog; each post is a markdown file with `title` and `date` front matter
- `layouts/` — minimal custom templates (no theme)
- `assets/css/` — styles; palette taken from foot.ini, syntax styles generated via `hugo gen chromastyles`
- `static/fonts/` — self-hosted Charter + subset Iosevka webfonts (licenses included)
- `static/katex/` — KaTeX CSS + fonts for build-time math rendering (no client-side JS)
- `static/resume/` — compiled resume PDF (served); LaTeX sources live in `resume/`
- `static/CNAME` — custom domain (`mathemancer.com`)

## Adding a post

Create `content/blog/YYYY-MM-DD-slug.md`:

```markdown
---
title: "Post title"
date: YYYY-MM-DD
---
```

- Inline math: `\( ... \)`
- Display math: `\[ ... \]` or `$$ ... $$`
- Code: fenced blocks, Chroma highlighting (lowercase language tag)

## Local build

```sh
hugo --minify      # build to public/
hugo server        # live preview at localhost:1313
```

## Deploy

`.github/workflows/hugo.yml` builds and deploys to GitHub Pages on push to
`master`. Pages source must be set to *GitHub Actions* (not branch deploy).

Custom domain: `mathemancer.com` and `www`. DNS at the registrar: apex
`A` records → `185.199.108.153`, `185.199.109.153`, `185.199.110.153`,
`185.199.111.153`; `www` `CNAME` → `mathemancer.github.io`.

## Rebuilding the resume

```sh
cd resume && latexmk -pdf brent_resume.tex
cp brent_resume.pdf ../static/resume/
```
