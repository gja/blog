All projects start out small. This is true for the javascript part of any web app. In the beginning, it's always easy to read, and easy to debug.

I've put together some of my learnings for client side Javascript

1. Do not let your .js file be the entry point to your code
-----------------------------------------------------------
I've seen this anti pattern in most of the codebases I've inherited.

*The Trap:*
The javascript that binds to the DOM
[gist 3023040 trap1.js]

This is a trap for multiple reasons:

1. It's really hard to figure out what happened when you clicked on a button. Did some callback get triggered? Where is the code for this?
2. You'll can easily get a bunch of callbacks that interfere with each other. Another page of mine has another button called submit button. I need to make sure that this JS is not loaded on that page
3. It's not possible to compile all your javascript assets into a single application.js

*Solution:*
Wrap everything that is binding to an element, and call that from the html
[gist 3023040 solution1.js]
[gist 3023040 solution1.html]

Binding things in the HTML helps you keep in your head what is going on in a particular page. It also helps you answer things like how an element is bound (was it ".submit-button", "#page-submit-button", or "form > .submit-button"), and makes sure that it's easy to find when searching for code later.

*Caveat:*
One caveat to look out for is the order of loading of JavaScript files. The above code requires jQuery loaded for $(document).ready() to work. One alternative is to use window.onLoad(), though that waits for the entire DOM and assets to load.

2. Understand how *this* works in Javascript
--------------------------------------------
Everything is lexically scoped in Javascript. Except for 'this', which is something that is set depending on how a method is called. Some libraries like jQuery even set the value of 'this' to mean things like the object on which a callback is called.

*The Trap:*
Using a this pointer that's pointing at the wrong object.
[gist 3023040 trap2.js]

Granted, this isn't all that dangerous because it will be obvious that your code is not working.

*The Solution:*
Have a convention for what the current object is. I prefer self.
[gist 3023040 solution2.js]

3. Structure your JS code into logical units
--------------------------------------------
Javascript is a prototype based language. There are a lot of cool things you can do with a prototype based language, but very few of them will help you write a good UI. Most people take the lack of 'class' keyword in Javascript to mean the lack of Object Orientation.

*The Trap:*
A bunch of methods floating around in space
[gist 3023040 trap3.js]

This is a trap because you aren't able to group logically related methods together. This would be similar to a bunch of static methods on your server side.

*The Solution:*
Build some sort of object oriented abstraction over your javascript functions. You can either hand roll your own using javascripts prototype functionality, or you can just drop in something like [class-js](https://github.com/rauschma/class-js/blob/master/Class.js)
[gist 3023040 solution3.js]

4. Use client side templates to render content
----------------------------------------------

Again, this can go into another blog post by itself, and I'll be writing about this soon.

*The Trap:*
Having your server return HTML output as the response to an AJAX request, and having the client just dump it into the DOM somewhere

*The Solution:*
Use something like [Mustache.js](http://mustache.github.com/) to render your server side template. I'll be posting more about this soon.

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
[gist 3023040 6monkeypatch.js]

You can use [] like a poor man's send:
[gist 3023040 6send.js]

You can also use [] to define dynamic methods:
[gist 3023040 6define.js]


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

As an additional benefit, it's much less code to read. And it's baked right into rails.

You can read more on [coffeescript.org](http://coffeescript.org/)

[footer twitter:tdinkar hacker_news:4194066]
