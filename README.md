# dxruby_sdl

[![Gem Version](https://badge.fury.io/rb/dxruby_sdl.png)](http://badge.fury.io/rb/dxruby_sdl)
[![Build Status](https://travis-ci.org/smalruby/dxruby_sdl.svg?branch=master)](https://travis-ci.org/smalruby/dxruby_sdl)
[![Coverage Status](https://coveralls.io/repos/smalruby/dxruby_sdl/badge.png?branch=master)](https://coveralls.io/r/smalruby/dxruby_sdl?branch=master)
[![Dependency Status](https://gemnasium.com/smalruby/dxruby_sdl.png)](https://gemnasium.com/smalruby/dxruby_sdl)
[![Code Climate](https://codeclimate.com/github/smalruby/dxruby_sdl.png)](https://codeclimate.com/github/smalruby/dxruby_sdl)

`dxruby_sdl` is a ruby library for 2D graphics and game. It has same
DXRuby API. It use SDL/Ruby.

Current API compatibility status: http://dxruby-apis.herokuapp.com/en/

## Installation

### SDL, SGE, etc...

#### Mac OS X

(1) SDL

with MacPorts.

```
$ sudo port install libsdl libsdl_image libsdl_mixer libsdl_sound libsdl_ttf
```

with Homebrew

	# update homebrew
	$ brew update
	$ brew upgrade
	$ brew doctor

	# install sdl etc.
	$ brew install sdl
	$ brew install sdl_image
	$ brew install sdl_mixer
	$ brew install sdl_ttf

(2) SGE

	$ curl -O http://www.digitalfanatics.org/cal/sge/files/sge030809.tar.gz
	$ tar xvzf sge030809.tar.gz
	$ cd sge030809
	$ curl https://gist.github.com/steved555/963525/raw/7b638e4100f9dd1a9d00560b98ea2ddd4375b2b0/sge_030809_freetype.patch | patch
	$ curl https://gist.github.com/steved555/963524/raw/c03396e1fb8bb87e9f4ba92597d087f730c6c48b/sge_030809_cmap.patch | patch
	$ curl https://gist.github.com/steved555/963522/raw/5b277a0a6b08a1c077fbe2c96eead4ef1d761856/sge-030809-build.patch | patch
	$ sed -i -e 's/-soname/-install_name/g' Makefile
	$ make
	$ sudo make install

with Homebrew

```
$ brew install https://gist.githubusercontent.com/ymmtmdk/5b15f2b06aef5549eb5a/raw/ebf4c9758b1f772f0f6073e7b2bdbb5e9665ee74/libsge.rb
```

(3) MS PGohic (DXRuby's default font)

Install Microsoft Office:mac from http://www.microsoft.com/japan/mac.

#### Linux

```
$ sudo apt-get install libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev timidity libsdl-ttf2.0-dev libsdl-sge-dev fonts-horai-umefont fonts-ipafont
```

### dxruby_sdl

Add this line to your application's Gemfile:

```
gem 'dxruby_sdl'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install dxruby_sdl
```

## Usage

see http://dxruby.sourceforge.jp/ (in Japanese).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
