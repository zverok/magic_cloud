MagicCloud - simple pretty word cloud for Ruby
==============================================

[![Gem Version](https://badge.fury.io/rb/magic_cloud.svg)](http://badge.fury.io/rb/magic_cloud)

**MagicCloud** is simple, pure-ruby library for making pretty
[Wordle](http://www.wordle.net/)-like clouds. It uses RMagick as graphic
backend.

Usage
-----

```ruby
words = [
  [test, 50],
  [me, 40],
  [tenderly, 30],
  # ....
]
cloud = MagicCloud::Cloud.new(words, rotate: :free, scale: :log)
```

Or from command-line:

```
./bin/magic_cloud --textfile samples/cat-in-the-hat.txt -f test.png --rotate free --scale log
```

Resulting in:

<img src="https://raw.github.com/zverok/magic_cloud/master/samples/cat.png" alt="Sample word cloud"/>

Installation
------------

```
gem install magic_cloud
```

rmagick is requirement, and it needs compilation, so you may expect
problems in non-compiler-friendly environment (Windows).

Origins
-------

At first, it was a straightforward port of [d3.layout.cloud.js](https://github.com/jasondavies/d3-cloud)
by Jason Davies, which, I assume, is an implementation of Wordle algorithm.

Then there was major refactoring, to make code correspond to Ruby
standards (and be understandable to poor dumb me).

Then collision algorithm was rewritten from scratch.

And now we are here.

References:
* https://github.com/jasondavies/d3-cloud
* http://stackoverflow.com/questions/342687/algorithm-to-implement-a-word-cloud-like-wordle
* http://static.mrfeinberg.com/bv_ch03.pdf

Performance
-----------

It's reasonable for me. On my small Thinkpad E330, some 50-words cloud 
image, size 700×500, are typically generated in <3sec. It's not that cool,
yet not too long for you to fell asleep.

The time of cloud making depends on words count, size of image
(it's faster to find place for all words on larger image) and used rotation
algorithm (vertical+horizontal words only is significantly faster - and,
on my opinion, better looking - than "cool" free-rotated-words cloud). It
even depends on font - dense font like Impact takes more time to lay
out than sparse Tahoma.

Major performance eater is perfect collision detection, which Wordle-like
cloud needs. MagicCloud for now uses really dumb algorithm with some
not-so-dumb optimizations. You can look into 
`lib/magic_cloud/collision_board.rb` - everything can be optimized is 
there; especially in `CollisionBoard#collides?` method.

I assume, for example, that naive rewriting of code in there as a C
extension would help significantly.

Another possible way is adding some smart tricks, which eliminate as much
of pixel-by-pixel comparisons as possible (some of already made are
criss-cross intersection check, and memoizing of last crossed sprite).

Memory effectiviness
--------------------

Basically: it's not. 

Plain Ruby arrays are used to represent collision bitmasks (each array 
member stand for 1 bit), so, for example, 700×500 pixel cloud will requre 
collision board size `700*500` (i.e. 350k array items only for board, and
slightly less for all sprites).

It should be wise to use some packing (considering each Ruby Fixmnum can
represent not one, but whole 32 bits). Unfortunately, all bit array 
libraries I've tried are causing major slowdown of cloud computation. 
With, say, 50 words we'll have literally millions of operation 
`bitmask#[]` and `bitmask#[]=`, so, even methods 
like `Fixnum#&` and `Fixnum#|` (typically used for bit array representation)
are causing significant overload.

Configuration
-------------

```ruby
cloud = MagicCloud.new(words, palette: palette, rotate: rotate)
```

* `:palette` (default is `:color20`):
  * `:category10`, `:category20`, ... - from (d3)[https://github.com/mbostock/d3/wiki/Ordinal-Scales#categorical-colors]
  * `[array, of, colors]` - each color should be hex color, or any other RMagick color string (See "Color names at http://www.imagemagick.org/RMagick/doc/imusage.html)
  * any lambda, accepting `(word, index)` and returning color string
  * any object, responding to `color(word, index)` - so, you can make color 
    depend on tag text, not only on its number in tags list
* `:rotate` - rotation algorithm:
  * `:square` (only horizontal and vertical words) - it's default
  * `:none` - all words are horizontal (looks boooring)
  * `:free` - any word rotation angle, looks cool, but not very readable
    and slower to layout
  * `[array, of, angles]` - each of possible angle should be number 0..360
  * any lambda, accepting `(word, index)` and returning 0..360
  * any object, responding to `rotate(word, index)` and returning 0..360
* `:scale` - how word sizes would be scaled to fit into (FONT_MIN..FONT_MAX) range:
  * `:no` - no scaling, all word sizes are treated as is;
  * `:linear` - linear scaling (default);
  * `:log` - logarithmic scaling;
  * `:sqrt` - square root scaling;
* `:font_family` (Impact is default).
* `:font_source` - Full path to custom font file. Overwrite `:font_family`.

Current state
-------------

This library is extracted from a real-life project. It should be
pretty stable (apart from bugs introduced during extraction and gemification).

What it really lacks for now, is thorough (or any) testing, and
some more configuration options.

Also, while core algorithms (collision_board.rb, layouter.rb) are pretty
accurately written and documented, "wrapping code" (options parsing and
so on) are a bit more chaotic - it's subject to refactor and cleanup.

All feedback, usage examples, bug reports and feature requests are appreciated!
