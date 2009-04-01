# sends soliciting mail
Match.all_waiting_matches.each do |match|
  if ((match.date - Date.today).days < 3.days) && match.status==Match::STATUSES[:waiting]
    puts "sending first solicitation mail"
    match.solicit_players!
  end
  
  if ((match.date - Date.today).days < 2.days) && match.status==Match::STATUSES[:solicit1]
    puts "sending second solicitation mail"
    match.solicit_players!
  end
end