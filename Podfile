platform :osx, "10.7"

pod "NTYSmartTextView"

# Copy acknowledgements to LICENSE
post_install do |installer|
  require "pathname"
  acknowledgement = Pathname.new("Pods/Pods-acknowledgements.markdown").read
  File.open("LICENSE.txt", "ab") do |file|
    file.write("\n\n")
    file.write(acknowledgement)
  end
end
