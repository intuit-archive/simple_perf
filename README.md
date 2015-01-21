**!!! This project has been deprecated. We recommend you fork it or look for an alternative solution. !!!**

I use CAP for distributed jmeter or Gatling performance testing in AWS EC2.
Simple_perf is a command line interface that allows distribution of jmeter or gatling tests to multiple EC2 instances in AWS.
Tests are run on every instance through a single command (no more starting tests on individual instances).  See the [wiki](https://github.com/intuit/simple_perf/wiki/How-to-get-started-with-simple_perf) for more

Getting Started
---------------

Install the gem

```
gem install simple_perf
```

Create a file **~/.simple_deploy.yml** and include within it:

```
environments:
  preprod_us_east_1:
    access_key: XXX
    secret_key: yyy
    region: us-east-1
    user: ec2-user
    aws_keypair: EC2 Key Pair Name
    local_pem: ~/keypair.pem
```

Commands
--------

For a list of commands, run simple_perf -h.  To get more information about each subcommand, append a -h after the subcommand.  For example: **simple_perf status -h**.

Contributing
------------

####I want to help with coding
Awesome!  Simple_perf is built with Ruby.  To contribute, [fork the project](https://help.github.com/articles/fork-a-repo), make a change and submit a [pull request](https://help.github.com/articles/using-pull-requests).


####I want to report a bug
If you've found a repeatable bug, submit it in the [issues list](https://github.com/intuit/simple_perf/issues) on GitHub.  Please include the following:

*  Descriptive Title
*  Repeatable Steps
*  What happens
*  Any errors


####I want to submit a suggestion
Submit all suggestions as issues with the label *enhancement* through the GitHub [issues list](https://github.com/intuit/simple_perf/issues).

Running
-------

The commands for simple_perf can be run once the gem is installed (gem install 'simple_perf') or a gemspec is created from a local copy.
To create a local gem, do the following:

*  Fork the code
*  Clone the forked repo to your local
*  Change the version (if you've made changes and want to see them)
*  Build the gemspec 
```
gem build simple_perf.gemspec
```
*  Install the new local gem 
```
gem install /my/directory/simple_perf/simple_perf-0.0.16.gem
```

