# frozen_string_literal: true

module PaddedBox
  #
  # Fills the background of the box you're in
  #
  def fill_bg_color(color)
    float do
      fill_color color
      fill_rectangle [0, bounds.height], bounds.width, bounds.height
      reset_font_color
    end
  end

  #
  # Pads a bounding box by nesting another bounding_box inside it
  # Can also take bg_color as a parameter (you have to specify height for this to work)
  # Syntax:
  # padded_box([x,y], <padding:Integer>, <opts...>, :bg_color => <hex:String>) do
  #   <your block content here>
  # end
  #
  def padded_box(*args, &block)
    opt = args.extract_options!
    bg_color = opt.delete(:bg_color)
    padding = args.delete_at(1)
    bounding_box *args, opt do
      # fill_bg_color bg_color if bg_color
      # set_stroke_color 'ffffff' # Open this to clearly see the bounds set to darker hex color if needed
      bounding_box([padding, bounds.height - padding], width: bounds.width - 2 * padding, height: bounds.height - 2 * padding) do
        # stroke_bounds # Open this to clearly see the bounds
        block.call
      end
    end
  end
end
