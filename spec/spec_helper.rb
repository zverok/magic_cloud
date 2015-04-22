# encoding: utf-8
$:.unshift 'lib'
require 'magic_cloud'

require 'rspec/its'
require 'faker'

RSpec::Matchers.define :be_one_of do |expected|
  match do |actual|
    expected.include?(actual)
  end
end

RSpec::Matchers.define :be_covered_with do |expected|
  match do |actual|
    expected.cover?(actual)
  end
end
