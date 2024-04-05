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

# Copy over default panel if doesn't exist, otherwise it will prompt the user
PANEL_CONFIG="${CONFDIR}/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
if [[ ! -e "${PANEL_CONFIG}" ]]; then
  mkdir -p "$(dirname "${PANEL_CONFIG}")"
  cp "${XFCE_ROOT}/etc/xdg/xfce4/panel/default.xml" "${PANEL_CONFIG}"
  cp "${XFCE_ROOT}/etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml" "$(dirname "${PANEL_CONFIG}")"
fi

# start dbus and set the system bus address to the host's
export DBUS_SYSTEM_BUS_ADDRESS=unix:path=/var/run/dbus/system_bus_socket
export `dbus-launch`

# Disable startup services
xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -n -t bool -s false

# Run Xfce4 Terminal as login shell (sets proper TERM)
TERM_CONFIG="${CONFDIR}/xfce4/terminal/terminalrc"
if [[ ! -e "${TERM_CONFIG}" ]]; then
  mkdir -p "$(dirname "${TERM_CONFIG}")"
  sed 's/^ \{4\}//' > "${TERM_CONFIG}" << EOL
    [Configuration]
    CommandLoginShell=TRUE
EOL
else
  sed -i \
    '/^CommandLoginShell=/{h;s/=.*/=TRUE/};${x;/^$/{s//CommandLoginShell=TRUE/;H};x}' \
    "${TERM_CONFIG}"
fi

# Start up xfce desktop (block until user logs out of desktop)
xfce4-session
