class Node
	
	attr_accessor :column, :dividing_value, :results, :true_node, :false_node

	def initialize(params={})
		defaults = {column: nil, dividing_value: nil, results: nil, true_node: nil, false_node: nil}
		params = defaults.merge(params)
		@column = params[:column]
		@dividing_value = params[:dividing_value]
		@results = params[:results]
		@true_node = params[:true_node]
		@false_node = params[:false_node]
	end
	
	def tree_as_string(indent = '')
		output = ''

		if results.nil?

			output << "#{column} : #{dividing_value}?"

			output << "\n#{indent} T-> "
			output << true_node.tree_as_string(indent + '  ')

			output << "\n#{indent} F-> "
			output << false_node.tree_as_string(indent + '  ')
		else
			output << "#{results.keys.first}"
		end
		output
	end
	
	def traverse(choices)
		if results
			results
		elsif compare?(choices[column], dividing_value)
			true_node.traverse(choices)
		else
			false_node.traverse(choices)
		end
	end

	private
	
		def compare?(obj1, obj2)
			if [Fixnum, Float].include?(obj1.class)
				obj1 >= obj2
			else
				obj1 == obj2
			end
		end

end

