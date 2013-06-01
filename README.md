# Simple Banking App

Implementations of Simple banking app with following requirements:
Build a simple Rails banking applicatin. Containing the following
functionality:
- UI is of secondary importance
- Use console to crate users with passwords
- Enable users logins
- Use  console to check user balance
- User has an account with balance
- Users can transfer funds to other useres
- Usrs can't run a deficit
- Balances are traceable and accountable
- Funds cannot appear or diesappear
 
## Installation

This app uses PostgreSQL. So you need to crate role with corresponding privileges

    $sudo -u postgres -i "createuser -d -R -S bankir"

Clone the repo.

Install:

    $ bundle
    $ rake db:migrate

Test:

    $ rake

Run Server: 

   $ rails s

## Usage

1. Create Users in rails console
```
$ rails c

# This account is bank. So we need to put some initial funds to it.
> bank = User.create(:email => 'bank@test.com', :password => 'qwerty')
> bank.balance = 100
> bank.save


#This is regular users with balance = 0
> user_1 = User.create(:email => 'user1@test.com', :password => 'qwerty')
> user_2 = User.create(:email => 'user2@test.com', :password => 'qwerty')
```

2. Open http://127.0.0.1:3000
3. Login as bank
3. Transfer some funds to users
4. See transfers hystory here http://127.0.0.1:3000/transfers 
4. Signout and Login as user1 or user2 
5. etc...
