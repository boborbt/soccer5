module PlayersHelper
  def player_fields_summary(player)
    result = ""
    result += player.email.nil?      && '_' || 'e'
    result += player.user.nil?      && '_' || 'u'
    result += player.address.blank? && '_' || 'a'
    result += player.phone.blank?   && '_' || 'p'
  end
  
  def player_fields_summary_description
    "e=email u=user a=address p=phone"
  end
end
