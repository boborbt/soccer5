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
      invitations_status = match.invitations.sort {|i1,i2| i1.status <=> i2.status }.map do |invitation| 
        content_type = :span
        content_type = :strong if invitation.status == Invitation::STATUSES[:accepted]
        content_tag(content_type, invitation.player.name+" "+invitation.status) 
      end.join('<br>')
      
      content = invitations_status
      
      last_change = 'no inviatations yet'
      unless match.last_changed_invitation.nil?
         last_change = '<strong>last change: </strong>' + 
          last_changed_invitation.player.name+" "+last_changed_invitation.status + 
          ' at ' + last_changed_invitation.updated_at.to_s
      end
      
      content += '<br>' + content_tag(:p, 
                  '# players that accepted:'+match.number_of_coming_players.to_s )
      content += '<br>' + last_change
      
      entry.title(match.description)
      entry.content(content, :type => 'html')
      entry.author('bobo')
      entry.summary(last_change)
    end
  end
end
