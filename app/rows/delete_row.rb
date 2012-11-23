module Formotion
  class Form < Formotion::Base
    def on_delete(&block)
      @on_delete_callback = block
    end

    def delete
      if @on_delete_callback.nil?
        return
      end

      @on_delete_callback.call
    end
  end
end

module Formotion
  module RowType
    class DeleteRow < ButtonRow
      def after_build(cell)
        cell.backgroundColor = UIColor.redColor
      end
      
      def on_select(tableView, tableViewDelegate)
        tableViewDelegate.delete
      end
    end
  end
end
