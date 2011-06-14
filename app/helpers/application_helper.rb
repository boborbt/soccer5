# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def spinner_box
    %Q{<div id="spinner" style="display:none">
    	<div class="content">#{image_tag 'spinner_big.gif'}</div>
    </div>}
  end
  
  def show_spinner
    %q{$('spinner').appear( {duration:0.5})}
  end
end
