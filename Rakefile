require 'rspec/core/rake_task' 
require 'rubygems'
require 'dotenv'
puts ENV['ENV_NAME']
Dotenv.load("environments/#{ENV['ENV_NAME']}.env")

gem "rspec"

module TempFixForRakeLastComment
  def last_comment
    last_description
  end 
end

Rake::Application.send :include, TempFixForRakeLastComment

def new_selenium_spec_task(spec_name, spec_file)
  time = Time.new.strftime("%Y%m%d%a%H%M")
  RSpec::Core::RakeTask.new(:"#{spec_name}") do |t|
    t.pattern = "spec/*#{spec_file}*" #t.pattern = "spec/All_Spec/*#{spec_file}*"#
    t.ruby_opts = "-I lib:spec"
    t.rspec_opts = "--color"
    t.verbose = true
    t.rspec_opts = "--tty --color --format documentation --format html --out target/#{ENV['envi_name']}/#{Time.new.strftime("%m-%d-%Y")}/Single_Spec/#{spec_name.upcase}_#{time.upcase}.html"
  end
end

wd = Dir.pwd
Dir.chdir(wd + '/spec')

def create_spec_tasks
  spec_files =  Dir.glob("*_spec.rb")
  spec_names = []
  spec_files.length.times do |x|
    spec_names << spec_files[x].split('_spec.rb')
  end
  spec_names.flatten!
  spec_names.length.times do |x|
    new_selenium_spec_task("#{spec_names[x]}","#{spec_files[x]}")
  end
end

create_spec_tasks
Dir.chdir(wd)
