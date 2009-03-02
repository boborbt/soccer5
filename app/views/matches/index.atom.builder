atom_feed do |feed|
  feed.title("calcetto-martedì Atom feed")
  feed.updated(@matches.first.last_changed_invitation.updated_at)

  for match in @matches
    feed.entry(match) do |entry|
      last_changed_invitation = match.last_changed_invitation
      invitations_status = match.invitations.map { |invitation| invitation.player.name+" "+invitation.status }.join('<br>')
      content = invitations_status + '<br>' + '<strong>last changed invitation: </strong>' + 
        last_changed_invitation.player.name+" "+last_changed_invitation.status
      
      entry.title(match.description)
      entry.content(content, :type => 'html')
    end
  end
end
