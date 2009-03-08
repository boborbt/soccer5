feed_update =    @matches.first.last_changed_invitation &&
                 @matches.first.last_changed_invitation.updated_at ||
                 @matches.first.created_at

atom_feed do |feed|
  feed.title("calcetto-martedì")
  feed.updated(feed_update)

  for match in @matches
    match_update =  match.last_changed_invitation &&
                    match.last_changed_invitation.updated_at  ||
                    match.created_at
    
    feed.entry(match, {:id => match.id.to_s + match_update.to_s, :updated => match_update}) do |entry|
      last_changed_invitation = match.last_changed_invitation
      invitations_status = match.invitations.map { |invitation| invitation.player.name+" "+invitation.status }.join('<br>')
      
      unless match.last_changed_invitation.nil?
        content = invitations_status + '<br>' + '<strong>last change: </strong>' + 
          last_changed_invitation.player.name+" "+last_changed_invitation.status + 
          ' at ' + last_changed_invitation.updated_at.to_s
      end
      
      entry.title(match.description)
      entry.content(content, :type => 'html')
      entry.author('bobo')
      entry.summary('test')
    end
  end
end
