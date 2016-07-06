#!/usr/bin/env ruby

guard 'rake', :task => 'test' do
  %w(lib test).each do |dir|
      watch(%r{^#{dir}/(.*?).rb})
  end
end
