In this blog post, I'll attempt to explain some basic concepts of Functional Programming, using Haskell.

You can run most of these examples in ghci, and you can find a gist with all code samples in the end.

Many thanks to [Mattox Beckman](http://www.iit.edu/csl/cs/faculty/beckman_mattox.shtml) for coming up with the programming exercise, and Junjie Ying for coming finding a better data structure for this explanation than I came up with.

The Problem
-----------
You are Hercules, about to fight the dreaded Hydra. The Hydra has 9 heads. When a head is chopped off, it spawns 8 more heads. When one of these 8 heads is cut off, each one spawns out 7 more heads. Chopping one of these spawns 6 more heads, and so on until the weakest head of the hydra will not spawn out any more heads.

Our job is to figure out how many chops Hercules needs to make in order to kill all heads of the Hydra. And no, it's not n!.

Prelude: Simple Overview Of Haskell Syntax
---------------------------------
Before we dive into code, i'll explain a few constructs which are unique to Haskell, so it's easy for non Haskellers.

* List Creation: You can create a list / array using the : operator. This can even be done lazily to get an infinite list.
[gist 24df70ad958b0ba87e37 basics-1.hs]
* Defining Function: Looks just like defining a variable, but it takes parameters. One way they are different from other languages is the ability to do pattern matching to simplify your code. Here, I define a method that sums all the elements of a list.
[gist 24df70ad958b0ba87e37 basics-2.hs]
* More List Foo: Adding lists can be done with ++. Checking if a list is empty can be done with null. You can use replicate to create a list with the same elements over and over.
[gist 24df70ad958b0ba87e37 basics-3.hs]


Choosing a data structure
-------------------------
Let's choose a simple data structure to represent the hydra. We'll pick an array to represent the heads of the Hydra, using the `level` of each head as the value. The initial state of the Hydra (with 9 `level 9` heads) can be represented as follows: ```[9, 9, 9, 9, 9, 9, 9, 9, 9]```.

Chopping off a head
-------------------
The whole point of functional programming is to build small functions and compose them later. We'll build a few functions, specific to our domain, and a few more general ones to orchestrate.

Let's first build a specific function to chop off the Hydra's head. We know that chopping off one ```level 9``` head should result in 8 ```level 8``` heads (and 8 of the original ```level 9``` heads). This is represented as ```[8, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 9, 9]```

Let's build the chop function. It takes a single argument, and the current levels of the all live heads. It will return the state of the heads after chopping the first one.

The three lines of code below map to these rules:

* If there are no heads left, just return ```[]```
* If we find that there is a level 1 head at the start of our list, just chop it off and return the rest of the array
* If we find that there is a higher level head at the start of our list, spawn n - 1 heads in it's place

[gist 24df70ad958b0ba87e37 chop.hs]

Repeatedly chopping heads
-------------------------
Our function chop is a pure function as, given some input, it always returns the same output, without any sort of side effects. Side effects is a general term for modifying inputs / IO Operations / DB Calls, and so on.

Since chop is pure function, we can safely call it over and over. Let's build a list where each element is the result of chopping the previous element.
[gist 24df70ad958b0ba87e37 repeatedly-chop1.hs]


This paradigm is so common, that we have a functional construct that does this: [iterate]( http://hackage.haskell.org/package/base-4.6.0.1/docs/Prelude.html#v:iterate). We can replace the above code with the following:
[gist 24df70ad958b0ba87e37 repeatedly-chop2.hs]

Truncate that infinite list
---------------------------
Great, we now have built a list of all the states the Hydra is in while Hercules is busy chopping away at it. However, this list goes on forever (we never put in a termination condition in the earlier code), so let's do that now.

We can use a simple empty check (null) to test if the hydra is still alive. Let's keep items as long as the Hydra is alive
[gist 24df70ad958b0ba87e37 takewhilealive.hs]

Putting the two together
[gist 24df70ad958b0ba87e37 iteratethroughheads.hs]

Again, these patterns are so common, that we can replace the entire thing with a single line. [takeWhile]( http://hackage.haskell.org/package/base-4.6.0.1/docs/Prelude.html#v:takeWhile) keeps things in the list until the first element that doesn't match.
[gist 24df70ad958b0ba87e37 repeatedly-simple.hs]

Finishing up
------------
Now that we have the sequence of chops needed to kill that Hydra, figuring out the number of chops is just a matter of figuring out how long the sequence is.
[gist 24df70ad958b0ba87e37 count-chops.hs]

Extending
---------
Now that we've solved the problem, what next? How easy is it to extend this? Let's add a new requirement: Hercules, though a half god, can only fight at most n Hydra heads at a time. If the number of Hydra heads goes above n, then hercules dies. Let's make a function ```willHerculesDie``` which takes two parameters, n and the Hydra.

Turns out, this is pretty simple. We just need to count all the heads that are alive. If the count is more than n at any point, then we return true, and Hercules dies.
[gist 24df70ad958b0ba87e37 herculeswilldie.hs]

So what next?
-------------
We've built a bunch of really composable functions, and we can look at each one independently to tune the system.

You can get Haskell set up with the [Haskell Platform](http://www.haskell.org/platform/) and play around with the code [here](https://gist.github.com/gja/24df70ad958b0ba87e37/#file-hydra-hs).

Some great books you can check out:

* [Structure and Interpretation of Computer Programs](http://mitpress.mit.edu/sicp/full-text/book/book.html)
* [Learn you a Haskell for Great Good](http://learnyouahaskell.com/) - Greatest Haskell Tutorial out there
* [Functional Programming for the Object-Oriented Programmer](https://leanpub.com/fp-oo)

[footer twitter:tdinkar hacker_news:7113259 comment:9188785269813520484:5931143789690992852]
