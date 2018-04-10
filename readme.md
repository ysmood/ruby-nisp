## Overview

[![Build Status](https://travis-ci.org/ysmood/ruby-nisp.svg)](https://travis-ci.org/ysmood/ruby-nisp)

For more info: https://github.com/ysmood/nisp

## Installation

```
gem 'nisp'
```

## Quick start

```ruby
require 'nisp'

puts Nisp.run(
  ast: ['+', 1, 2],
  sandbox: {
    '+' => ->(a, b) { a + b }
  }
)
# output: 3
```
