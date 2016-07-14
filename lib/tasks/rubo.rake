namespace :rubo do
  desc 'Generate and display Rubocop HTML report.'
  task :html do
    htmlReport
  end

  desc 'Autofix Issues.'
  task :fix do
    `rubocop -a`
  end

  desc 'AutoFix issues and display report.'
  task :fix_report do
    Rake::Task['rubo:fix'].execute
    htmlReport
  end

  desc 'Regenerate To Do .yml'
  task :autogen do
    `rubocop --auto-gen-config`
  end
end

def htmlReport
  `rubocop -f html -D --out rubocop/report.html`
  `open rubocop/report.html`
end

task rubo: ['rubo:fix']
