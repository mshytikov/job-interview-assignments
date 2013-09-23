# Assignment1

Write a program that crawls a given website (up to 3 levels deep, maximum 50 pages) and
counts all input elements (<input…) per page. The counts per page are for the inputs on that
page plus all the inputs of the pages it refers to. Performance is a key factor so do a few
optimizations for performance, like concurrent processing of the web pages.
Don't use a gem like Anemone for this, write your own crawling functions.

Provide:
* Tests
* A command line runnable class that crawls a website

Acceptance criteria:

Input: url_of_website
Output example:

home.html - 20 inputs
contact.html - 5 inputs
products.html - 10 inputs
faq.html - 5 inputs

## Installation

    $ bundle

## Usage

```
rake solve["http://assignment1.droxbob.com"]
```

