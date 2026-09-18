---
title: "A pointless exercise in counting"
date: 2026-09-18
---

## Nerd sniped by a 5-year-old

The other day, my 5yo poked her head into my office and asked "How long would it
take to count to a million?" I thought for a bit, brushed her off with "a
month," and closed the door. I tried, but failed, to get back into my work.
This post records the outcome of that failure.

After some more thought, I decided the actual question here is

> How many syllables does it take to count to one million?

It's not exactly a question of earth-shattering import, but it did pique my
curiosity. Let's think it through.

## Preliminaries

For consistency, let's all agree to count like adults, rather than like the 5yo
initiator of our current endeavor. I.e., 132 will be pronounced "one hun-dred
thir-ty two," with no "and" or other nonsense. 777,777 is "se-ven hun-dred
se-ven-ty se-ven thou-sand se-ven hun-dred se-ven-ty se-ven." Also, we're going
to call "million" 2 syllables: "mil-lion."

Now, we need some basic building blocks. Let's start small with a tally of
syllables it takes to count from 1 to 99.

- Digits are 1 syllable each, e.g., "two," except "se-ven" (2 syllables).
- Eleven and twelve are 3 and 1 syllables, respectively.
- Numbers in the thirteen to nineteen range are built from a digit(ish), and the
  syllable "-teen"
- Numbers in the twenty to ninety-nine range are built from a digit(ish), the
  syllable "-ty," and another digit.

With these fascinating facts in mind, we can make a handy chart

\[
    \begin{array}{cc}
        \text{range} & \text{syllables} \\
            \hline \\
        1   \to     9     & 10 \\
        10  \to     19   & 20 \\
        20  \to     29   & 30 \\
                \vdots &\vdots \\
        60  \to     69   & 30 \\
        70  \to     79   & 40 \\
        80  \to     89   & 30 \\
        90  \to     99   & 30 \\
    \end{array}
\]

So, the total syllables to count 1 to 99 is:
\[
    10 + 20 + 7 \cdot 30 + 40 = 280
\]

Now, we can reuse what we've learned. To count 100 to 199, we have to say
"one-hun-dred" 100 times, and also say each of the words in 1 to 99. So, it
takes 580 syllables to count 100 to 199. And awaaay we go:

\[
    \begin{array}{cc}
        100 \to 199     &\qquad 580 \\
        200 \to 299     &\qquad 580 \\
        \vdots          &\qquad \vdots \\
        600 \to 699     &\qquad 580 \\
        700 \to 799     &\qquad 680 \\
        800 \to 899     &\qquad 580 \\
        900 \to 999     &\qquad 580 \\
    \end{array}
\]

So, the total syllables to count 1 to 999 is:
\[
    280 + 8 \cdot 580 + 680 = 5,600
\]

## Pattern recognition

Now, it behooves us to take a moment and use our noggins. How does one say a
number in the thousands? Well, they say a number from 1 to 999, then they say
"thou-sand," then they say another number from 1 to 999. This insight will
really let us fly! Instead of getting bogged down going number by number, or
even range by range, we can pull things apart and tally them up more
conveniently.

How many times will we say the numbers in the range 1 to 999? Well, starting
at 1,000, and going to 1,999, we say "one" 1,000 times as a prefix before the
word "thousand." For 2,000 to 2,999, we say "two" 1,000 times. Continuing on, we
say each number in the range 1 to 999 1,000 times as a prefix in the range 1,000
to 999,999. Now we also say each number in the range once as a suffix after the
word "thousand" in the range 1,000 to 1,999. Same for 2,000 to 2,999 and so on.
That gives us 999 reps through the 1 to 999 range in the range 1,000 to 999,999.
If we want extra convenience, we can just think of the original 1 to 999 range
as suffixes with no prefix (or "thousand") and we get 1,000 total reps through
the 1 to 999 range as suffixes.

How many times do we say "thou-sand?" Once for every number from 1,000 to
999,999, i.e., 999,000 times. So, we get:
\[
    \begin{align*}
        1{,}000 \cdot 5{,}600 &= 5{,}600{,}000 \qquad \text{syllables in prefixes} \\
        1{,}000 \cdot 5{,}600 &= 5{,}600{,}000 \qquad \text{syllables in suffixes} \\
        2 \cdot 999{,}000 &= 1{,}998{,}000 \qquad \text{``thou-sand'' 999{,}000 times}
    \end{align*}
\]

Don't forget "one-mil-lion"! Our grand total:
\[
    \begin{array}{rr}
        & 5{,}600{,}000  \\
        & 5{,}600{,}000  \\
        & 1{,}998{,}000 \\
    + \quad & 3 \\
    \hline \\
        & 13{,}198{,}003
    \end{array}
\]

