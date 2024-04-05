# Turn off screensaver (this may not exist at all)
gsettings set org.mate.screensaver idle-activation-enabled false

# Disable gnome-keyring-daemon
gsettings set org.mate.session gnome-compat-startup "['smproxy']"

# Honor XDG_CONFIG_HOME if set otherwise use $HOME/.config
if [ -z ${XDG_CONFIG_HOME+x} ]
then
  CONFDIR=${HOME}/.config
else
  CONFDIR=${XDG_CONFIG_HOME}
fi

# Remove any preconfigured monitors
if [[ -f "${CONFDIR}/monitors.xml" ]]; then
  mv "${CONFDIR}/monitors.xml" "${CONFDIR}/monitors.xml.bak"
fi

# Disable useless services on autostart
AUTOSTART="${CONFDIR}/autostart"
rm -fr "${AUTOSTART}"    # clean up previous autostarts
mkdir -p "${AUTOSTART}"
for service in "gnome-keyring-gpg" "gnome-keyring-pkcs11" "gnome-keyring-secrets" "gnome-keyring-ssh" "mate-volume-control-applet" "polkit-mate-authentication-agent-1" "pulseaudio" "rhsm-icon" "spice-vdagent" "xfce4-power-manager"; do
  cat "/etc/xdg/autostart/${service}.desktop" <(echo "X-MATE-Autostart-enabled=false") > "${AUTOSTART}/${service}.desktop"
done

# Disable pulseaudio
# Warning: If you disable pulseaudio you get flooded with warning messages
#PULSE_CONFIG="${HOME}/.config/pulse/client.conf"
#mkdir -p "$(dirname "${PULSE_CONFIG}")"
#echo "autospawn = no" > "${PULSE_CONFIG}"

# Run Mate Terminal as login shell (sets proper TERM)
dconf write /org/mate/terminal/profiles/default/login-shell true

# Start up mate desktop (block until user logs out of desktop)
mate-session
