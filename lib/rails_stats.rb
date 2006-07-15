require 'code_statistics'

class RailsStats < CodeStatistics
  attr_reader :total, :statistics

  def code_loc
    calculate_code
  end
  
  def tests_loc
    calculate_tests
  end
  
end