namespace :build do
  desc 'Build gem.'
  task :gem do
    `gem build espnscrape.gemspec`
  end

  desc 'Build and install gem.'
  task :install do
    Rake::Task['build:gem'].execute
    file = `ls *.gem | head -n 1`
    puts `gem install #{file}`
  end

  desc 'Inject table of contents into README.md'
  task :readme do
    `ruby readme/generateReadme.rb`
  end

  desc 'Prepare gem deployment.'
  task :deployment do
    Rake::Task['rubo:fix'].execute
    puts Rake::Task['test'].execute
    puts Rake::Task['build:gem'].execute
    puts Rake::Task['rubo:html'].execute
    Rake::Task['build:readme'].execute
    Rake::Task['show_docs'].execute
  end
end

task build: ['build:install']
