atom_feed do |feed|
  feed.title("Match Atom feed")
  feed.updated(@matches.first.created_at)

  for match in @matches
    feed.entry(match) do |entry|
      entry.title(match.date)
      entry.content("this is the content", :type => 'html')
      entry.updated(Time.now)
    end
  end
end
