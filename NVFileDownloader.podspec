Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '9.0'
s.name = "NVFileDownloader"
s.summary = "NVFileDownloader allows synchronous and asynchronous file downloads, with progress tracking."
s.requires_arc = true

# 2
s.version = "0.1.6"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Norberto Vasconcelos" => "n.g.vasconcelos@gmail.com" }

# 5 - Replace this URL with your own Github page's URL (from the address bar)
s.homepage = "https://github.com/NorbertoVasconcelos/NVFileDownloader"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/NorbertoVasconcelos/NVFileDownloader.git", :tag => "#{s.version}"}

# 7
s.framework = "UIKit"
s.dependency 'Alamofire'
s.dependency 'RxSwift'
s.dependency 'RxCocoa'

# 8
s.source_files = "NVFileDownloader/**/*.{swift}"

# 9
#s.resources = "NVFileDownloader/**/*.{png,jpeg,jpg,storyboard,xib}"
end
