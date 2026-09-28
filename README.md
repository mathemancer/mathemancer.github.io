# mathemancer.github.io

Personal site of Brent Moran, built with [Hugo](https://gohugo.io) and
deployed to GitHub Pages at <https://mathemancer.com> (also reachable as
<https://mathemancer.github.io>).

## Structure

- `hugo.yaml` — site config (menus, markup, math delimiters, comment endpoints)
- `content/_index.md` — homepage
- `content/blog/` — the blog; each post is a markdown file with `title` and `date` front matter
- `layouts/` — minimal custom templates (no theme)
- `assets/css/` — styles; palette taken from foot.ini, syntax styles generated via `hugo gen chromastyles`; `isso.css` is vendored Isso, overridden from `main.css`
- `static/fonts/` — self-hosted Charter + subset Iosevka webfonts (licenses included)
- `static/katex/` — KaTeX CSS + fonts for build-time math rendering (no client-side JS)
- `comments/` — config and local preview for Isso, the comment server (see `comments/README.md`)
- `resume/` — LaTeX resume sources; compiled PDF **not currently published** (see issue #1)
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

## Comments

Blog posts carry a comment section served by [Isso](https://isso-comments.de), self-hosted
on a GCP VM at `comments.mathemancer.com`. The site is static, so the widget is loaded from
that host and comments are stored in a SQLite database on the VM — not in this repository.

`hugo.yaml` carries two endpoint blocks: `isso` for production and `isso_dev` for the local
preview, swapped by `layouts/_partials/comments.html` on `hugo.IsServer`. Removing the
`isso:` block disables comments everywhere.

To work on the comment styling, run Isso locally — see `comments/README.md` for setup, the
fixture data, and the parts of Isso 0.14.0 that differ from its documentation.

## Deploy

`.github/workflows/hugo.yml` builds and deploys to GitHub Pages on push to
`master`. Pages source must be set to *GitHub Actions* (not branch deploy).

Custom domain: `mathemancer.com` and `www`. DNS at the registrar: apex
`A` records → `185.199.108.153`, `185.199.109.153`, `185.199.110.153`,
`185.199.111.153`; `www` `CNAME` → `mathemancer.github.io`.

Comments are served separately: `comments` `A` record → the static IP of the Isso VM.

## Rebuilding the resume

The compiled PDF is not published right now (see issue #1). To restore it after
updating the sources:

```sh
cd resume && latexmk -pdf brent_resume.tex
mkdir -p ../static/resume/
cp brent_resume.pdf ../static/resume/
```

Then re-add the nav entry in `hugo.yaml`:

```yaml
    - name: "Resume"
      url: "/resume/brent_resume.pdf"
      weight: 20
```

## License

- Site code (Hugo config, layouts, styles): [MIT](LICENSE)
- Blog posts and other content in `content/`: &copy; Brent Moran,
  licensed [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)
- Fonts and third-party assets: notices shipped alongside them —
  `static/fonts/CHARTER-LICENSE.txt`, `static/fonts/IOSEVKA-OFL.txt`,
  `static/katex/LICENSE` (code), `static/katex/fonts/LICENSE` (OFL),
  `assets/css/isso.LICENSE` (comment widget)
- Comment server: [Isso](https://isso-comments.de), MIT, vendored as
  `assets/css/isso.css`
