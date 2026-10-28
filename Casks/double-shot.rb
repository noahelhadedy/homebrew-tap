cask "double-shot" do
  version "1.0.3"
  sha256 "ada58deb58ca28e104896cd2f22121fd22b2582355fdac1f58ca5e1db0f34710"

  url "https://github.com/noahelhadedy/double-shot/releases/download/v#{version}/DoubleShot-#{version}.zip"
  name "Double Shot"
  desc "Keeps your Mac awake, with the lid closed too, while your AI agents work"
  homepage "https://github.com/noahelhadedy/double-shot"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :sonoma

  app "Double Shot.app"

  # The app isn't notarized yet. Clearing the download flag lets it open without the Gatekeeper prompt.
  # Homebrew 7 uses install steps, older versions the postflight block.
  if respond_to?(:postflight_steps)
    app_path = "#{appdir}/Double Shot.app"
    postflight_steps do
      run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", app_path], must_succeed: false
    end
  else
    postflight do
      system_command "/usr/bin/xattr",
                     args: ["-dr", "com.apple.quarantine", "#{appdir}/Double Shot.app"]
    end
  end

  uninstall quit: "com.noahelhadedy.DoubleShot"

  zap trash: [
    "~/Library/Application Support/DoubleShot",
    "~/Library/Preferences/com.noahelhadedy.DoubleShot.plist",
  ]

  caveats <<~EOS
    If you turned on lid closed mode, remove its permission before uninstalling:
    open Double Shot > Settings > Lid Closed > Remove Permission.
  EOS
end
