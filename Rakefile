# frozen_string_literal: true

task default: %w[run]

task :test do
  ENV['RAKE_ENV'] = 'test'
  Dir['tests/*.rb'].each { |file| ruby file }
end

task :run do
  require_relative 'show_me_the_money'
  test_case = ShowMeTheMoney.new
  test_case.run
end
