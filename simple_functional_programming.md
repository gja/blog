Simple Functional Programming
=============================

In this blog post, I'll attempt to explain some basic concepts of Functional Programming, using Haskell. You can run most of these examples in ghci, and I'll provide the code in the end.

*Simple Overview Of Haskell Syntax*

* List Creation: You can create a list / array using the : operator. This can even be done lazily to get an infinite list.
```haskell
let firstArray = 0:1:[2, 3]
-- [0, 1, 2, 3]
let infiniteOnes = 1:infiniteOnes
-- [1, 1, 1, 1, 1, ........................] never stops, hit ctrl-C to get your interpreter back
```

* Defining Function: Looks just like defining a variable, but it takes parameters. The only way it's slightly different from functions that you are used to is that you can do pattern matching to make your code look simpler. Here, I define a method that sums all the elements of a list.
```haskell
sumOfElements []     = 0
sumOfElements (x:xs) = x + sumOfElements xs
```

*The Problem*

You are hercules, about to fight the dreaded Hydra. The Hydra has 9 heads. When a head is chopped off, each head spawns 8 more heads. When one of these 8 heads is cut off, each one spawns out 7 more heads. Chopping one of these spawns 6 more heads, and so on until the weakest head of the hydra will not spawn out any more heads.

*Choosing a data structure*

Let's choose a simple data structure to represent the hydra. We'll pick an array to represent the heads of the hydra, with the strongest heads at the beginning. The initial state of the Hydra (with 9 level 9 heads) can be represented as follows: ```[9, 0, 0, 0, 0, 0, 0, 0, 0]```.

*Chopping off a head*

The whole point of functional programming is to build small methods and compose them later. Let's first build a specific method to chop off the Hydra's head. We know that chopping off one `level 9` head should result in 8 level 8 heads. This is represented as ```[8, 8, 0, 0, 0, 0, 0, 0, 0]```

Let's build the chop function. It takes 2 arguments, the level of the head in the first position, and the current state of the heads. It will return the state of the heads afterwards.

The below code basically works as follows:

* If we've recursively come to the end, and have run out of heads, return ```[]```
* If there are no heads at the current level, recursively go to the next level
* If you've reached the end, and there are heads in the last position, then just chop it off
* If you find a head, the reduce the count of heads by 1, and increase the heads in the next position by ```level - 1```

```haskell
chop level []       = []
chop level (0:xs)   = 0 : chop (level - 1) xs
chop level [x]      = [x - 1]
chop level (x:y:xs) = (x - 1) : (y + level - 1) : xs
----------------------------------------------------
chop 9 [9, 0, 0, 0, 0, 0, 0, 0, 0]
-- [8, 8, 0, 0, 0, 0, 0, 0, 0]
chop 9 [8, 8, 0, 0, 0, 0, 0, 0, 0]
-- [7, 16, 0, 0, 0, 0, 0, 0, 0]
chop 9 [0, 0, 0, 0, 0, 0, 0, 0, 1]
-- [0, 0, 0, 0, 0, 0, 0, 0, 0]
```

*Now What?*

We've built a function called chop. This is called a pure function because it takes input, and returns some output without modifying any of the inputs.

Here's what we can do next. Let's create a sequence of all the heads, after calling chop multiple times repeatedly.

```haskell
repeatedlyChop heads = heads:repeatedlyChop (chop 9 heads)
----------------------------------------------------------
repeatedlyChop [9, 0, 0, 0, 0, 0, 0, 0, 0]
-- [[9,0,0,0,0,0,0,0,0],[8,8,0,0,0,0,0,0,0],[7,16,0,0,0,0,0,0,0],[6,24,0,0,0,0,0,0,0],[5,32,0,0,0,0,0,0,0], ...] this is an infinite list
```

This paradigm is so common, that we have a functional construct that does this: [iterate](( http://hackage.haskell.org/package/base-4.6.0.1/docs/Prelude.html#v:iterate)). We can replace the code with the following equivalent: ```repeatedlyChop heads = iterate (chop 9) heads```

*Truncate that infinite list*

Now we have an infinite list of the heads as you make your chops. But we need to stop this once the Hydra is good and dead. We know the hydra is dead when the count of every head is 0.

```haskell
isDead []     = True
isDead (0:xs) = isDead xs
isDead (x:xs) = False
-------------------------
isDead [9, 0, 0, 0, 0, 0, 0, 0, 0] -- False
isDead [0, 0, 0, 0, 0, 0, 0, 0, 0] -- True
```

Now, let's keep things in the array as long as the hydra is alive
```haskell
takeWhileAlive (x:xs) = if isDead x then [] else x:(takeWhileAlive xs)
```

Putting the two together
```haskell
repeatedlyChopTillDead heads = takeWhileAlive (repeatedlyChopTillDead heads)
-----------------------------------------------------------------
iterateThroughHeads [0, 0, 0, 0, 0, 0, 1, 0, 0]
-- [[0,0,0,0,0,0,1,0,0],[0,0,0,0,0,0,0,2,0],[0,0,0,0,0,0,0,1,1],[0,0,0,0,0,0,0,0,2],[0,0,0,0,0,0,0,0,1]]
```

Again, these patterns are so common, that we can replace the entire thing with a single line. [any] ((http://zvon.org/other/haskell/Outputprelude/any_f.html)) checks the given condition against elements in the list until it finds one true. [takeWhile](( http://hackage.haskell.org/package/base-4.6.0.1/docs/Prelude.html#v:takeWhile)) keeps things in the list until the first element that doesn't match.

```haskell
repeatedlyChopTillDead heads = takeWhile (any (/= 0)) (iterate (chop 9) heads)
```

*Finishing up*
Now that we have the sequence of chops needed to kill that Hydra, figuring out the number of chops is just a matter of figuring out how long the sequence is.

```haskell
countOfChops heads = length (repeatedlyChop heads)
--------------------------------------------------
countOfChops [0, 0, 0, 0, 0, 0, 0, 0, 1] -- 1
countOfChops [0, 0, 0, 0, 0, 0, 1, 0, 0] -- 5
countOfChops [9, 0, 0, 0, 0, 0, 0, 0, 0] -- 986409 (this takes a while)
```

*Extending*
Now that we've solved the problem, what next? How easy is it to extend this? Let's add a new requirement. Hercules, though a half god, can only fight at most n Hydra heads at a time. If the number of Hydra heads goes above n, then hercules dies. Let's make a function ```willHerculesDie``` which takes two parameters, n and the Hydra.

Turns out, this is pretty simple. We just need to sum together the count of all the heads. If the sum is more than n at any point, then we return false.

```haskell
willHerculesDie n heads = any (> n) (map sum (repeatedlyChopTillDead heads))
----------------------------------------------------------------------------
willHerculesDie 6 [0, 0, 0, 0, 0, 1, 0, 0, 0] -- False
willHerculesDie 5 [0, 0, 0, 0, 0, 1, 0, 0, 0] -- True
```

*So what next*
We've built a bunch of really composable functions, and we can look at each one independently to tune the system. With the code we have implemented for chop, Hercules needs to be able to fight 362880 Hydra heads at the same time in order to survive. We can replace chop with a more efficient algorithm