### Aside

The original question was "How long would it take to count to one million?"
Perhaps we should check our guess from earlier, in case the 5yo ever asks this
question again. You may recall counting seconds as a child using the "one
mississippi, two mississippi" method. That's 5 syllables per second(ish).
Probably the best we're going to do. So, it would take
\[
    \begin{array}{rll}
        13{,}198{,}003 \div 5 &= 2{,}639{,}600.6 \quad &\text{seconds} \\
        &\approx 733.2 \quad &\text{hours} \\
        &\approx 30.5 \quad &\text{days}
    \end{array}
\]

My instincts were pretty good with that initial guess! Assuming you can keep
counting for a full month as the delirium from skipping sleeping, eating, and
drinking set in.

## Syllables 2: recurrence relal,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo,ooo {.off-the-edge}

Ahem. Sorry.

The mathematically trained members of the audience may have noticed that we seem
to have a recurrence relation here. E.g., to get to a billion, we can use
prefixes of 1 to 999, suffixes of 1 to 999,999, and say "mil-lion" 999,000,000
times. Since our calculation for the count of syllables to get to a million gave
us all the info needed for the syllables of the suffixes, we can apply that
knowledge in a new calculation. Don't forget to say "one bil-lion" at the end!
So it takes
\[
    \begin{array}{rr}
        &  5{,}600{,}000{,}000 \\
        & 13{,}198{,}000{,}000 \\
        &  1{,}998{,}000{,}000 \\
    + \quad &          3 \\
    \hline \\
        & 20{,}796{,}000{,}003
    \end{array}
\]
syllables to count to one billion.

### Putting together the formula

In general, let \(S(k)\) be the number of syllables needed to count to
\(10^{3k} - 1\) for \(k \in \N\). I recognize that counting to 999,999 is less
satisfying than counting to 1,000,000, but (believe me) it's much more
convenient for the direction I want to take this post, and I'm confident anyone
who's read this far can make the leap from 999,999,999 to 1,000,000,000 manually
if they want to.

The pronunciation of any number in the range \(10^{3(k-1)} \to 10^{3k} - 1\)
can be split into three parts:
- A prefix in the range \(1 \to 999\),
- the scale word for \(10^{3(k-1)}\) (e.g., thousand, million, billion, etc.), and
- a suffix in the range \(1 \to 10^{3(k-1)} - 1\).

For example, 147,893,245,111 has
- **prefix:** "one hundred forty-seven,"
- **scale word:** "billion", and
- **suffix:** "eight hundred ninety-three million, two hundred forty-five
  thousand, one hundred eleven."

#### Prefixes

