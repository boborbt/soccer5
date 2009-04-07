# autoinvitation script

logger = RAILS_DEFAULT_LOGGER

logger.info('AUTOINVITE-SCRIPT:: Analyzing possible (auto)invitations needing to be sent...')
Match.all_open_matches.each do |match|
  next if match.date < Date.today # skippying past matches
  
  logger.info("AUTOINVITE-SCRIPT::sending invitations for match:#{match.description}")
  num_players = match.autoinvite_players!.size
  
  puts "Sent autoinvitation to #{num_players} players."
end