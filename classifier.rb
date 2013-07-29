require File.expand_path('../node', __FILE__)
require File.expand_path('../data', __FILE__)

class Classifier
	
	attr_accessor :data

	def initialize(data)
		@data = data
	end

	# recursively builds nodes with the optimal dividing params and returns the top node
	def build_tree(data_set=data)
		current_entropy = entropy(data_set)
		node_params = get_optimal_params(data_set, current_entropy)
		create_node(node_params, data_set)
	end

	private

		def create_node(node_params, data_set)
			if node_params[:best_gain] > 0
				true_branch = build_tree(node_params[:true_set])
				false_branch = build_tree(node_params[:false_set])
				Node.new(node_params.merge({true_node: true_branch, 
									false_node: false_branch}))
			else
				Node.new({results: count_results(data_set)})
			end
		end

		# scans the current data set for the attribute (column) and dividing value that
		# best divides the results, according to the information gain property
		def get_optimal_params(data_set, current_entropy)
			optimal_params = {best_gain: 0.0}
			num_attributes = data_set[0].size - 1 #last column is the result	

			(0..(num_attributes - 1)).each do |column_index|
			
				attribute_values(column_index).each do |divider_value|
			
					true_set, false_set = divide_set(column_index, divider_value, data_set)
					gain = information_gain(true_set, false_set, current_entropy)

					if gain > optimal_params[:best_gain]
						optimal_params.merge!({
							best_gain: gain,
							column: column_index,
							dividing_value: divider_value,
							true_set: true_set,
							false_set: false_set
						})
					end
				end
			end
			optimal_params
		end

		def attribute_values(column_number)
			data.map { |row| row[column_number] }
		end

		def information_gain(true_set, false_set, current_entropy)
			true_set_ratio = true_set.size / (true_set + false_set).size
			weighted_true_set_entropy = true_set_ratio * entropy(true_set)
			weighted_false_set_entropy = (1 - true_set_ratio) * entropy(false_set)		
			current_entropy - weighted_true_set_entropy - weighted_false_set_entropy
		end

		# divides the data into true or false sets
		# based on the attribute at the column, compared to the divider_value
		def divide_set(column, divider_value, data_set=data)
			true_set = []
			false_set = []

			data_set.each do |row|
				if compare?(row[column], divider_value)
					true_set << row
				else
					false_set << row
				end
			end
			[true_set, false_set]	
		end

		# calculates entropy of the true/false sets created by the divide_set
		# p(i) = frequency = count(i) / count(total)
		# entropy = sum(p(i) * log_2(p(i)) for all different outcomes
		def entropy(data_set)
			unique_counts = count_results(data_set)
			total_count = unique_counts.values.inject(:+)
			unique_counts.values.inject(0) do |entropy, count|
				frequency = count.to_f / total_count
				entropy - (frequency * log_2(frequency))
			end
		end

		# compares using >= for numbers, == for everything else
		def compare?(obj1, obj2)
			if [Fixnum, Float].include?(obj1.class)
				obj1 >= obj2
			else
				obj1 == obj2
			end
		end

		# creates a hash mapping result => count
		def count_results(data_set)
			data_set.inject({}) do |count, row|
				count[row[-1]] ||= 0
				count[row[-1]] += 1
				count
			end
		end

		def log_2(x)
			Math.log(x) / Math.log(2)
		end

end