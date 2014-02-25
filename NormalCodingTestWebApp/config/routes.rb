NormalCodingTestWebApp::Application.routes.draw do
  post "/upload.json" => "image_upload#upload"
end
