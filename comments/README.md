# Comments

Comment threads are served by [Isso](https://isso-comments.de), self-hosted. The site
itself is static on GitHub Pages; this directory holds the config for the service and the
local preview used to work on the styling.

- **Production:** Isso on a GCP VM behind Caddy, at `comments.mathemancer.com`.
  Config lives on the box at `/etc/isso/isso.cfg` with secrets in `/etc/isso/isso.env`.
  Not in git.
- **Local preview:** Isso from `comments/.venv`, on `127.0.0.1:8090`, pointed at by the
  `isso_dev` block in `hugo.yaml`.

The widget is injected **inline** into `#isso-thread` by `embed.min.js` — it is not an
iframe — so everything in `assets/css/main.css` reaches it. `assets/css/isso.css` is
upstream Isso 0.14.0, vendored so it goes through Hugo Pipes and stays fingerprinted.
Override it from the `.comments` block in `main.css` rather than editing it.

## Local preview

Requires `python3`, a C toolchain, and `sqlite3`. On Debian/Ubuntu:

```sh
sudo apt-get install -y build-essential python3-dev sqlite3
```

Build the venv once (compiles `misaka` from source, so it takes a minute):

```sh
python3 -m venv comments/.venv
comments/.venv/bin/pip install 'isso==0.14.0'
```

Two terminals, both from the repository root — Isso resolves `dbpath` relative to the
working directory:

```sh
# terminal 1
comments/.venv/bin/isso -c comments/isso-dev.cfg run

# terminal 2
hugo server
```

Then <http://localhost:1313/blog/syllable-counting/>.

Port 8090 rather than Isso's default 8080 because something else on this machine already
holds 8080.

### Fixture data

An empty thread tells you nothing about how the styling will hold up. The seed script
posts a thread covering the cases most likely to break a restyle — a long comment, a
reply, a one-liner, a comment containing a URL, a long unbroken line, and one with inline
code, a fenced block, and a list:

```sh
bash comments/seed-dev.sh
```

`THREAD` must match the post's `RelPermalink` exactly, because Isso uses the page URI as
the thread id. There is no permalink override in front matter, so
`content/blog/syllable-counting.md` serves at `/blog/syllable-counting/` — not the
`YYYY-MM-DD-slug` form the site README suggests for new posts. Override with
`ISSO_THREAD=...`.

To start over:

```sh
rm comments/dev.db && bash comments/seed-dev.sh
```

`comments/.venv/` and `comments/dev.db` are gitignored. Docker is not used: the daemon was
not running, and a bind mount would have put a SQLite file in a home directory, which is
worth avoiding — a database inside a cloud-sync directory is a corruption risk, since those
tools do not honour POSIX advisory locking. It also inherits host permissions, and Isso
needs the *directory* writable to create its lock file.

## How the endpoint is selected

`hugo.yaml` has two blocks, `isso` (production) and `isso_dev` (localhost).
`layouts/_partials/comments.html` picks between them on `hugo.IsServer`, mirroring the
`hugo.IsServer` guard already in `head-analytics.html` — inverted, because analytics is
switched *off* in dev and comments are switched *on*.

Delete the `isso:` block from `hugo.yaml` to disable comments site-wide; the partial
renders nothing when it is absent.

## Isso 0.14.0 behaviour worth knowing

All verified against the installed source, not the docs — several of these differ.

**The API.** `POST /new?uri=<thread>` with the comment in the request body. The field is
`text`, not `message`. `title` is also a body field, not a query parameter, and is only
needed when Isso cannot reach the thread URI to read a title itself. Replies use
`parent: <comment id>`. Fetching a thread is `GET /?uri=<thread>`; there is no
`/comments` route.

**Nesting is exactly one level.** `db/comments.py`'s `_find()` recurses to the *topmost*
ancestor, so a reply to a reply is stored as a sibling of the original. There is one indent
level to style and no deeper tree to handle.

**The guard is rate limiting only.** In `db/spam.py`, `_limit()` enforces `ratelimit`,
`direct-reply`, `reply-to-self`, `require-email`, and `require-author`; `_spam()` is an
empty stub returning `True, ""`. So there is **no content filtering of any kind** — nothing
inspects links, keywords, or anything else. `require-author` and `require-email` only check
that a value is present; an email is never verified.

**The honeypot does not exist server-side in 0.14.0.** A filled `website` field is accepted,
stored, and rendered as a link. The `[guard] website-field` option that hides it in the form
is 0.14.1+ and is a display toggle, not a rejection mechanism.

This is why the design leans on notification speed rather than moderation, and why
`trusted-proxies` matters: `ratelimit` is the only thing distinguishing a spam comment from
a real one.

**Config keys that differ from the docs.** `parameters` must go under `[markup.mistune]`;
under `[markup]` it warns `no such option`. `[guard] website-field` is 0.14.1+ and warns on
0.14.0. `public-endpoint` must not end in `/`.

**`reply-to-self = true` is dev-only.** The guard blocks a reply whose parent was posted
from the same IP within `max-age` ("edit time frame is still open"). The seed script posts
everything from `127.0.0.1`, so replies would all be rejected. Production keeps it `false`.

**Editing a comment locally is unreliable.** Isso sets a session cookie, and
`SameSite=Lax` cookies are not sent on cross-origin XHR; `SameSite=None` needs `Secure`,
which needs HTTPS. Test edit and delete against production, or front the dev instance with
Caddy using `tls internal` and trust the local certificate.

**Thread ids are page URIs.** Renaming a post file orphans its thread. The plan is to leave
the slug alone.

## Production checklist

- VM with a **reserved static IP** and a persistent disk mounted at `/var/lib/isso`
  (additive: a restored snapshot gets a new ephemeral IP and the DNS record goes stale).
- Caddy terminates TLS, `/var/lib/caddy` on the persistent disk. If Caddy's data directory
  is ephemeral, every restart re-requests a certificate and repeated re-issuance trips
  Let's Encrypt's limit of five duplicates per week.
- Isso bound to `127.0.0.1:8080` behind Caddy, with `trusted-proxies = 127.0.0.1`. **If this
  is wrong, every visitor looks like `127.0.0.1` and `ratelimit = 2` silently becomes two
  comments per minute for the whole site.** Verify by posting three comments quickly and
  confirming the third is rejected.
- Firewall: 80 and 443 only. SSH via IAP.
- A record for `comments.mathemancer.com` at the registrar, pointing at the static IP.
- `ratelimit = 2`, `direct-reply = 3`, `reply-to-self = false` — the dev values do not ship.
- Secrets in `/etc/isso/isso.env`, mode 600: `ISSO_ADMIN_PASSWORD`, `ISSO_WEBHOOK_SECRET`,
  and `ISSO_HASH_SALT`. The salt is not a password but still stays out of git: a leaked
  `comments.db` plus a public salt allows dictionary recovery of commenter email addresses.
- The comment alert can only fire on activity, so a dead service is silent. A Cloud
  Monitoring uptime check against `https://comments.mathemancer.com/info` would close that;
  deferred for now.
