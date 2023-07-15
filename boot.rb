# frozen_string_literal: true

require 'bundler/setup'
groups_to_require = [:default]
groups_to_require << :test if ENV['TEST']
Bundler.require(*groups_to_require)

require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/enumerable'
require 'active_support/core_ext/object/blank'

loader = Zeitwerk::Loader.new
loader.push_dir("#{__dir__}/lib")
loader.push_dir("#{__dir__}/models")
loader.setup
