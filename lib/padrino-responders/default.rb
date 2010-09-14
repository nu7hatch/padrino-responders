module Padrino
  module Responders
    ##
    # Default responder is responsible for exposing a resource to different mime 
    # requests, usually depending on the HTTP verb. The responder is triggered when
    # <code>respond</code> is called. The simplest case to study is a GET request:
    #
    #   SampleApp.controllers :examples do 
    #     provides :html, :xml, :json
    #
    #     get :index do 
    #       respond(@examples = Example.find(:all))
    #     end
    #   end
    #
    # When a request comes in, for example for an XML response, three steps happen:
    #
    #   1) the responder searches for a template at extensions/index.xml;
    #   2) if the template is not available, it will invoke <code>#to_xml</code> on the given resource;
    #   3) if the responder does not <code>respond_to :to_xml</code>, call <code>#to_format</code> on it.
    #
    # === Builtin HTTP verb semantics
    #
    # Using this responder, a POST request for creating an object could
    # be written as:
    #
    #   post :create do 
    #     @user = User.new(params[:user])
    #     @user.save
    #     respond(@user, url(:users_show, :id => @user.id))
    #   end
    #
    # Which is exactly the same as:
    #
    #   post :create do 
    #     @user = User.new(params[:user])
    #
    #     if @user.save
    #       flash[:notice] = 'User was successfully created.'
    #       case content_type
    #         when :html then redirect url(:users_show, :id => @user.id)
    #         when :xml  then render :xml => @user, :status => :created, :location => url(:users, :show, :id => @user.id)
    #       end 
    #     else
    #       case content_type
    #         when :html then render 'index/new'
    #         when :xml  then render :xml => @user.errors, :status => :unprocessable_entity 
    #       end
    #     end
    #   end
    #
    # The same happens for PUT and DELETE requests.
    #
    module Default
      
      def respond(object, location=nil, kind=nil) 
        if request.put?
          default_response_for_save(kind || 'edit', object, location)
        elsif request.post?
          default_response_for_save(kind || 'new', object, location)
        elsif request.delete?
          default_response_for_destroy(object, location)
        else
          default_response(object, location)
        end
      end

      private
        
        ##
        # Displays default template, or if it not exists then is trying to display
        # serialized object with specified response params.  
        #
        def process_rendering_chain(type, object, params={})
          render "#{controller_name}/#{action_name}"
        rescue
          render params.merge(type.to_sym => object)
        end

        ##
        # It's default response for GET requests, eg. listing, show, new, edit, etc.
        # This is basic action - when request wants html or js, then will be rendered
        # default template for action, otherwise object will be serialized to 
        # needed format. 
        #
        def default_response(object, location=nil)
          if location
            redirect location
          else
            if [:html, :js].include?(content_type)
              render "#{controller_name}/#{action_name}"
            else
              render content_type, object
            end
          end
        end
        
        ##
        # In this response we can decide where system will redirect us after successfully
        # executed action. Redirections are allowed only for html requests. If 
        # location is not specified then by default for html and js we will see 
        # template, for other formats serialised object. System also will show flash
        # message about destroyed object.  
        #
        def default_response_for_destroy(object, location=nil)
          object_notice      = "responder.messages.#{controller_name}.destroy"
          alternative_notice = "responder.messages.default.destroy"
          
          if content_type == :html && location
            notify(:notice, t(object_notice, 
              :model   => human_model_name(object),
              :default => t(alternative_notice, human_model_name(object))
              ))
            redirect location
          else
            if [:html, :js].include?(content_type)
              render "#{controller_name}/destroy"
            else
              render content_type, object, :location => location
            end
          end
        end
        
        ##
        # Default response for savings, similar to destroy response allow to store
        # redirection after success and also have automatically generated and translated 
        # flash messages. When action is successfully executed then we will see 
        # redirection or default views for html and js, and serialized object for 
        # other formats. Otherwise we will see default form view or serialized errors. 
        # 
        def default_response_for_save(kind, object, location=nil)
          valid                = false
          valid                = object.valid? if object.respond_to?(:valid?)
          default_success_view = "#{controller_name}/#{action_name}"
          default_form_view    = "#{controller_name}/#{kind}"
          object_notice        = "responder.messages.#{controller_name}.#{action_name}"
          alternative_notice   = "responder.messages.default.#{action_name}"
          
          if valid 
            case content_type
            when :html
              if location
                notify(:notice, t(object_notice, 
                  :model   => human_model_name(object),
                  :default => t(alternative_notice, human_model_name(object))
                  ))
                redirect location
              else
                render default_success_view 
              end
            when :js
              render default_success_view
            else
              render content_type, object, :location => location
            end
          else
            if [:html, :js].include?(content_type)
              render default_form_view
            else
              errors = false
              errors = object.errors if object.respond_to?(:errors)
              render content_type, errors, :status => :unprocessible_entity
            end
          end
        end
    end # Default
  end # Responders  
end # Padrino 
