class RailsstatsController < ActionController::Base
  self.template_root = File.join(RAILS_ROOT, 'vendor/plugins/rails_stats/views')
  
  TEST_TYPES = %w(Units Functionals Unit\ tests Functional\ tests Integration\ tests)

  STATS_DIRECTORIES = [
    %w(Helpers            app/helpers), 
    %w(Controllers        app/controllers), 
    %w(APIs               app/apis),
    %w(Components         components),
    %w(Functional\ tests  test/functional),
    %w(Models             app/models),
    %w(Unit\ tests        test/unit),
    %w(Libraries          lib/),
    %w(Integration\ tests test/integration)
  ].collect { |name, dir| [ name, "#{RAILS_ROOT}/#{dir}" ] }.select { |name, dir| File.directory?(dir) }

  def index
    stats = RailsStats.new(*STATS_DIRECTORIES)        

    g = Gruff::Bar.new(500)
    g.data("Lines of Code", [] << stats.code_loc << stats.tests_loc)
    g.labels = { 0 => "Code", 1 => "Tests" }
    g.write("#{RAILS_ROOT}/public/images/stats.png")
    
    g = Gruff::Pie.new(500)
    stats.statistics.each { |k,v| g.data(k, [] << v["codelines"]) unless TEST_TYPES.include? k }
    g.write("#{RAILS_ROOT}/public/images/breakdown.png")

    g = Gruff::Pie.new(500)
    stats.statistics.each { |k,v| g.data(k, [] << v["codelines"]) if TEST_TYPES.include? k }
    g.write("#{RAILS_ROOT}/public/images/tests.png")    
  end

end