# close matches after the match date OR when the number of players reaches 10

(Match.all_matches_not_closed).each do |match|
  # do nothing if the match date is still to come AND the number of coming players
  #    is still less than the required players 
  next if Date.today <= match.date && match.number_of_coming_players < match.max_players
  
  puts "closing match #{match.description}"
  match.close_convocations!
end