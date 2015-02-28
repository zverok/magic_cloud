FIXME: rectangular vs archimedean
FIXME: colorbrewer https://github.com/mbostock/d3/blob/master/lib/colorbrewer/colorbrewer.js

Overview
--------

Usage
-----

```ruby

```

Resulting in:

img

Origins
-------

At first, it was straightforward port of `d3.layout.cloud.js` by Jason
Davies, which, I assume, is an implementation of Wordle algorithm.

Then there was major refatoring, to make code correspond to Ruby
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
image, size 700×500, are typically generated in <10sec. It's not that cool,
yet not to long for you to fell asleep.

Performance degrades significantly with each word, so 150-words cloud seems
to be ~10 times slower than 50-words.

Major performance eater is perfect collision detection, which Wordle-like
cloud needs. MagicCloud for now uses really dumb algortihm with some
not-so-dumb optimizations. You can look into 
`lib/magic_cloud/collision_board.rb` - everything can be optimized is 
there; especially in `CollisionBoard#collides?` method.

I assume, for example, that naive rewriting of code in there as a C
extension can help significantly.

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
cloud = MagicCloud.new(words, width, height){|conf|
  conf.palette = palette
  conf.rotate = rotate
}

# or
cloud = MagicCloud.new(words, width, height, palette: palette, rotate: rotate)

```

* Palette (default is `:color20`):
  * `:color10`, `:color20`, ... - from d3 []
  * `:rainbow` - some pretty rainbow palette sample, generated on []
  * `[array, of, colors]` - each color should be hex color, or any other RMagick color string: []
  * any object, responding to `color(tag, index)` - so, you can make color 
    depend on tag text, not only on its number in tags list
* Rotate:
  * `:square` (only horizontal and vertical words) - it's default
  * `:none` - all words are horizontal (looks boooring)
  * `:free` - any word rotation angle, looks cool, but not very readable
    and slower to layout
  * `[array, of, angles]` - each of possible angle should be number 0..360
  * any lambda, accepting `(tag, index)` and returning 0..360
  * any object, responding to `rotate(tag, index)` and returning 0..360
* Scale - how word sizes would be scaled to fit into (FONT_MIN..FONT_MAX) range:
  * `:no` - no scaling, all word sizes are treated as is;
  * `:linear` - linear scaling (default);
  * `:log` - logarithmic scaling;
  * `:sqrt` - square root scaling.

Services
--------

*Scaling*:

* `MagicCloud::Scale.linear`
* `MagicCloud::Scale.logarithmic`
