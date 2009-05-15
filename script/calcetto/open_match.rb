logger = RAILS_DEFAULT_LOGGER

groups = Group.find_all_by_autocreate_matches(true)

groups.each do |group|
  next if group.matches.empty?
  
  if group.matches.last(:order => 'date ASC').date < Date.today
    match = Match.clone_match_from_last_one(group)
    match.save!
  
    logger.info("OPEN-MATCH-SCRIPT::opening match:#{match.description}")
    puts "Opened match #{match.description}"
  end
end