	     _        _
	    (\\.-""-.//)
	     /        \    /)     _____                             __                    
	     \o      o/   ((     / ___/______________ _____  __  __/ /_  ____ __________ _
	     /\      /\    ))    \__ \/ ___/ ___/ __ `/ __ \/ / / / __ \/ __ `/ ___/ __ `/
	    /==\ () /==\  //    ___/ / /__/ /  / /_/ / /_/ / /_/ / /_/ / /_/ / /  / /_/ / 
	   |    `UU`    |//    /____/\___/_/   \__,_/ .___/\__, /_.___/\__,_/_/   \__,_/  
	   |            |/                         /_/    /____/
	 .-'\          /'-.
	(((` ) |----| ( `)))
	    (((`    `)))

# Scrapybara
### A modular web scraping framework based on [capybara](https://github.com/jnicklas/capybara), [capybara-webkit](https://github.com/thoughtbot/capybara-webkit), and [poltergeist](https://github.com/jonleighton/poltergeist)

## Features

* Capabara DSL and drivers
* Modular plugins for scraping specific sites
* Additional utility methods to simplify your scraping efforts

## Install

### Requirements

* Ruby 1.9/2.0
* libxml2
* libxslt
* Qt (*capybara-webkit)
* PhantomJS (*poltergeist)

## Using Bundler

The simplest way to install Scrapybara is to use Bundler.

Add Scrapybara to your Gemfile:

```ruby
gem 'scrapybara'
```

Or install the gem manually:

```sh
gem install scrapybara
```

## Usage

### Tutorial

**Note** *You'll need to manually load it from irb until this is packaged as a gem. For example:

```sh
cd /path/to/scrapybara
irb -Ilib -rscraper
```

You can now access the libraries inside IRB:

```ruby
scraper = Scraper::Edgar.new
#=> #<Scraper::Edgar:0x007fbf478f73a8 @app_host="http://www.sec.gov">

# import most recent filings
scraper.import_filings

# import filings for given day
scraper.import_filings(Date.new(2012,12,21))

# query mongoid db using a named scope, see more: http://mongoid.org/en/mongoid/docs/querying.html
form_10ks = Scraper::Edgar::Filing.form_10k

# view documents for given filing:
most_recent_10k = Scraper::Edgar::Filing.form_10k.last

most_recent_10k.documents
#=> []
```

## Documentation

Generate it: 

```sh
  yardoc 'lib/*.rb' 'lib/**/*.rb' 'lib/**/**/*.rb'
```

## To do

* better test coverage
* more field validations of models
* more plugins

## Contributing

A lot of new contributors ask "Well, where do I start?". Below are some links to comprehensive resources for newcomers to get up to speed and get dive right in to fixing bugs and adding features.

### How to Contribute the Right Way

We try to stick to a set of guidelines when it comes to contributing code. When you're writing a bugfix or custom code from scratch, it's good practice to ask yourself:

* Does my code have [tests](https://github.com/jgrevich/scrapybara/wiki/Testing-workflow)?
* Am I sticking to the [Git Workflow](https://github.com/jgrevich/scrapybara/wiki/Git-Workflow) the best I can?

### Other helpful resources

Below are some relevant links to other parts of the wiki. We're currently restructuring everything, so the below links may be subject to change.

* [How to work with Pull Requests](https://github.com/jgrevich/scrapybara/wiki/Merging-Pull-Requests)
* [An Overview of Required Ruby Gems](https://github.com/jgrevich/scrapybara/wiki/Overview-of-Required-Gems)
* [How to get a dev environment set up](https://github.com/jgrevich/scrapybara/wiki/Installing-and-Running)
* [How to Report a Bug](https://github.com/jgrevich/scrapybara/wiki/Report-a-Bug)
* [A Detailed Introduction to the Source Code](https://github.com/jgrevich/scrapybara/wiki/An-Introduction-to-the-Source-Code)

*Thank you [Diaspora project](https://github.com/diaspora/diaspora) for the basic ideas on how to structure the README and wikis*

## Ruby Interpreter Compatibility

Scrapybara has been tested on the following ruby interpreters:

* MRI 1.9.3
* MRI 2.0.0

## Development

* Source hosted on [GitHub](https://github.com/jgrevich/scrapybara).
* Direct questions and discussions to the [IRC channel](irc://irc.freenode.net/scrapybara)
* Report issues on [GitHub Issues](https://github.com/jgrevich/scrapybara/issues).
* Pull requests are very welcome! Please include spec and/or feature coverage for every patch,
  and create a topic branch for every separate change you make.
* See the [Contributing](https://github.com/jgrevich/scrapybara/blob/master/README.md#Contributing)
  guide for instructions on running the specs and features.
* Documentation is generated with [YARD](http://yardoc.org/) ([cheat sheet](http://cheat.errtheblog.com/s/yard/)).
  To generate while developing:

```
yard server --reload
```
