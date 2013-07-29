##Decision Tree

This algorithm takes a set of data with choices and results and creates a decision tree based on the training data. 

This was made for the rubyquiz [here](http://rubyquiz.strd6.com/quizzes/213-decision-tree-learning)

And is based on the algorithm from chapter 7 of [Programming Collective Intelligence](http://www.amazon.com/Programming-Collective-Intelligence-Building-Applications/dp/0596529325/ref=sr_1_1?ie=UTF8&qid=1375076585&sr=8-1&keywords=programming+collective+intelligence)

How to use:

```ruby

RUBYQUIZ_DATA = [
  [:sunny,    85, 85, false, false],
  [:sunny,    80, 90, true,  false],
  [:overcast, 83, 78, false, true ],
  [:rain,     70, 96, false, true ],
  [:rain,     68, 80, false, true ],
  [:rain,     65, 70, true,  false],
  [:overcast, 64, 65, true,  true ],
  [:sunny,    72, 95, false, false],
  [:sunny,    69, 70, false, true ],
  [:rain,     75, 80, false, true ],
  [:sunny,    75, 70, true,  true ],
  [:overcast, 72, 90, true,  true ],
  [:overcast, 81, 75, false, true ],
  [:rain,     71, 80, true,  true ],
]

# can be an two dimensional array, where the last item in each row is the result

c = Classifier.new(RUBYQUIZ_DATA)
top_node = c.build_tree
print top_node.tree_as_string
top_node.traverse([:sunny,    85, 85, false, false])  # => false

```

There are two test suites that come with this , classifier_tests.rb and node_tests.rb

This is still a work in progress