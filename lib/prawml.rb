require "prawml/version"
require "prawn"

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
        @rules.each do |field, params|
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

            params[2] = defaults.merge params[2]

            send :"draw_#{params[2][:type]}", values[field.to_sym], params
        end

        @pdf
    end

    protected

    def draw_text(text, options)
        params = options[2]

        @pdf.fill_color params[:color]
        @pdf.font params[:font], options[2]
        @pdf.draw_text text, :at => [align(text, options[0], params[:align]), options[1]]
    end

    def draw_barcode(barcodes, params)
        barcodes.inject(params[0]) do |xpos, map|
            @pdf.line_width map[0]
            @pdf.stroke_color map[2]
            @pdf.stroke { @pdf.vertical_line params[1], params[1] + map[1], :at => xpos }

            xpos +=  map[0]
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

