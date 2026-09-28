#!/usr/bin/env bash
#
# Seed the local Isso dev database with a realistic comment thread.
#
# Purpose: the comment section cannot be styled against an empty thread. The
# fixtures below cover the cases most likely to break a restyle -- nesting,
# a link, a long unbroken line, inline code, and a fenced block.
#
# Prereqs:  hugo server running (Hugo on :1313), Isso running on :8090.
# Reset:    rm comments/dev.db && restart Isso && ./comments/seed-dev.sh
#
# API notes, verified against Isso 0.14.0:
#   POST /new?uri=<thread>   body: {text, author, email, parent, title}
#   GET  /?uri=<thread>      fetch the thread
# The field is `text`, not `message`. `title` is a BODY field (not a query param)
# and is only required when Isso cannot reach the thread URI to read a title.
# `parent` is an integer comment id, returned by the create call.

set -euo pipefail

API="${ISSO_API:-http://127.0.0.1:8090}"
# Must match the post's RelPermalink exactly -- Isso uses the page URI as the thread id.
# There is no permalink override in front matter, so content/blog/syllable-counting.md
# serves at /blog/syllable-counting/, NOT the YYYY-MM-DD-slug form the README suggests
# for new posts. Override with ISSO_THREAD=... for another post.
THREAD="${ISSO_THREAD:-/blog/syllable-counting/}"
TITLE="A pointless exercise in counting"

if ! curl -sSf -m 5 "${API}/info" >/dev/null 2>&1; then
  echo "Isso is not answering at ${API}." >&2
  echo "Start it from the repo root:" >&2
  echo "  comments/.venv/bin/isso -c comments/isso-dev.cfg run" >&2
  exit 1
fi

# post <author> <text> [parent-id] -> echoes the new comment id
post() {
  local author="$1" text="$2" parent="${3:-}"
  local payload
  if [[ -n "$parent" ]]; then
    payload=$(printf '{"author":%s,"text":%s,"parent":%s,"title":%s}' \
      "$(printf '%s' "$author" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
      "$(printf '%s' "$text"   | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
      "$parent" \
      "$(printf '%s' "$TITLE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')")
  else
    payload=$(printf '{"author":%s,"text":%s,"title":%s}' \
      "$(printf '%s' "$author" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
      "$(printf '%s' "$text"   | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')" \
      "$(printf '%s' "$TITLE" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')")
  fi

  local body
  body=$(curl -sSf -m 10 -X POST "${API}/new?uri=${THREAD}" \
    -H 'Content-Type: application/json' \
    -H 'Origin: http://localhost:1313' \
    --data-binary "$payload")

  printf '%s' "$body" | python3 -c 'import json,sys; print(json.load(sys.stdin)["id"])'
}

echo "Seeding ${THREAD}"

# 1: long top-level comment, the common case
c1=$(post "Dana R" "Tried this with my five-year-old and it worked far better than I expected. Curious whether the count differs much if you drop the stress marking.")
echo "  #${c1}  long top-level comment"

# 2: reply to #1, authored as the site owner (see data-isso-page-author-hashes)
c2=$(post "Brent Moran" "It does, quite a bit -- about 8% in my sample. That is why the post leans on the dictionary rather than the rules." "$c1")
echo "  #${c2}  reply"

# 3: a reply to a reply. Isso 0.14.0 flattens this -- db/comments.py `_find()`
# walks to the topmost ancestor -- so it renders as a sibling of #2, not nested
# under it. This is a hard limit of the software, not a setting. Only one level of
# indent exists to style.
c3=$(post "Dana R" "That tracks." "$c2")
echo "  #${c3}  reply-to-a-reply (Isso flattens this to a sibling)"

# 4: terse one-liner, the shape most comments actually take
c4=$(post "sam" "nice writeup")
echo "  #${c4}  one-liner"

# 5: contains a link -- check link colour, underline, and wrapping
c5=$(post "Priya" "Related: https://example.org/syllables -- different approach, but the same dictionary problem.")
echo "  #${c5}  contains a URL"

# 6: long single unbroken line -- the case most likely to expose an overflow bug
c6=$(post "Tom" "One really long single-paragraph comment that keeps going without any line breaks at all, which is the case most likely to expose a width or overflow problem that a short fixture would never have revealed in the first place, and which is exactly why this fixture exists.")
echo "  #${c6}  long unbroken line"

# 7: inline code and a fenced block, plus a list -- plausible on a maths blog
c7=$(post "Ines" 'Tried the helper on German. It segments on vowel groups, not syllables:

```
>>> split_syllables("Feuerwehr")
['"'"'Feu'"'"', '"'"'er'"'"', '"'"'wehr'"'"']
```

- so the rule is wrong there
- but the dictionary still saves it')
echo "  #${c7}  code, fence, list"

# 8: an email, so the hash/identicon path and the email column get exercised
c8=$(post "Jonas" "Found this via the syndication feed. Subscribe mechanism is a nice touch." )
echo "  #${c8}  extra reader"

echo
echo "Done. ${API}/?uri=${THREAD}"
