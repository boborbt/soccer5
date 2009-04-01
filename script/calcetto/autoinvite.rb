# autoinvitation script

(Match.all_open_matches - Match.all_waiting_matches).each do |match|
  next if match.date < Date.today # skippying past matches
  
  puts "sending invitations for match:#{match.description}"
  match.autoinvite_players!
end