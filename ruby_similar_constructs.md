Ruby has a rich set of keywords and constructs. Every so often I use one construct when really I meant another one. Here are some constructs which end up being confusing for a beginner:

1. The difference between 'do/end' and '{/}'
--------------------------------------------

Most people believe that the two ways of creating a ruby block are the same, or that 'do/end' is for multi line blocks and '{/}' are suitable for shorter blocks. While this is a good convention to follow, there is also a technical difference between the two.

From an [excellent answer](http://stackoverflow.com/a/6179505) on stack overflow, the major difference is precedence:

[gist 3065544 block1.rb]

This is not so bad usually, but it does end up in some weirdness at times. My pet peeve is that the following does not work:

[gist 3065544 block_scope.rb]

2. The difference between '&&' and 'and'
----------------------------------------

'&&' and 'and' are identical, except for the precedence of the operator.

'and' and 'or' have very low precedence, just above the control flow operators like if and unless.

When used with a control flow operator, these appear to be identical
[gist 3065544 and_similar.rb]

However, this breaks down when you do something like assignment, whose precedence is between that of 'and' and '&&'

[gist 3065544 and_different.rb]

The rule of thumb that I follow is to always use 'and' and 'or' for control flow, and '&&' and '||' for any binary operations.

In particular, the only place I really ever use 'and' is to quickly exit a method

[gist 3065544 and_render.rb]

3. The difference between procs and lambdas
-------------------------------------------

I'm expanding on the excellent [guide ruby's procs and lambdas](http://www.robertsosinski.com/2008/12/21/understanding-ruby-blocks-procs-and-lambdas/)

4. The difference between blocks and procs
------------------------------------------

At an initial glimpse, blocks and procs also seem to be identical



[footer twitter:tdinkar comment:9188785269813520484:6206207623429215272]
