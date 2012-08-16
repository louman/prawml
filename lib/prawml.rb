require "prawml/version"
require "prawn"
require "barby/outputter/prawn_outputter"
require "active_support/inflector"
require "active_support/core_ext"
require "yaml"

module Prawml

  class PDF
    def initialize(yaml, options = {})
        raise "You must pass a valid YAML file or a string with YAML to generate PDF." if yaml.empty?

        begin
          rules = File.open(yaml)
        rescue
          rules = yaml
        end
        @rules = YAML::load(rules)

        options = {
          :page_size => "A4",
          :page_layout => :portrait
        }.merge options

        @pdf = Prawn::Document.new options

        # TODO: options[:template]
        # utiliza draw_image com a imagem template
        # para forjar um template pdf
    end

    def generate(values)
        defaults = {
            :style => :normal,
            :size => 12,
            :align => :left,
            :format => false,
            :font => 'Times-Roman',
            :type => :text,
            :color => '000000',
            :fixed => false
        }

        @rules.each do |field, draws|
            unless draws[0].is_a? Array
              draws = [draws]
            end

            draws.each do |params|
              params[2] = defaults.merge(params[2] || {})
              params[2].symbolize_keys!
              params[2][:style] = params[2][:style].to_sym

              @pdf.fill_color params[2][:color]
              @pdf.font params[2][:font], params[2]

              send :"draw_#{params[2][:type]}", values[field.to_sym], params
            end
        end

        @pdf
    end

    protected

    def draw_text(text, params)
        xpos, ypos, options = params

        @pdf.draw_text text, :at => [align(text, xpos, options[:align]), ypos]
    end

    def draw_barcode(text, params)
        xpos, ypos, options = params

        begin
          symbology = options[:symbology].to_s

          require "barby/barcode/#{symbology}"

          barby_module = "Barby::#{ActiveSupport::Inflector.camelize(symbology)}"

          barcode = ActiveSupport::Inflector.constantize(barby_module).new(text)

          outputter = Barby::PrawnOutputter.new(barcode)
          outputter.annotate_pdf(@pdf, options.merge({:x => xpos, :y => ypos}))
        rescue LoadError
          raise "Symbology '#{symbology}' is not defined. Please see https://github.com/toretore/barby/wiki/Symbologies for more information on available symbologies."
        end
    end

    def draw_image(image, params)
      # TODO:
      # image: path da imagem
      # [x, y, {width, height}]
    end

    private

    def align(text, position, alignment)
        font = @pdf.font
        width = font.compute_width_of(text.to_s)

        case alignment
        when :center then
            position - width/2
        when :right then
            position - width
        else
            position
        end
    end
  end

end