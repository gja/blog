Ruby has a rich set of keywords and constructs. Every so often I use one construct when really I meant another one. Here are some constructs which end up being confusing for a beginner:

1. The difference between '&&' and 'and'
----------------------------------------

'&&' and 'and' are identical, except for the precedence of the operator.

'and' and 'or' have very low precedence, just above the control flow operators like if and unless.

When used with a control flow operator, these appear to be identical
# Identical
if true and false; end
if true && false; end

# Identical
foo = bar or raise "exception"
foo = bar || raise "exception"

However, this breaks down when you do something like assignment, whose precedence is between that of 'and' and '&&'

x = true and false
puts x # print out true

x = true && false
puts x # print out false

The rule of thumb that I follow is to always use 'and' and 'or' for control flow, and '&&' and '||' for any binary operations.

In particular, the only place I really ever use 'and' is to quickly exit a method

render(:page) and return unless some_data.present?