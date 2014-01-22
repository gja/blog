In this blog post, I'll attempt to explain some basic concepts of Functional Programming, using Haskell. You can run most of these examples in ghci, and I'll provide the code in the end.

Simple Overview Of Haskell Syntax
---------------------------------

* List Creation: You can create a list / array using the : operator. This can even be done lazily to get an infinite list. [gist 24df70ad958b0ba87e37 basics-1.hs]
* Defining Function: Looks just like defining a variable, but it takes parameters. The only way it's slightly different from functions that you are used to is that you can do pattern matching to make your code look simpler. Here, I define a method that sums all the elements of a list. [gist 24df70ad958b0ba87e37 basics-2.hs]

The Problem
-----------

You are hercules, about to fight the dreaded Hydra. The Hydra has 9 heads. When a head is chopped off, each head spawns 8 more heads. When one of these 8 heads is cut off, each one spawns out 7 more heads. Chopping one of these spawns 6 more heads, and so on until the weakest head of the hydra will not spawn out any more heads.

Choosing a data structure
-------------------------

Let's choose a simple data structure to represent the hydra. We'll pick an array to represent the heads of the hydra, with the strongest heads at the beginning. The initial state of the Hydra (with 9 level 9 heads) can be represented as follows: ```[9, 0, 0, 0, 0, 0, 0, 0, 0]```.

Chopping off a head
-------------------

The whole point of functional programming is to build small methods and compose them later. Let's first build a specific method to chop off the Hydra's head. We know that chopping off one `level 9` head should result in 8 level 8 heads. This is represented as ```[8, 8, 0, 0, 0, 0, 0, 0, 0]```

Let's build the chop function. It takes 2 arguments, the level of the head in the first position, and the current state of the heads. It will return the state of the heads afterwards.

The below code basically works as follows:

* If we've recursively come to the end, and have run out of heads, return ```[]```
* If there are no heads at the current level, recursively go to the next level
* If you've reached the end, and there are heads in the last position, then just chop it off
* If you find a head, the reduce the count of heads by 1, and increase the heads in the next position by level 1
[gist 24df70ad958b0ba87e37 chop.hs]

Now What?
---------

We've built a function called chop. This is called a pure function because it takes input, and returns some output without modifying any of the inputs.

Here's what we can do next. Let's create a sequence of all the heads, after calling chop multiple times repeatedly.
[gist 24df70ad958b0ba87e37 repeatedly-chop1.hs]

This paradigm is so common, that we have a functional construct that does this: [iterate](( http://hackage.haskell.org/package/base-4.6.0.1/docs/Prelude.html#v:iterate)). We can replace the code with the following equivalent:
[gist 24df70ad958b0ba87e37 repeatedly-chop2.hs]

Truncate that infinite list
---------------------------

Now we have an infinite list of the heads as you make your chops. But we need to stop this once the Hydra is good and dead. We know the hydra is dead when the count of every head is 0.
[gist 24df70ad958b0ba87e37 isdead.hs]

Now, let's keep things in the array as long as the hydra is alive
[gist 24df70ad958b0ba87e37 takewhilealive.hs]

Putting the two together
[gist 24df70ad958b0ba87e37 iteratethroughheads.hs]

Again, these patterns are so common, that we can replace the entire thing with a single line. [any] ((http://zvon.org/other/haskell/Outputprelude/any_f.html)) checks the given condition against elements in the list until it finds one true. [takeWhile](( http://hackage.haskell.org/package/base-4.6.0.1/docs/Prelude.html#v:takeWhile)) keeps things in the list until the first element that doesn't match.
[gist 24df70ad958b0ba87e37 repeatedly-simple.hs]

Finishing up
------------
Now that we have the sequence of chops needed to kill that Hydra, figuring out the number of chops is just a matter of figuring out how long the sequence is.
[gist 24df70ad958b0ba87e37 count-chops.hs]

Extending
---------
Now that we've solved the problem, what next? How easy is it to extend this? Let's add a new requirement. Hercules, though a half god, can only fight at most n Hydra heads at a time. If the number of Hydra heads goes above n, then hercules dies. Let's make a function ```willHerculesDie``` which takes two parameters, n and the Hydra.

Turns out, this is pretty simple. We just need to sum together the count of all the heads. If the sum is more than n at any point, then we return false.
[gist 24df70ad958b0ba87e37 herculeswilldie.hs]

So what next?
-------------
We've built a bunch of really composable functions, and we can look at each one independently to tune the system. With the code we have implemented for chop, Hercules needs to be able to fight 362880 Hydra heads at the same time in order to survive. We can replace chop with a more efficient algorithm

[footer twitter:tdinkar comment:9188785269813520484:5931143789690992852]
