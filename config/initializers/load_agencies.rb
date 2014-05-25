# Load the agency information. agencies.yml should be the same as the scraper's agencies.yml file
agencies = YAML.load_file("#{Rails.root}/config/agencies.yml")
downcase_agencies = {}
agencies.each_pair { |k, v| downcase_agencies[k.downcase] = v}
AGENCIES = downcase_agencies
