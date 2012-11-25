module Formotion
  module RowType
    class SpinnerRow < Base
      def after_build(cell)
        activity_view = UIActivityIndicatorView.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleGray)
        activity_view.startAnimating
        cell.setAccessoryView(activity_view)
        cell.selectionStyle = UITableViewCellSelectionStyleNone
      end
    end
  end
end
