# Htmlcuke

A custom Html formatter for Cucumber that provides specific functionality.
This formatter removes (if necessary) any color codes wrapped around puts statements within a suite that is using the colorized or similar gem.
The formatter also embeds a screenshot link of the last window focused in a failed test and opens the shot in a new tab upon clicking the link.

## Installation

Add this line to your application's Gemfile:

    gem 'htmlcuke'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install htmlcuke

## Usage

To use:

This usage case assumes you have the directories ```reports``` and ```reports/screens``` located in the same directory within which your test will run.

Add ```--format Htmlcuke::Formatter --out reports/cucumber_$(date '+%Y.%m.%d-%H.%M.%S').html``` to your cucumber.yml, Rakefile, or command line arguments.

The --out assumes you will output the .html files to the reports directory under the naming convention cucumber + timestamp, feel free to change this as you see fit.

A sample after hook in hooks.rb would be:

```ruby
After do |scenario|
  Dir::mkdir('reports') unless File.directory?('reports')
  Dir::mkdir('reports/screens') unless File.directory?('reports/screens')
  if scenario.failed?
    if scenario.respond_to?('scenario_outline')
      screenshot = "./results/FAILED_#{(scenario.scenario_outline.title + ' ' + scenario.name).gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      screenshot_format = "./reports/screens/FAILED_#{(scenario.scenario_outline.title + ' ' + scenario.name).gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    else
      screenshot = "./results/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      screenshot_format = "./reports/screens/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
    end
    ```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/htmlcuke/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
