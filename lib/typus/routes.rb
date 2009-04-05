class << ActionController::Routing::Routes;self;end.class_eval do
  define_method :clear!, lambda {}
end

ActionController::Routing::Routes.draw do |map|

  map.with_options :controller => 'typus', :path_prefix => Typus::Configuration.options[:path_prefix] do |i|
    i.admin_quick_edit 'quick_edit', :action => 'quick_edit'
    i.admin_dashboard '', :action => 'dashboard'
    i.admin_sign_in 'sign_in', :action => 'sign_in'
    i.admin_sign_out 'sign_out', :action => 'sign_out'
    i.admin_sign_up 'sign_up', :action => 'sign_up'
    i.admin_recover_password 'recover_password', :action => 'recover_password'
    i.admin_reset_password 'reset_password', :action => 'reset_password'
    i.admin_set_locale 'set_locale', :action => 'set_locale'
  end

  map.namespace :admin do |admin|

    ##
    # Generate routes for resources.
    #
    Typus.resources.each do |resource|
      admin.connect "#{resource.underscore}/:action", :controller => resource.underscore, 
                                                      :path_prefix => Typus::Configuration.options[:path_prefix]
    end

    Typus.models.each do |model|

      # Collection routes depending on defined actions.
      collection = {}
      model.typus_actions_for(:index).each { |a| collection[a] = :any }

      # Member routes for edit actions
      member = {}
      model.typus_actions_for(:edit).each { |a| member[a] = :any }

      admin.resources model.tableize, :collection => collection, 
                                  :member => member, 
                                  :path_prefix => Typus::Configuration.options[:path_prefix]

    end

  end

end