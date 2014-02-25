class ImageUploadController < ApplicationController
  
  def upload
    model_url = nil
    
    # TODO this would ideally happen asynchronously as a background job
    if params["file"]
      model_url = Oscad::generate_rgb_model!(params["file"].tempfile.path)
    end
    
    respond_to do |format|
      if model_url
        format.json { render json: {:success => "true", :model_url => model_url}, status: 200 }
      else
        format.json { render json: {:success => "false"}, status: 200}
      end
    end
  end
  
end
