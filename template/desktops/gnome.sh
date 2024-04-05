# Turn off screensaver
gconftool-2 --set -t boolean /apps/gnome-screensaver/idle_activation_enabled false

# Use browser window instead in nautilus
gconftool-2 --set -t boolean /apps/nautilus/preferences/always_use_browser true

if [ -z ${XDG_CONFIG_HOME+x} ]
then
  CONFDIR=${HOME}/.config
else
  CONFDIR=${XDG_CONFIG_HOME}
fi

# Disable the disk check utility on autostart
mkdir -p "${CONFDIR}/autostart"
cat "/etc/xdg/autostart/gdu-notification-daemon.desktop" <(echo "X-GNOME-Autostart-enabled=false") > "${CONFDIR}/autostart/gdu-notification-daemon.desktop"

# Remove any preconfigured monitors
if [[ -f "${CONFDIR}/monitors.xml" ]]; then
  mv "${CONFDIR}/monitors.xml" "${CONFDIR}/monitors.xml.bak"
fi

# Start up Gnome desktop (block until user logs out of desktop)
/etc/X11/xinit/Xsession gnome-session
