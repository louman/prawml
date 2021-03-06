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

Describe in an yaml file the fields and its xpos, ypos and style/type options:

```yaml
# example.yml
text1:
  - [250, 680, {style: bold, align: center, size: 96, font: 'Helvetica'}]
  - [220, 0]
text2: [415, 660, {style: italic, size: 16,align: right, color: '123456'}]
barcode1: [100, 15, {type: 'barcode', symbology: 'code_25_interleaved'}]
```
PDF generation example:

```ruby
pdf = Prawml::PDF.new('path_to_yaml/example.yml')
pdf.generate({
    :text1 => 'Prawml',
    :text2 => 'The pdf generator',
    :barcode1 => 'My little barcode string'
}).render_file('example.pdf')
```
You can also pass an object that responds to methods described in YAML file.

### Available options:

* `type`: **text|image|barcode** *[text]*
* `color`: **RGB color** *[00000]*
* `fixed`: **A fixed text. Ignores values and renders the static text informed** *[false]*

##### Text specific options:
* `font`: **Any Prawn supported font can be used** *[Times-Roman]*
* `align`: **left|center|right** *[left]*
* `size`: **float** *[12]*
* `style`: **bold|normal|italic|bold_italic** *[normal]*
* `format`: **Formating hooks** (currency|date) *[false]*

##### Barcode specific options:
* `symbology`: **Symbologies available in barby gem [seen here](https://github.com/toretore/barby/wiki/Symbologies)** *[nil]*

## Contributors

1. Wanderson Policarpo (http://github.com/wpolicarpo)
2. Edson Júnior (http://github.com/ebfjunior)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

