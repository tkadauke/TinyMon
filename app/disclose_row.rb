module Formotion
  class Form < Formotion::Base
    def on_select(&block)
      @on_select_callback = block
    end

    def select(key)
      if @on_select_callback.nil?
        return
      end

      @on_select_callback.call(key)
    end
  end
end

module Formotion
  module RowType
    class DiscloseRow < Base
      def after_build(cell)
        cell.detailTextLabel.text = row.value.to_s
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator
      end
      
      def on_select(tableView, tableViewDelegate)
        tableViewDelegate.select(row.key)
      end
    end
  end
end
