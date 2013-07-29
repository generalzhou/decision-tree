APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('*.rb')].each { |file| require file }

require 'rspec'

describe 'Node' do
	
	before(:each) do
		@true_node = double('true node', tree_as_string: 'true_node')
		@false_node = double('false node', tree_as_string: 'false_node')
		@decision_node = Node.new({column:0, dividing_value:'yes', true_node: @true_node, false_node: @false_node})
		@result_node = Node.new({results: {'test' => 1}})
	end

	describe '#tree_as_string' do

		it 'should print out a decision node with the correct column and dividing value' do
			output = @decision_node.tree_as_string
			output.should match /0/
			output.should match /yes/
		end

		it 'should print out a decision node with the correct true and false nodes' do
			output = @decision_node.tree_as_string
			output.should match /true_node/
			output.should match /false_node/
		end		

		it 'should print out a leaf node with the correct result' do
			output = @result_node.tree_as_string
			output.should match /test/
		end
	
	end
	
	describe '#traverse' do

		it 'should return the result of the result node' do
			@result_node.traverse('anything').should == {'test' => 1}
		end

		it 'should return the true result when given the right decision' do
			@decision_node.true_node = @result_node
			@decision_node.traverse(['yes']).should == {'test' => 1}
		end

	end


end