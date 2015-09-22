
Pod::Spec.new do |s|

  s.name         = "RCBRightClick"
  s.version      = "0.1.3"
  s.summary      = "Easy finder integration with Right Click Booster"

  s.homepage     = "https://github.com/ConfusedVorlon/RCBRightClick"
  s.screenshots  = "https://raw.githubusercontent.com/ConfusedVorlon/RCBRightClick/master/images/simpleItem.png"

  s.license      = "MIT"

  s.author             = { "Rob" => "Rob@HobbyistSoftware.com" }

  s.platform     = :osx, "10.7"

  s.source       = { :git => "https://github.com/ConfusedVorlon/RCBRightClick.git", :tag => "0.1.3" } 
  s.source_files  = "RCBRightClick/RCBRightClick"
 
  s.requires_arc = true

end
