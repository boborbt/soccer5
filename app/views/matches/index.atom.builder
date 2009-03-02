atom_feed do |feed|
  feed.title("calcetto-martedì Atom feed")
  feed.updated(@matches.first.last_changed_invitation.updated_at)

  for match in @matches
    feed.entry(match) do |entry|
      invitation = match.last_changed_invitation
      
      entry.title(match.description)
      entry.content(invitation.player.name+" "+invitation.status, :type => 'html')
      entry.updated(invitation.updated_at)
    end
  end
end
