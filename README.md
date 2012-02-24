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

## Usage

### Finding contributions

The main idea behind contributions is to make it easy to add your open 
source contributions to a resume or website.  To that end, the main api 
has just to commands: `contributions_as_json` and 
`contributions_as_hash`.

There is, however, a bit to think about before you use either of these 
methods.  When you create a new instance of the `Contributions` class, 
the assumption is that you want to go ahead and find all your 
contributions and then will use one of the other commands to display 
those contributions.  But finding all your contributions is a fairly 
labor intensive task (it clones every one of the repositories you have 
contributed to and then looks at the log for each of them).  You might 
want to put this off for a few reasons: it requires too many resources, 
you want to alter the list of repositories to look at, etc.  By default, 
`Contributions.new` will determine all your contributions.  
`Contributions.new` takes a hash of arguments, and if you pass it 
`:delay => true`, it will not populate the contributions hash.

    Contributions.new(:username => 'u')
    # => # determines all the contributions for this user

    Contributions.new(:username => 'u', :delay => true)
    # => # does not determine the contributions

When you are ready, you can actually perform the contribution 
information gathering operation by using the `gather` method:

    c = Contributions.new(:username => 'u', :delay => true)
    # => # does not determine the contributions
    c.gather
    # => # gathers them up

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

    Contributions.new(:username => 'u', :except => ['homebrew'])

If you have contributed to projects that you have not forked (perhaps 
you keep a tidy github account :)), you can add those in by passing an 
array of projects to contributions:

    Contributions.new(:username => 'u', :plus => ['rubinius/rubinius'])

Notice that you must pass both the repository name and the username in 
this case.

Finally, you might want to only get your contributions to a certain set 
of repositories, ignoring any others (e.g., any others your forked).

    Contributions.new(:username => 'u', :only => ['rubinius/rubinius'])

The envisioned use case for this command is when you have lots of forked 
repositories, perhaps even ones you have contributed to, but only care 
to get your contributions for one.

### Adding or subtracting contributions

Before you determine the contributions for a user, you might need to 
alter the list of repositories you are looking at.  You can find out 
which repositories are currently being considered with the 
`repositories` method:

    c = Contributions.new(:username => 'u')
    c.repositories
    # ['rubinius/rubinius', 'mxcl/homebrew']

You can find out just the project names with the `project_names` method

    c = Contributions.new(:username => 'u')
    c.project_names
    # ['rubinius', 'homebrew']

You can subtract a repository using the `remove` method.  The `remove` 
method takes either a string (in the case of a single repository) or an 
array of strings as an argument.  The repositories should be specified 
in the username/repository pattern.

    c = Contributions.new(:username => 'u')
    c.repositories
    # ['sinatra/sinatra', 'rubinius/rubinius', 'mxcl/homebrew']
    c.remove('sinatra/sinatra')
    # ['rubinius/rubinius', 'mxcl/homebrew']
    c.remove(['rubinius/rubinius', 'mxcl/homebrew'])
    # []

You can add a repository using the `add` command.  It takes arguments 
just like `remove`.

    c = Contributions.new(:username => 'u')
    c.repositories
    # []
    c.add('sinatra/sinatra')
    # ['sinatra/sinatra']
    c.add(['rubinius/rubinius', 'mxcl/homebrew'])
    # ['sinatra/sinatra', 'rubinius/rubinius', 'mxcl/homebrew']

### Determining your contributions

Contributions are determined immediately upon creating a `Contributions` 
object unless `delay` is set to `true`.  At any time, whether they have 
been determined yet or not, you can get the contributions for a user 
with the `gather` method.

    c = Contributions.new(:username => 'u', :delay => true)
    # => # does not determine the contributions
    c.gather
    # => # gathers them up

### Getting the information out

You access commits via one of two commands: `contributions_as_json` and 
`contributions_as_hash`.  The first returns json, the second, a hash.

    c = Contributions.new(:username => 'u')
    c.repositories
    # ['sinatra/sinatra', 'rubinius/rubinius']
    c.contributions_as_json
    # => JSON data
    c.contributions_as_hash
    # => {:'sinatra/sinatra' => ["commit data", "commit data"], :'rubinius/rubinius' => ["commit data"]}


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
