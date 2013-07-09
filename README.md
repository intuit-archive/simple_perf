I use CAP for distributed jmeter or Gatling performance testing in AWS EC2.

Getting Started
---------------

Install the gem

```
gem install simple_perf
```

Create a file **~/.simple_deploy.yml** and include within it:

```
environments:
  preprod_shared_us_east_1:
    access_key: XXX
    secret_key: yyy
    region: us-east-1
    user: XXX (example: ec2-user)
    key: ~/yyy.pem (example: ~/mykeypair.pem)
```

Commands
--------

For a list of commands, run simple_perf -h.  To get more information about each subcommand, append a -h after the subcommand.  For example: **simple_perf status -h**.
