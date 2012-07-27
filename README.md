# Prawml

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'prawml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prawml

## Usage

Describe in an yaml file the fields and its xpos, ypos and style/type params:

```yaml
# example.yml
text1: [20, 15, {style: bold, color: '000000', size: 12}] 
text2: [20, 42]
```
### PDF generation example:

```ruby
pdf = Prawml.new('path_to_yaml/example.yml')
pdf.generate({
    :text1 => 'Prawml',
    :text2 => 'The pdf generator'
})
pdf.render_file('example.pdf')
```

### Available params:

* `style`: **bold|normal|italic|bold_italic** *[normal]*
* `size`: **float** *[12]*
* `align`: **left|center|right** *[left]*
* `font`: **Prawn supported fonts** *[Times-Roman]*
* `color`: **RGB color** *[00000]*
* `fixed`: **A fixed text** *[false]*
* `format`: **Formating hooks** (currency|date) *[false]*
* `type`: **text|image|codebar** *[text]*

## Contributors

1. Wanderson Policarpo (http://github.com/wpolicarpo)
2. Edson Júnior (http://github.com/ebfjunior)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

