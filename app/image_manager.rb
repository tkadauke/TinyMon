class ImageManager
  def self.instance
    @instance ||= new
  end
  
  def initialize
    @obj_manager = HJObjManager.alloc.initWithLoadingBufferSize(24, memCacheSize:20)
  end
  
  def manage(image)
    @obj_manager.manage(image)
  end
end
