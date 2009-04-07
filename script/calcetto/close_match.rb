# close matches after the match date OR when the number of players reaches 10
logger = RAILS_DEFAULT_LOGGER
logger.info('CLOSE_MATCH-SCRIPT:: Analyzing matches (possibly) needing to be closed...')

(Match.all_matches_not_closed).each do |match|
  # do nothing if the match date is still to come AND the number of coming players
  #    is still less than the required players 
  next if Date.today <= match.date && match.number_of_coming_players < match.max_players
  
  logger.info("CLOSE_MATCH-SCRIPT:: Closing match #{match.description}")  
  match.close_convocations!
  
  puts "Closed match #{match.description}"
end