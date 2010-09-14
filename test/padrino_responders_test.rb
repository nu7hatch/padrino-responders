require 'teststrap'

class MockApp < Padrino::Application
  include Padrino::Responders
  
  controllers :test do
    provides :html, :js
    
    get :simple do
      respond(@users = [:foo, :bar])
    end 
    
    post :creator do 
    end
    
    put :updater do 
    end
    
    delete :destroyer do 
    end
  end
end

context "Padrino responders plugin" do 
  subject {}
end
