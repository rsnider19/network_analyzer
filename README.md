# network_analyzer

### Challenges
I decided to use this exercise as an excuse to learn Ruby!

The biggest challenge was finding a Pandas-like library that 
worked the way I had envisioned the code to flow. I tried 2 
others, and finally found Polars. It enabled me to do `groupby`
and `count`, as well as grabbing the `first` record of each
group based on a specified `sort`.

Looping through each line of the file isn't ideal, but I wasn't
able to figure out a way to load the `input.txt` as csv since 
each row has a varying number of columns. It seems Polars intends
to support that eventually, but they don't right now.

### Assumptions
1. We technically don't care about the `Partner` records since we
   can grab partner from the `Contact` record.
2. When an `Employee` is declared, the `Company` referenced will be 
   previously declared in the input.
3. `Employee` names are globally unique.
4. We technically don't care about the contact type, we just care
   about the total number of Contacts between an `Employee` and 
   `Partner`.
5. The input is well-formed (i.e. no incorrectly formatted lines)

### Installation

```bash
$ brew install ruby
$ gem install bundler
$ bundle install
$ ruby network_analyzer.rb input.txt
```
