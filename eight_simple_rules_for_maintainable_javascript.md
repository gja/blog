All projects start out small. This is true for the javascript part of any web app. In the beginning, it's always easy to read, and easy to debug.

I've put together some of my learnings for client side Javascript

1. Do not let your .js file be the entry point to your code
-----------------------------------------------------------
I've seen this anti pattern in most of the codebases I've inherited.

*The Trap:*
The javascript that binds to the DOM
<script src="https://gist.github.com/3023040.js?file=trap1.js"></script>

This is a trap for multiple reasons:

1. It's really hard to figure out what happened when you clicked on a button. Did some callback get triggered? Where is the code for this?
2. You'll can easily get a bunch of callbacks that interfere with each other. Another page of mine has another button called submit button. I need to make sure that this JS is not loaded on that page
3. This file is almost guaranteed to keep getting bigger and bigger. Cost of change will sky rocket.

*Solution:*
Wrap everything that is binding to an element, and call that from the html
<script src="https://gist.github.com/3023040.js?file=solution1.js"></script>
<script src="https://gist.github.com/3023040.js?file=solution1.html"></script>

2. Understand how *this* works in Javascript
--------------------------------------------
Everything is lexically scoped in Javascript. Except for 'this', which is something that is set depending on how a method is called. Some libraries like jQuery even set the value of 'this' to mean things like the object on which a callback is called.

*The Trap:*
The javascript that binds to the DOM
<script src="https://gist.github.com/3023040.js?file=trap2.js"></script>

Granted, this isn't all that dangerous because it will be obvious that your code is not working.

*The Solution:*
Have a convention for what the current object is. I prefer self.
<script src="https://gist.github.com/3023040.js?file=solution2.js"></script>

3. Structure your JS code into logical units
--------------------------------------------
Javascript is a prototype based language. There are a lot of cool things you can do with a prototype based language, but very few of them will help you write a good UI. Most people take the lack of 'class' keyword in Javascript to mean the lack of Object Orientation.

*The Trap:*
A bunch of methods floating around in space
<script src="https://gist.github.com/3023040.js?file=trap2.js"></script>

This is a trap because you aren't able to logically group related methods together. Functions without 

*The Solution:*
Build some sort of object oriented abstraction over your javascript functions. You can either hand roll your own using javascripts prototype functionality, or you can just drop in something like [class-js](https://github.com/rauschma/class-js/blob/master/Class.js)
<script src="https://gist.github.com/3023040.js?file=solution2.js"></script>

4. Use client side templates to render content
----------------------------------------------



5. Test your javascript
-----------------------
Just because this is javascript, and not the backend code, does not mean that you should ignore your JS. JS faces just as many (if not loads more) regression bugs than your backend code.

*The Trap:*
A lot of code without any test coverage

*The Solution:*
Test your code with something like [jasmine](https://github.com/pivotal/jasmine/). Use one of the addons to jasmine like [jasmine-jquery](https://github.com/pivotal/jasmine-jquery), which lets you bootstrap your tests with a sample DOM, and then run your tests against that DOM.

Check out the [example specs](http://pivotal.github.com/jasmine/)

6. MetaProgramming #ftw
-----------------------

Ruby programmers would already be familiar with some sort of metaprogramming, and JS is almost as powerful. The main feature I miss from ruby is the method_missing.

You can open up a class and add methods:
<script src="https://gist.github.com/3023040.js?file=6monkeypatch.js"></script>

You can use [] like a poor man's send:
<script src="https://gist.github.com/3023040.js?file=6send.js"></script>

You can also us [] to define dynamic methods:
<script src="https://gist.github.com/3023040.js?file=6define.js"></script>


7. Know your javascript libraries
---------------------------------

This could cover multiple blog posts in itself.

Know your options for manipulating the DOM, as well as other things you want to do

As a primer, check out the following projects:

* [knockout.js](http://knockoutjs.com/)
* [ember.js](http://emberjs.com/) (formerly SproutCore)
* [backbone.js](http://backbonejs.org/)
* [underscore.js](http://underscorejs.org/)

8. Use CoffeeScript
-------------------
CoffeeScript is a neat little language that compiles down to JS, and has support for almost all of these features baked right in. It namespaces things for you, and fixes the this/self problem, and provides a lot of the functionality that underscore would provide.

As an additional, it's much less code to read. And it's baked right into rails.

You can read more on [coffeescript.org](http://coffeescript.org/)