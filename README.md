# Scrapybara

### A modular web scraping framework based on capybara and poltergeist
        _        _    
	     (\\.-""-.//)  
	      /        \    /)
	      \o      o/   ((
	      /\      /\    ))
	     /==\ () /==\  //
	    |    `UU`    |//
	    |            |/
	  .-'\          /'-.
	 (((` ) |----| ( `)))
	     (((`    `)))
	
## Features

* Capabara DSL and drivers
* Modular plugins for scraping specific sites
* Additional utility methods to simplify your scraping efforts

## Install

### Requirements

* Ruby 1.9/2.0
* libxml2
* libxslt
* Qt (capybara-webkit)
* PhantomJS (poltergeist)

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

Until this is put into a gem we'll need to run this from the scraper directory as follows:

```sh
cd /path/to/financial_docs/scraper
irb -Ilib -rscraper
```

You can now access all the libraries inside the IRB shell :

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

## Contributing

A lot of new contributors that want to dive in to helping fix bugs and develop new awesome things often ask "Well, where do I start?". Below are some links to comprehensive resources so that newcomers can get up to speed and get dive right in to fixing bugs.

### How to Contribute the Right Way

Scrapybara's development tries its very best to stick to a set of guidelines when it comes to contributing code. When you're writing a bugfix or custom code from scratch, it's good practice to ask yourself:

* Does my code have [tests](https://github.com/diaspora/diaspora/wiki/Testing-workflow)?
* Am I sticking to the [Git Workflow](https://github.com/diaspora/diaspora/wiki/Git-Workflow) the best I can?

### Other helpful resources

Below are some helpful relevant links to other parts of the wiki. We're currently restructuring everything, so the below links may be subject to change.

* [How to work with Pull Requests](https://github.com/diaspora/diaspora/wiki/Merging-Pull-Requests)
* [An Overview of Required Ruby Gems](https://github.com/diaspora/diaspora/wiki/Overview-of-required-gems)
* [How to get a dev environment set up](https://github.com/diaspora/diaspora/wiki/Installing-and-Running-Diaspora)
* [How to Report a Bug](https://github.com/diaspora/diaspora/wiki/Report-a-bug)
* [A Detailed Introduction to the Source Code](https://github.com/diaspora/diaspora/wiki/An-Introduction-to-the-Diaspora-Source)

*Thank you Diaspora project for the above links/wikis*

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
