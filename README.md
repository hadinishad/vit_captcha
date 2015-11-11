# VitCaptcha

A gem for solving the Captcha on VIT Academics page. Ruby port of [CaptchaParser](https://github.com/karthikb351/CaptchaParser).

## Installation

Make sure you have the RMagick gem installed. Then,

Add this line to your application's Gemfile:

```ruby
gem 'vit_captcha'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vit_captcha

## Usage

```ruby
require "vit_captcha"
img = Captcha.new("captcha.bmp")
captcha = img.get_captcha
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vit_captcha/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
