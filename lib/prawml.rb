require "prawml/version"
require "prawn"
require "barby/barcode/code_25_interleaved"
require "barby/outputter/prawn_outputter"

module Prawml

  class PDF
    def initialize(rules, options = nil)
        options = options || {}
        @rules = rules
        @pdf = Prawn::Document.new(
            :page_size => options[:size] || "A4",
            :page_layout => options[:layout] || :portrait
        )

        # TODO: options[:template]
        # utiliza draw_image com a imagem template
        # para forjar um template pdf
    end

    def generate(values)
        @rules.each do |field, draws|
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

            unless draws[0].is_a? Array
              draws = [draws]
            end

            draws.each do |params|
              options = defaults.merge params[2]

              params[2].merge options

              @pdf.fill_color options[:color]
              @pdf.font options[:font], options

              send :"draw_#{options[:type]}", values[field.to_sym], params
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

        barcode = Barby::Code25Interleaved.new(text)

        outputter = Barby::PrawnOutputter.new(barcode)

        # Medidas obtidas de acordo com o Manual da FEBRABAN
        # height: 36.8 (13mm)
        # xdim: 0.721 (gera largura de 103mm)
        outputter.annotate_pdf(@pdf, :height => 36.8, :xdim => 0.721, :x => xpos, :y => ypos)
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

