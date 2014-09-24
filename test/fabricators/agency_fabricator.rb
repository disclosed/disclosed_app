Fabricator(:agency) do
  name "Office of the Auditor General of Canada"
  abbr {sequence(:abbr) { |i| "oag#{i}"}}
  url  "http://www.oag-bvg.gc.ca"
end
