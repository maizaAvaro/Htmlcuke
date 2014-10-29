# Htmlcuke [![htmlcuke API Documentation](https://www.omniref.com/ruby/gems/htmlcuke.png)](https://www.omniref.com/ruby/gems/htmlcuke)

A custom Html formatter for Cucumber that provides specific functionality.
This formatter removes (if necessary) any color codes wrapped around puts statements within a suite that is using the ```colorized``` or similar gem - as those codes will show up in your html report otherwise.
The formatter also embeds a screenshot link of the last window focused in a failed test and opens the shot in a new tab upon clicking the link as well as providing custom buttons with hover and switch-text click functionality to hide/show all pending, failed, or passed tests.

## Installation

Add this line to your application's Gemfile:

    gem 'htmlcuke'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install htmlcuke

## Usage

This usage case assumes you have the directories ```reports``` and ```reports/screens``` located in the same directory within which your test will run.

Add this line to your cucumber.yml, Rakefile, or command line arguments:
```
--format Htmlcuke::Formatter --out reports/cucumber_$(date '+%m-%d-%Y_%H.%M.%S').html
```

The --out assumes you will output the .html files to the reports directory under the naming convention cucumber + timestamp, feel free to change this as you see fit.

A sample after hook in hooks.rb would be:

```ruby
After do |scenario|
  Dir::mkdir('reports') unless File.directory?('reports')
  Dir::mkdir('reports/screens') unless File.directory?('reports/screens')
  if scenario.failed?
    if scenario.respond_to?('scenario_outline')
      screenshot_format = "./reports/screens/FAILED_#{(scenario.scenario_outline.title + ' ' + scenario.name).gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      screenshot_embed = "./screens/FAILED_#{(scenario.scenario_outline.title + ' ' + scenario.name).gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    else
      screenshot_format = "./reports/screens/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      screenshot_embed = "./screens/FAILED_#{(scenario.scenario_outline.title + ' ' + scenario.name).gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"

    end
    embed(screenshot_embed, 'image/png', 'Failed Screenshot')
  end
end
```

## Rake Task

Here is a sample rake task that can be used in conjunction with a tool like Jenkins - just make sure to archive the directories for the
output of your reports and screens in the job configuration.

```ruby
Cucumber::Rake::Task.new :mobile_ios_smoke_test, 'Run Cucumber smoke tests on mobile ios emulator' do |t|
  t.profile = 'automation-wip --tags ~@wip --tags ~@feature --tags @mocked'
  t.cucumber_opts = ['DEVICE=sim_ios', 'features/smoke', '--format Htmlcuke::Formatter', "--out reports/cucumber_$(date '+%m-%d-%Y_%H.%M.%S').html", '--format pretty', '--guess']
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/htmlcuke/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
