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
              params[2] = defaults.merge params[2]
              send :"draw_#{params[2][:type]}", values[field.to_sym], params
            end
        end

        @pdf
    end

    protected

    def draw_text(text, params)
        xpos, ypos, options = params

        @pdf.fill_color options[:color]
        @pdf.font options[:font], options
        @pdf.draw_text text, :at => [align(text, xpos, options[:align]), ypos]
    end

    def draw_barcode(barcodes, params)
        xpos, ypos, options = params

        barcodes.inject(xpos) do |xpos, map|
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

