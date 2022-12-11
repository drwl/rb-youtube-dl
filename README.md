# RbYoutubeDL

Ruby wrapper for [youtube-dl](http://rg3.github.io/youtube-dl/), forked from [youtube-dl.rb](https://github.com/layer8x/youtube-dl.rb).

## Install the gem

Add this line to your application's Gemfile:

```ruby
gem 'rb-youtube-dl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rb-youtube-dl

## Install youtube-dl
This gem ships with the latest (working) version of youtube-dl built-in, so you don't have to install youtube-dl at all! Unless you want to.

Refer to the gem version patch and revision to see what version of youtube-dl is being bundled.

Some features of youtube-dl require ffmpeg or avconf to be installed.  Normally these are available for installation from your distribution's repositories.

## Usage

Pretty simple.

```ruby
RbYoutubeDL.download "https://www.youtube.com/watch?v=gvdf5n-zI14", output: 'some_file.mp4'
```

All options available to youtube-dl can be passed to the options hash

```ruby
options = {
  username: 'someone',
  password: 'password1',
  rate_limit: '50K',
  format: :worst,
  continue: false
}

RbYoutubeDL.download "https://www.youtube.com/watch?v=gvdf5n-zI14", options
```

Options passed as `options = {option: true}` or `options = {option: false}` are passed to youtube-dl as `--option` or `--no-option`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Pass test suite (`rake test`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

Remember: commit now, commit often.
