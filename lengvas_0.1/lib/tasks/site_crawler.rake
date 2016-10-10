#For staging environment.

desc "This task is called by the Heroku scheduler add-on"
task :crawl_sites => :environment do
  puts "Crawling autoplius"
  AutoListing.scrape_autoplius
  puts "Crawling autogidas"
  AutoListing.scrape_autogidas
  puts "Crawling autogidas"
  AutoListing.scrape_alio
  puts "done."
end