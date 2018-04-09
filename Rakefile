require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc 'Run tests'
task default: :test

desc 'Publish gem'
task :publish do
  sh 'gem build nisp.gemspec'
  sh "gem push #{Dir['*.gem'].first}"
end
