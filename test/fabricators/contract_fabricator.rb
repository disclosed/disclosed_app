Fabricator(:contract) do
 url              "http://www.oag-bvg.gc.ca/internet/English/contract/1234.html"
  vendor_name      "Company Inc."
  effective_date   "2014-05-24"
  reference_number { sequence(:reference_number) { |i| "P485984#{i}" } } 
  description      "0472 Information Technology consultants"
  raw_contract_period  "2014-04-24 to 2014-05-24"
  value            131250
  comments         "To provide the services of a project manager for th eimplementation of the Records Documents and Information Management System."
  agency
end