We'll say each prefix \(10^{3(k-1)}\) times in the range \(10^{3(k-1)} \to
10^{3k} - 1\). To see that, let's use \(p_i\) to denote the numerical value of
the \(i\)-th prefix. So, for the prefix "one hundred forty-seven", we have
\(p_{147} = 147\). We'll say the \(i\)-th prefix once for each number in the
range
\[
    p_i 10^{3(k - 1)} \to (p_i + 1) 10^{3(k - 1)} - 1
\]
We can count the number of reps of the prefix by subtracting everything
*smaller* than the start of the range (since it's inclusive) from the top of the
range:

\[
    (p_i + 1) 10^{3(k - 1)} - 1 - (p_i 10^{3(k - 1)} - 1) = 10^{3(k - 1)}
\]

Note that the \(p_i\) terms have conveniently canceled out. Now, we already have
a count of syllables in the range \(1 \to 999\), and that's 5,600. In our
recurrence relation, that'll be the same as \(S(1)\), so we can write down the
total count of syllables over all the prefixes in \(S(k)\) as

\[
    10^{3(k - 1)} S(1)
\]
Note that we haven't yet needed recurrence.

#### Scale words

The first few scale words are the same number of syllables, i.e., 2:
"thou-sand," "mil-lion," "bil-lion", and "tril-lion". But, once we hit
"quad-ril-lion", things get less consistent. So, let's just say \(s_k\) is the
number of syllables in the scale word for \(10^{3(k - 1)}\) for \(k \in \{2, 3,
4, \ldots\}\). Why the strange choice of index? Well it's a bit arbitrary, but
it makes the formula tidier since this way we can use \(s_k\) in the formula for
\(S(k)\). Now, in the range \(10^{3(k-1)} \to 10^{3k} - 1\), we say the scale
word for \(10^{3(k - 1)}\) once for every number in the range, including the
ends.  As above, we subtract all the numbers *smaller* than the bottom of the
range to find out how many reps we have:
\[
    \begin{align*}
    10^{3k} - 1 - (10^{3(k - 1)} - 1) &= 10^{3k} - 10^{3(k - 1)} \\
        &= 10^3\cdot10^{3(k - 1)} - 10^{3(k - 1)} \\
        &= 999 \cdot 10^{3(k - 1)}
    \end{align*}
\]
So, the total count of syllables over all repetitions of the relevant scale word
in \(S(k)\) is:
\[
    10^{3(k - 1)} \cdot 999 s_k
\]
*Still* no recurrence....

#### Suffixes

How many times do we say each suffix in the range \(10^{3(k-1)} \to 10^{3k} -
1\)? Exactly 999. This is because each suffix occurs exactly once with each
prefix, and there are 999 such prefixes. Recalling our trick earlier, we throw
in an extra repetition of each suffix to account for the range
\(1 \to 10^{3(k - 1)} - 1\) to arrive at a tally of 1,000 repetitions of each
suffix. How many syllables does it take to count each suffix exactly once? I.e.,
how many syllables are there in the range \(1 \to 10^{3(k - 1)} - 1\)? Why
that's just \(S(k - 1)\). Finally! Thus, the total count of syllables
contributed by suffixes when calculating \(S(k)\) is:
\[
    10^3 S(k - 1)
\]

### The formula, at last

Behold, the fruits of our laborious labors! A recurrence relation:
\[
    \begin{align*}
        S(k) &=
        \overbrace{10^{3(k - 1)} S(1)}^{\text{prefixes}}
        + \overbrace{10^3 S(k - 1)}^{\text{suffixes}}
        + \overbrace{10^{3(k - 1)} 999 s_k}^{\text{scale words}} \\ \\
        &= 10^3 S(k - 1) + 10^{3(k - 1)} (S(1) + 999 s_k)
    \end{align*}
\]
for all \(k > 1\). Recall \(S(1) = 5,600\).

Let's check what we've got so far. \(S(2)\) is defined as the number of
syllables to count to \(999,999\). We have:
\[
    \begin{align*}
        S(2) &= 10^3 \cdot 5{,}600 + 10^{3}(5{,}600 + 999 \cdot 2) \\
            &= 5{,}600{,}000 + 5{,}600{,}000 + 1{,}998{,}000 \\
            &= 13{,}198{,}000
    \end{align*}
\]
Check. Now, \(S(3)\) is defined as the number of syllables to count to
\(999{,}999{,}999\). We have:
\[
    \begin{align*}
        S(3) &= 10^3 \cdot 13{,}198{,}000 + 10^{6}(5{,}600 + 999 \cdot 2) \\
            &= 13{,}198{,}000{,}000 + 5{,}600{,}000{,}000 + 1{,}998{,}000{,}000 \\
            &= 20{,}796{,}000{,}000
    \end{align*}
\]

LGTM. Now, we can count to our hearts' content!

\[
    \begin{align*}
        S(4) &= 10^3 \cdot 20{,}796{,}000{,}000 + 10^{9}(5{,}600 + 999 \cdot 2) \\
            &= 20{,}796{,}000{,}000{,}000 + 5{,}600{,}000{,}000{,}000 + 1{,}998{,}000{,}000{,}000 \\
            &= 28{,}394{,}000{,}000{,}000 \\ \\
        S(5) &= 10^3 \cdot 28{,}394{,}000{,}000{,}000 + 10^{12}(5{,}600 + 999 \cdot 2) \\
            &= 35{,}992{,}000{,}000{,}000{,}000
    \end{align*}
\]
Wowsers! We now have a method that lets us easily calculate the number of
syllables it would take to count to 999,999,999,999,999. Now we can say that to
count to "one quad-ril-lion" would take
\[
    S(5) + 4 = 35{,}992{,}000{,}000{,}000{,}004
\]
syllables! Hopefully at least the 5-year-olds in the audience are impressed.

## Teaser for the sequel

"But mathemancer!" you're probably asking, "What if we want to calculate a big
one? Like really big? Say, how many syllables would it take to count to one
vigintillion?? or one centillion??" One centillion is \(10^{303}\), and so we'd
need to calculate \(S(101)\). It would be a bit tedious to calculate all the way
there by stepping through the recurrence relation. Thus, we'll want a closed
formula to calculate these numbers if possible. Luckily, dear reader, one
exists, and it's not hard to find. We'll discuss that next time. We might even
discuss how to peer into the space between nice round numbers like 999,999 and
999,999,999 to figure out how many syllables it takes to count to 123,456,789
(or other similarly exciting numbers). You'll have to come back to see.
