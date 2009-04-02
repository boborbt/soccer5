# sends soliciting mail
logger = RAILS_DEFAULT_LOGGER
logger.info('SOLICITATION-SCRIPT:: Analyzing matches (possibly) needing to be solicited...')

Match.all_waiting_matches.each do |match|
  if ((match.date - Date.today).days < 3.days) && match.status==Match::STATUSES[:waiting]    
    logger.info("SOLICITATION-SCRIPT:: Sending first solicitation to match #{match.description}")
    match.solicit_players!
  end
  
  if ((match.date - Date.today).days < 2.days) && match.status==Match::STATUSES[:solicit1]
    logger.info("SOLICITATION-SCRIPT:: Sending second solicitation to match #{match.description}")
    match.solicit_players!
  end
end