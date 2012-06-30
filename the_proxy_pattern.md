Problem Statement
-----------------
I have a method which does something great, and is nice and small. It does everything i want, except some small feature that isn't core to the class. For example, I want to do some fudging for the input parameters and/or fudging the output parameters. I want to create another class to handle these orthogonal requirements.

TL;DR - Short summary
---------------------
Wrap the original object in a proxy which looks like the original object to the outside world. Delegate calls to the original object eventually. This is an example of Aspect Oriented Programming.

Code Example
------------
I'm building this example up as a series of requirements

Requirement 1: I want to be able to get my bank balance from the bank.
<script src="https://gist.github.com/3022255.js?file=bank.rb"></script>

Requirement 2: I want to be able to log the fact someone has checked their bank balance
<script src="https://gist.github.com/3022255.js?file=bank2.rb"></script>

Requirement 3: I want to tell everyone that their bank balance is double of what it is really. But logging should log the correct value.
<script src="https://gist.github.com/3022255.js?file=bank3.rb"></script>

Requirement 4: I've changed my mind. It's hard for me to have plausible deniability if i log actual bank balances. Fudge that as well
<script src="https://gist.github.com/3022255.js?file=bank4.rb"></script>

Requirement 5: I want to cache the balance. I still expect logging and doubling.
<script src="https://gist.github.com/3022255.js?file=bank5.rb"></script>

A note on the example: Requirement 3 (the doubling filter) should probably go into the first class, it's core to the business. I just made it a proxy filter to illustrate the point about output fudging.

Conditions for a good proxy
---------------------------
* The constructor accepts the item it is proxying.
* The proxy passes requests to the original object in at least one branch of the code
* The proxy honors all methods of the original object with the same signature (in java world, implements the same interface)
* Proxies must be composable (this will follow from the point above): Proxy1.new(Proxy2.new(Proxy3.new(object)))
* That does not mean the order of proxies is immaterial

Practical Uses
--------------
* A proxy that caches the response from the inner method
* A proxy that runs the inner method in a single database transaction
* A proxy that adds logging before and after the method is called
* A proxy that validates inputs

DynamicProxy
------------
In the examples above, we overrode a single method bank_balance. Now, imaging you want a proxy to overwrite 50 different methods of an object. Enter DynamicProxy for java, and DynamicProxy/SimpleProxy for .NET. These let you override all methods in a particular interface.

Of course, ruby doesn't need that thanks to method_missing!
<script src="https://gist.github.com/3022255.js?file=dynamicproxy.rb"></script>

Rack filters
------------
Rack provides an easy way to add proxy pattern to the app called via filters (rails cleans this up as around filters). A filter which does nothing will be as follows (notice what the constructor accepts, and what methods the filter implements)
<script src="https://gist.github.com/3022255.js?file=rack.rb"></script>

Further Reading
---------------
* [http://en.wikipedia.org/wiki/Proxy_pattern](http://en.wikipedia.org/wiki/Proxy_pattern)
* [http://en.wikipedia.org/wiki/Aspect-oriented_programming](http://en.wikipedia.org/wiki/Aspect-oriented_programming)