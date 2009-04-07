if Match.last(:order => 'date ASC').date < Date.today
  match = Match.clone_match_from_last_one
  match.save!
  
  logger.info("OPEN-MATCH-SCRIPT::opening match:#{match.description}")
  puts "Opened match #{match.description}"
end