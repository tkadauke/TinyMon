module Formotion
  module RowType
    class LabelRow < Base
      def after_build(cell)
        cell.detailTextLabel.text = row.value.to_s
        cell.selectionStyle = UITableViewCellSelectionStyleNone
      end
    end
  end
end
