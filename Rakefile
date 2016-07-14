require 'rake/testtask'
Dir.glob('lib/tasks/*.rake').each { |r| load r }

Rake::TestTask.new do |t|
  t.libs << 'test'
end

desc 'Run tests'
task default: :test

desc 'Open documentation'
task :show_docs do
  ['README.md', 'CHANGELOG.md', 'coverage/index.html', 'rubocop/index.html'].each do |doc|
    `open #{doc} -a "Google Chrome"`
  end
end
