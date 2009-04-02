# autoinvitation script

logger = RAILS_DEFAULT_LOGGER

logger.info('AUTOINVITE-SCRIPT:: Analyzing possible (auto)invitations needing to be sent...')
Match.all_open_matches.each do |match|
  next if match.date < Date.today # skippying past matches
  
  logger.info("AUTOINVITE-SCRIPT::sending invitations for match:#{match.description}")
  match.autoinvite_players!
end