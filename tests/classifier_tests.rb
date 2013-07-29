APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
Dir[APP_ROOT.join('*.rb')].each { |file| require file }

require 'rspec'

describe 'Classifier' do

	before(:each) do
		@data = OREILLY_DATA
		@c = Classifier.new(@data)
	end

	describe '#build_tree' do

		before(:each) do
			@tree = @c.build_tree
		end

		it 'should build a tree where leaf nodes only have one item in the result set' do
			nodes = [@tree]
			nodes.each do |node|
				if node.results
					node.results.keys.size.should == 1
				else
					nodes << node.true_node << node.false_node
				end
			end
		end

		it 'should built a tree where each node has children or results, not both' do
			nodes = [@tree]
			nodes.each do |node|
				if node.results
					(node.true_node.nil? && node.false_node.nil?).should == true
				else
					(node.true_node.nil? && node.false_node.nil?).should == false
				end
			end
		end

		it 'should build a tree that predicts results of the training set with 100% accuracy' do
			@data.each do |row| 
				@tree.traverse(row).keys.first.should == row.last
			end
		end
	end


	# describe 'divide_set' do
	# 	before(:each) do
	# 		@nonnumerical_column = 0
	# 		@numerical_column = 3
	# 	end

	# 	context 'numerical values' do
	# 		before(:each) do
	# 			@divider_value = 20
	# 			@true_set, @false_set = @c.divide_set(@numerical_column, @divider_value, @c.data)
	# 		end

	# 		it "should return a true set with values for #{@numerical_column} >= #{@divider_value}" do
	# 			@true_set.each { |row| row[@numerical_column].should >= @divider_value }
	# 		end

	# 		it "should return a false set with values for #{@numerical_column} < #{@divider_value}" do
	# 			@false_set.each { |row| row[@numerical_column].should < @divider_value }
	# 		end
	# 	end

	# 	context 'non numerical values' do
	# 		before(:each) do
	# 			@divider_value = 'slashdot'
	# 			@true_set, @false_set = @c.divide_set(@nonnumerical_column, @divider_value, @c.data)
	# 		end

	# 		it "should return a true set with values for #{@nonnumerical_column} == #{@divider_value}" do
	# 			@true_set.each { |row| row[@nonnumerical_column].should == @divider_value }
	# 		end

	# 		it "should return a false set with values for #{@nonnumerical_column} != #{@divider_value}" do
	# 			@false_set.each { |row| row[@nonnumerical_column].should_not == @divider_value }
	# 		end
	# 	end
	# end

	# describe 'entropy' do
		
	# 	before(:each) do 
	# 		# from OREILLY_DATA, using divide_set(2, 'yes', @c.data)
	# 		@true_set = [["slashdot", "USA", "yes", 18, "None"],
	# 								  ["google", "France", "yes", 23, "Premium"],
	# 								  ["digg", "USA", "yes", 24, "Basic"],
	# 								  ["kiwitobes", "France", "yes", 23, "Basic"],
	# 								  ["slashdot", "France", "yes", 19, "None"],
	# 								  ["digg", "New Zealand", "yes", 12, "Basic"],
	# 								  ["google", "UK", "yes", 18, "Basic"],
	# 								  ["kiwitobes", "France", "yes", 19, "Basic"]]
	# 	end

	# 	it 'should return 1.5052408149441479 with the OREILLY_DATA set' do
	# 		@c.entropy(@c.data).should be_within(1.0e-7).of(1.5052408149441479)
	# 	end

	# 	it 'should return 1.2987949406953985 for the true_set (from OREILLY_DATA)' do
	# 		@c.entropy(@true_set).should be_within(1.0e-07).of(1.2987949406953985)
	# 	end 

	# end

end