module PlayersHelper
  def player_fields_summary(player)
    result = ""
    result += player.email.blank?           && '_'  || 'e'
    result += player.user.blank?            && '_'  || 'u'
    result += player.birth_date.blank?      && '_'  || 'd'
    result += player.birth_place.blank?     && '_'  || 'w'
    result += player.address.blank?         && '_'  || 'a'
    result += player.phone.blank?           && '_'  || 'p'
  end
  
  def player_fields_summary_description
    "e=email u=user d=birth date w=birth place a=address p=phone"
  end
end
