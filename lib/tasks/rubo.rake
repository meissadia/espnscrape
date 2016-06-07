namespace :rubo do
  desc 'Generate Rubocop HTML report'
  task :html do
    htmlReport
  end

  desc 'Autofix Issues'
  task :fix do
    `rubocop -a`
    htmlReport
  end

  desc 'Regenerate To Do .yml'
  task :autogen do
    `rubocop --auto-gen-config`
  end
end

def htmlReport
  `rubocop -f html --out rubocop/report.html`
end
