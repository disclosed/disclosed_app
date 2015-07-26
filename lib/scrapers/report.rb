# Contains information about a contract report.
# agency_code - the official agency code. ex: cra, rcmp, pc
# url - the URL of the main reports page. ex: http://www.telefilm.ca/en/telefilm/corporate-publications/contracts-reports/2014/2014D.php
class Scrapers::Report < Struct.new(:agency_code, :url)
end
