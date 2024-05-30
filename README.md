# README

## Pre-check

- For bugs, do a quick search and make sure the bug has not yet been reported

I searched both the devise and rails issues and found potentially related issues:
https://github.com/heartcombo/devise/issues/5436
https://github.com/rails/rails/pull/45033

However, this issue seems to have a different root cause than those so I decided to report it.

## Environment

- Ruby **3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-darwin23]**
- Rails **7.1.3.3**
- Devise **4.9.4**

## Steps to reproduce

1. Create a new rails application:
`rails new test_app`
2. Add devise gem
`bundle add devise -v 4.9.4`
3. Install devise
`rails generate devise install`
4. Generate a devise model with extra attributes name and original_name
`rails generate devise customers name:string original_name:string`
5. Add ActiveRecord Encryption configuration for name field to use deterministic encryption and to ignore case
`encrypts :name, deterministic: true, ignore_case: true`
6. Attempt to create the database
`bin/rails db:create`

## Current behavior

Database creation fails with this error:
```
rails db:create                                                 
bin/rails aborted!
ActiveRecord::StatementInvalid: Could not find table 'customers' (ActiveRecord::StatementInvalid)
/Users/andre/dev/devise-ar-encrypts/app/models/customer.rb:7:in `<class:Customer>'
/Users/andre/dev/devise-ar-encrypts/app/models/customer.rb:1:in `<main>'
/Users/andre/dev/devise-ar-encrypts/config/routes.rb:2:in `block in <main>'
/Users/andre/dev/devise-ar-encrypts/config/routes.rb:1:in `<main>'
/Users/andre/dev/devise-ar-encrypts/config/environment.rb:5:in `<main>'
Tasks: TOP => db:create => db:load_config => environment
(See full trace by running task with --trace)
```

## Expected behavior

Database creation should succeed:
```
rails db:create
Created database 'storage/development.sqlite3'
Created database 'storage/test.sqlite3'
```

## Sample application

I've prepared a sample application here:

It has three branches:
- main: new vanilla rails install
- devise-encrypts: devise is installed and encryption configured
- scaffold used to create model and encryption configured

Something to note is that if you remove `ignore_case: true` the database is created.

Additionally, note line 28 in `application.rb` on the devise-encrypts branch. Uncommenting that line and using the workaround suggested [here](https://github.com/rails/rails/pull/45033) allows database creation to succeed. 

There are a few things that seem different about this issue compared to one fixed in the PR:
- There are no default values for name, so I don't see how this would be a repeat of the issue in the PR
`t.string :name`
`t.string :original_name`
- Removing `null: false, default: ""` from email address and encrypted password does not prevent the issue from occurring.