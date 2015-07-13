# Register a callback
#   notifier = ScraperNotifier.new
#   notifier.on(:scraping_page, -> (args) { puts "Scraping page #{args}" })
#
# Trigger an event
#   notifier = ScraperNotifier.new
#   notifier.trigger(:scraping_page, "http://something.com")
class ScraperNotifier
  def initialize
    @callbacks = {}
  end

  def trigger(event_name, *args)
    @callbacks[event_name.to_sym].each do |callback|
      callback.call(args)
    end
  end

  def on(event_name, callback)
    @callbacks[event_name.to_sym] ||= []
    @callbacks[event_name.to_sym].push(callback)
  end
end
