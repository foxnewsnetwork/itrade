namespace :auctionhouse do
  require File.expand_path( "../../auctionhouse", __FILE__ )
  desc "Macro for installing an auction house service into the current app"
  task :install => :environment do
  	@ah = AuctionHouse.new
  	@ah.install
  end # :install
end # :auctionhouse
