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

2. Structure your JS code into logical units
--------------------------------------------
Javascript is a prototype based language. There are a lot of cool things you can do with a prototype based language, but very few of them will help you write a good UI. Most people take the lack of 'class' keyword in Javascript to mean the lack of Object Orientation.

*The Trap:*
A bunch of methods floating around in space
<script src="https://gist.github.com/3023040.js?file=trap2.js"></script>

*The Solution:*
Build some sort of object oriented abstraction over your javascript functions. You can either hand roll your own using javascripts prototype functionality, or you can just drop in something like [class-js](https://github.com/rauschma/class-js/blob/master/Class.js)
<script src="https://gist.github.com/3023040.js?file=solution2.js"></script>