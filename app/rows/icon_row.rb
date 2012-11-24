module Formotion
  module RowType
    ICON_VIEW_TAG = 4207
    
    class IconRow < Base
      def build_cell(cell)
        @image_view = UIImageView.alloc.init
        @image_view.image = row.value if row.value
        @image_view.tag = ICON_VIEW_TAG
        @image_view.contentMode = UIViewContentModeScaleAspectFit
        @image_view.backgroundColor = UIColor.clearColor
        cell.addSubview(@image_view)
        cell.selectionStyle = UITableViewCellSelectionStyleNone

        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            # viewWithTag is terrible, but I think it's ok to use here...
            formotion_field = self.viewWithTag(ICON_VIEW_TAG)
            field_frame = formotion_field.frame
            field_frame.origin.y = 0
            field_frame.origin.x = self.frame.size.width - self.frame.size.height - 16
            field_frame.size.width  = self.frame.size.height
            field_frame.size.height = self.frame.size.height
            formotion_field.frame = field_frame
          end
        end
      end
    end
  end
end