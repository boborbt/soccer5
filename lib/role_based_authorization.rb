module RoleBasedAuthorization
  
  module ClassMethods; end
  def self.included(klass)
   klass.extend(ClassMethods)
   
   klass.class_eval do
     helper_method :authorize_action?
     helper_method :if_authorized?
   end
  end

  module ClassMethods
    def role_auth_rules
      @@rules||={}
      @@rules
    end
    
    def permit options 
      options[:controller] ||= controller_name
      controller = options[:controller]
      role_auth_rules[controller] ||= {}
      
      if options[:actions] == :all
        role_auth_rules[controller][:all] ||= []
        role_auth_rules[controller][:all] << RoleBasedAuthorization::Rule.new(options[:to], options[:if], options[:object_id])
        return
      end
    
      options[:actions].each do |action|
        role_auth_rules[controller][action] ||= []
        role_auth_rules[controller][action] << RoleBasedAuthorization::Rule.new(options[:to], options[:if], options[:object_id])
      end
    end  
  end
  
  # --------------------------------------------------------------------------------
  # Rule class
  # --------------------------------------------------------------------------------
  class Rule
    def initialize roles, cond, object_id
      roles = [roles] unless roles.respond_to? :each
            
      @roles = roles
      @cond = cond
      @object_id = object_id || :id
    end
    
        
    def match(user, objects)      
      RAILS_DEFAULT_LOGGER.info('Authorization system| trying '+self.inspect)
      
      matching = @roles.include?(:all)
      
      # checking for right role (no need to check them if already matching)
      matching = !@roles.find { |role| role == user.role }.nil? if !matching
      
      if @cond.nil?
        return matching
      else
        # to have a proper match, also the condition must hold
        return matching && @cond.call(user,objects[@object_id])
      end
    end
    
    def inspect
      str =  "rule(#{self.object_id}): allow roles [" + @roles.join(',') + "]"
      str += " (only under condition object_id will be retrieved using '#{@object_id}')" if @cond
      
      str
    end
  end
    
  # --------------------------------------------------------------------------------
  # Authorized method
  # --------------------------------------------------------------------------------
  
  
  # --------------------------------------------------------------------------------
  # Authorize helper method
  # --------------------------------------------------------------------------------
  def authorize_action? opts = {}  
    return false if !logged_in?
    
    opts[:ids] ||= {}
    opts[:ids].reverse_merge!( opts.reject { |k,v| k.to_s !~ /(_id\Z)|(\Aid\Z)/ } )
    
    if opts[:user].nil? && defined?(current_user)
      opts[:user] = current_user
    end
    
    if opts[:controller].nil? && defined?(controller_name)
      opts[:controller] = controller_name
    end

    logger.info("Authorization system| user %s requested access to method %s:%s using ids:%s" %
        [ opts[:user] && opts[:user].login + "(id:#{opts[:user].id})" || 'none',
          opts[:controller],
          opts[:action],
          opts[:ids].inspect])
    

    ([opts[:controller]] | ['application']).each do |controller|
      rules = self.class.role_auth_rules
    
      if( !controller.blank? && rules[controller].nil? )
        # tries to load the controller. Rails automagically loads classes if their name
        # is used anywhere. By trying to constantize the name of the controller, we
        # force rails to load it.
        controller_klass = (controller.to_s+'_controller').camelize.constantize
      end
    
      logger.info("Authorization system| current set of rules: %s" % [rules.inspect])
      logger.info("Authorization system| current controller: %s" % [controller])
    
      [:all, opts[:action]].each do |action|
        next if rules[controller].nil? || rules[controller][action].nil?            
        if rules[controller][action].find { |rule| rule.match(opts[:user], opts[:ids]) }
          logger.info('returning true')
          return true
        end 
      end
    end
    
    logger.info('Authorization system| returning false')
    return false
  end
  
  
  # This is a helper method that provides a conditional execution syntax for
  # a block of code. It is mainly useful because in most cases the same options
  # that are needed for the authorization are also needed for url generation.
  # Since this method forward those options to the block, it allows to write 
  # something like:
  # if_authorized? {:controller => xxx, :action => yyy} {|opts| link_to('yyy', opts) }
  # instead of:
  # if authorized_action? {:controller => xxx, :action => yyy}
  #    link_to 'yyy', {:controller => xxx, :action => yyy}
  # end
  # 
  # As an additional benefit, this method also accepts urls instead of parameter
  # hashes. e.g.
  # if_authorized?( '/xxx/yyy' ) { |opts| link_to('yyy', opts) }
  
  def if_authorized? opts, &block
    url_options = nil
    if opts.class == String
      url_options = ActionController::Routing::Routes.recognize_path(opts)
    else
      url_options = opts
    end
    
    if authorize_action? url_options
      block.call(opts)
    end
  end
    
  def authorized?
    authorize_action?     :controller => controller_name,  
                          :action => action_name, 
                          :ids => params.reject { |k,v| k.to_s !~ /(_id\Z)|(\Aid\Z)/ }, 
                          :user => current_user
  end
end