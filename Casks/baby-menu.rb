cask "baby-menu" do
  version "0.1.25"
  sha256 "f63530969a4153e78c0986603517aa4d5f054264ab972fff8a054f93866c0723"

  url "https://github.com/vicolby/baby-menu/releases/download/baby-menu-v0.1.25/Baby-Menu-0.1.25-universal.dmg"
  name "Baby Menu"
  desc "Menu-bar app that writes its own widgets"
  homepage "https://github.com/vicolby/baby-menu"

  depends_on macos: :ventura

  app "Baby Menu.app"
  uninstall quit: "com.vicolby.baby-menu"

  uninstall_preflight do
    next unless system("/usr/bin/pgrep", "-x", "Baby Menu", out: File::NULL, err: File::NULL)

    system_command "/usr/bin/nohup", args: ["/bin/sh", "-c", <<~RELAUNCH_SCRIPT], must_succeed: false
      (
        while [ -e "#{appdir}/Baby Menu.app" ]; do
          /bin/sleep 1
        done

        for _ in $(/usr/bin/seq 1 60); do
          if [ -x "#{appdir}/Baby Menu.app/Contents/MacOS/Baby Menu" ]; then
            /usr/bin/open -a "#{appdir}/Baby Menu.app"
            exit 0
          fi
          /bin/sleep 1
        done
      ) >/dev/null 2>&1 &
    RELAUNCH_SCRIPT
  end

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-cr", "#{appdir}/Baby Menu.app"],
                   must_succeed: false
  end

  zap trash: [
    "~/.baby-menu",
    "~/Library/Preferences/com.vicolby.baby-menu.plist",
  ]
end
