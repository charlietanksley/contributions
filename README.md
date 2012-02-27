# Contributions

Get the detailed information about all your OSS contributions in one 
place.

## Installation

Add this line to your application's Gemfile:

    gem 'contributions'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install contributions

## Fair Warning:

Right now, Contributions doesn't know what to do if you have more than 
100 public repositories.  I'll fix that later.  Consider yourself 
warned.

## Requirements

[![Build Status](https://secure.travis-ci.org/charlietanksley/contributions.png)](http://travis-ci.org/charlietanksley/contributions)

Contributions is known to work on:

* MRI 1.8.7
* MRI 1.9.2
* MRI 1.9.3

At present it does not work on:

* Rubinius 1.2.4

I don't know about any other Rubys.

## Usage

### Finding contributions

The main idea behind contributions is to make it easy to add your open 
source contributions to a resume or website.

A Contributions object takes a hash as an argument.  The only required 
key is `:username`.  This is the user's github username.  From here you 
have a few options.  You can manually update the list of repositories 
(see below).  When you are ready you can use the 
`.contributions_as_hash` method to return the user's contributions.

Finding all a user's contributions is very computationally intensive: we 
actually create a clone (in a temporary directory :)) of every forked 
repository and look for contributions via a `git log --author=username` 
command.  The first time you call this method it may take a while to 
return the hash (especially if you have forks of really big projects).  
Since you might want to access this hash multiple times, the result is 
cached.  If you want or need to update this for some reason, use the 
`.reload_contributions` method and then `.contributions_as_hash` to get 
the new results.

### But which projects?

By default, contributions assumes that a user has contributed to every 
forked OSS project in his or her github account.  When you generate your 
list of contributions, contributions will look for contributions in 
every forked repository in your account.  (Note: it will look not for 
additions you have made locally, but for additions that have been merged 
into the forked project; it looks for commits in that project for which 
you are either an author or committer.)

Some people have lots of forks that they don't contribute to.  In that 
case, you can pass an array of projects to ignore to contributions:

    Contributions::Contributions.new(:username => 'u', :remove => ['homebrew'])

If you have contributed to projects that you have not forked (perhaps 
you keep a tidy github account :)), you can add those in by passing an 
array of projects to contributions:

    Contributions::Contributions.new(:username => 'u', :add => ['rubinius/rubinius'])

Notice that you must pass both the repository name and the username in 
this case.

Finally, you might want to only get your contributions to a certain set 
of repositories, ignoring any others (e.g., any others your forked).

    Contributions::Contributions.new(:username => 'u', :only => ['rubinius/rubinius'])

The envisioned use case for this command is when you have lots of forked 
repositories, perhaps even ones you have contributed to, but only care 
to get your contributions for one.

### Adding or subtracting contributions

Before you determine the contributions for a user, you might need to 
alter the list of repositories you are looking at.  You can find out 
which repositories are currently being considered with the 
`repositories` method:

    c = Contributions::Contributions.new(:username => 'u')
    c.repositories
    # ['rubinius/rubinius', 'mxcl/homebrew']

You can find out just the project names with the `project_names` method

    c = Contributions::Contributions.new(:username => 'u')
    c.project_names
    # ['rubinius', 'homebrew']

You can subtract a repository using the `remove` method.  The `remove` 
method takes either a string (in the case of a single repository) or an 
array of strings as an argument.  The repositories should be specified 
in the username/repository pattern.

    c = Contributions::Contributions.new(:username => 'u')
    c.repositories
    # ['sinatra/sinatra', 'rubinius/rubinius', 'mxcl/homebrew']
    c.remove('sinatra/sinatra')
    # ['rubinius/rubinius', 'mxcl/homebrew']
    c.remove(['rubinius/rubinius', 'mxcl/homebrew'])
    # []

You can add a repository using the `add` command.  It takes arguments 
just like `remove`.

    c = Contributions::Contributions.new(:username => 'u')
    c.repositories
    # []
    c.add('sinatra/sinatra')
    # ['sinatra/sinatra']
    c.add(['rubinius/rubinius', 'mxcl/homebrew'])
    # ['sinatra/sinatra', 'rubinius/rubinius', 'mxcl/homebrew']

### Determining your contributions

    c = Contributions::Contributions.new(:username => 'u')
    # => # does not determine the contributions
    c.contributions_as_hash
    # => {:project1 => [...], :project2 => [...] ... }

### Getting the information out

You access commits via `contributions_as_hash`:

    c = Contributions::Contributions.new(:username => 'u')
    c.repositories
    # ['sinatra/sinatra', 'rubinius/rubinius']
    c.contributions_as_hash
    # => {:'sinatra/sinatra' => ["commit data", "commit data"], :'rubinius/rubinius' => ["commit data"]}


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
