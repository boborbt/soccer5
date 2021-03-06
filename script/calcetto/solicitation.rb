# sends soliciting mail
logger = RAILS_DEFAULT_LOGGER
logger.info('SOLICITATION-SCRIPT:: Analyzing matches (possibly) needing to be solicited...')

Match.all_waiting_matches.each do |match|
  if ((match.date - Date.today).days < match.group.solicit1_ndays.days) && match.status==Match::STATUSES[:waiting]    
    logger.info("SOLICITATION-SCRIPT:: Sending first solicitation to match #{match.description}")
    num_solicited_players = match.solicit_players!
    puts "Sent solicitations to #{num_solicited_players} players"
  end
  
  if ((match.date - Date.today).days < match.group.solicit2_ndays.days) && match.status==Match::STATUSES[:solicit1]
    logger.info("SOLICITATION-SCRIPT:: Sending second solicitation to match #{match.description}")
    num_solicited_players = match.solicit_players!.size
    puts "Sent solicitations to #{num_solicited_players} players"
  end
end